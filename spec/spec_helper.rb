require 'rubygems'
require 'spec'

# $LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'simple_state'

##
# Creates an anonymous class which uses SimpleState.
#
def state_class(&blk)
  Class.new do
    extend SimpleState
    state_machine(&blk)
  end.new
end
