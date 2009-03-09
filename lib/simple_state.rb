module SimpleState
  ##
  # Sets up a state machine on the current class.
  #
  def state_machine(&blk)
    Builder.new(self).build(&blk)
  end
end

require 'simple_state/builder'
