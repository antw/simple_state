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
      @klass.class_eval <<-RUBY
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
      @klass.class_eval <<-RUBY
        def #{name}?                # def prepared?
          self.state == :#{name}    #   self.state == :prepared
        end                         # end
      RUBY
    end
  end
end
