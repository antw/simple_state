module SimpleState
  ##
  # Responsible for taking a state machine block and building the methods.
  #
  # The builder is run whenever you call +state_machine+ on a class and does
  # a number of things.
  #
  #   * Firstly, it adds a :state reader if one is not defined, and a
  #     _private_ :state writer.
  #
  #   * It adds a +states+ method to the class, used for easily accessing
  #     the list of states for the class, and the events belonging to each
  #     state (and the state that the event transitions to).
  #
  #   * Four internal methods +initial_state+, +initial_state=+,
  #     +_determine_new_state+ and +_valid_transition+ which are used
  #     internally by SimpleState for aiding the transition from one state to
  #     another.
  #
  class Builder
    def initialize(klass)
      @klass = klass
    end

    ##
    # Trigger for building the state machine methods.
    #
    def build(&blk)
      @klass.class_eval <<-RUBY, __FILE__, __LINE__ + 1
        include ::SimpleState::Mixins
      RUBY

      # Create an anonymous module which will be added to the state machine
      # class's inheritance chain.
      mod = @mod = Module.new
      mod.class_eval <<-RUBY, __FILE__, __LINE__ + 1
        def self.inspect
          "SimpleState::#{@klass}AnonMixin"
        end

        # Handles the change of state.
        # @api private
        def _change_state_using_event!(event)
          self.state = self.class._determine_new_state(self.state, event)
        end

        # Returns if the passed event is permitted with the instance in it's
        # current state.
        # @api public
        def event_permitted?(event)
          self.class._event_permitted?(self.state, event)
        end

        # Returns true if the given symbol matches the current state.
        # @api public
        def in_state?(state)
          self.state == state
        end
      RUBY

      # Declare the state machine rules.
      instance_eval(&blk)

      # Insert the anonymous module.
      @klass.class_eval <<-RUBY, __FILE__, __LINE__ + 1
        include mod
      RUBY
    end

    ##
    # Defines a new state.
    #
    # @param [Symbol] name
    #   The name of the state.
    # @param [Block] &blk
    #   An optional block for defining transitions for the state. If no block
    #   is given, the state will be an end-point.
    #
    def state(name, &blk)
      @klass.states[name] = []
      @klass.initial_state ||= name

      @mod.class_eval <<-RUBY, __FILE__, __LINE__ + 1
        def #{name}?           # def prepared?
          in_state?(:#{name})  #   self.state == :prepared
        end                    # end
      RUBY

      # Define transitions for this state.
      StateBuilder.new(@klass, @mod, name).build(&blk) if blk
    end

    ##
    # Responsible for building events for a given state.
    #
    class StateBuilder
      def initialize(klass, mod, state)
        @klass, @module, @state = klass, mod, state
      end

      ##
      # Specialises a state by defining events.
      #
      # @param [Block]  &blk
      #   An block for defining transitions for the state.
      #
      def build(&blk)
        instance_eval(&blk)
      end

      ##
      # Defines an event and transition.
      #
      # @param [Symbol] event_name A name for this event.
      # @param [Hash]   opts       An options hash for customising the event.
      #
      def event(event, opts = {})
        unless opts[:transitions_to].kind_of?(Symbol)
          raise ArgumentError, 'You must declare a :transitions_to state ' \
                               'when defining events'
        end

        # Keep track of valid transitions for this state.
        @klass.states[@state].push([event, opts[:transitions_to]])

        unless @module.method_defined?(:"#{event}!")
          # Example:
          #
          # def process!
          #   if self.class._transition_permitted?(self.state, :process)
          #     self.state =
          #       self.class._determine_new_state(self.state, :process)
          #   else
          #     false
          #   end
          # end
          @module.class_eval <<-RUBY, __FILE__, __LINE__ + 1
            def #{event}!
              if event_permitted?(:#{event})
                _change_state_using_event!(:#{event})
              else
                false
              end
            end
          RUBY
        end
      end
    end
  end
end
