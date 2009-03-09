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

      instance_eval(&blk)
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

      @klass.class_eval <<-RUBY, __FILE__, __LINE__ + 1
        def #{name}?                # def prepared?
          self.state == :#{name}    #   self.state == :prepared
        end                         # end
      RUBY

      # Define transitions for this state.
      StateBuilder.new(@klass, name).build(&blk) if blk
    end

    ##
    # Responsible for building events for a given state.
    #
    class StateBuilder
      def initialize(klass, state)
        @klass, @state = klass, state
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
      # Defines a event and transition.
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

        unless @klass.method_defined?(:"#{event}!")
          # Example:
          #
          # def process!
          #   if self.class._valid_transition?(self.state, :process)
          #     self.state =
          #       self.class._determine_new_state(self.state, :process)
          #   else
          #     false
          #   end
          # end
          @klass.class_eval <<-RUBY, __FILE__, __LINE__ + 1
            def #{event}!
              if self.class._valid_transition?(self.state, :#{event})
                self.state =
                  self.class._determine_new_state(self.state, :#{event})
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
