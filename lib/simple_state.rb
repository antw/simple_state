module SimpleState
  class Error < StandardError; end
  class ArgumentError < Error; end

  ##
  # Sets up a state machine on the current class.
  #
  def state_machine(&blk)
    Builder.new(self).build(&blk)
  end
end

require 'simple_state/builder'
require 'simple_state/mixins'
