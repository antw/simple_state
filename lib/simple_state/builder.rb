module SimpleState
  ##
  # Responsible for taking a state machine block and building the methods.
  #
  class Builder
    def initialize(klass)
      @klass = klass
    end

    ##
    # Trigger for building the state machine methods. Adds a +states+ reader
    # and and a private writer if they aren't already defined.
    #
    def build(&blk)
      @klass.class_eval <<-RUBY, __FILE__, __LINE__ + 1
        attr_reader :state unless method_defined?(:state)

        unless method_defined?(:state=)
          attr_writer :state
          private :state=
        end
      RUBY

      instance_eval(&blk)
    end

    ##
    # Defines a new state.
    #
    # @param [Symbol] name
    #   The name of the state.
    # @param [Block]  &blk
    #   An optional block for defining transitions for the state. If no block
    #   is given, the state will be an end-point.
    #
    def state(name, &blk)
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
      def event(event_name, opts = {})
        unless opts[:transitions_to].kind_of?(Symbol)
          raise ArgumentError, 'You must declare a :transitions_to state ' \
                               'when defining events'
         end

        @klass.class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def #{event_name}!                        # def process!
            self.state = :#{opts[:transitions_to]}  #   self.state = :processed
          end                                       # end
        RUBY
      end
    end
  end
end
