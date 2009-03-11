module SimpleState
  module Mixins
    def self.included(klass)
      klass.class_eval <<-RUBY, __FILE__, __LINE__ + 1
        attr_reader :state unless method_defined?(:state)
        @@states = {}
        @@initial_state = nil

        unless method_defined?(:state=)
          attr_writer :state
          private :state=
        end

        extend  Singleton
        include Instance
      RUBY
    end

    ##
    # Defines singleton methods which are mixed in to a class when
    # state_machine is called.
    #
    module Singleton
      # @api private
      def states
        class_variable_get(:@@states)
      end

      # @api public
      def initial_state=(state)
        class_variable_set(:@@initial_state, state)
      end

      # @api public
      def initial_state
        class_variable_get(:@@initial_state)
      end

      # @api private
      def _determine_new_state(current, to)
        states[current] && (t = states[current].assoc(to)) && t.last
      end

      # @api private
      def _event_permitted?(current, to)
        states[current] and not states[current].assoc(to).nil?
      end
    end

    ##
    # Defines instance methods which are mixed in to a class when
    # state_machine is called.
    #
    module Instance
      ##
      # Set the initial value for the state machine after calling the original
      # initialize method.
      #
      def initialize(*args, &blk)
        super
        self.state = self.class.initial_state
      end
    end # Instance
  end # Mixins
end # SimpleState
