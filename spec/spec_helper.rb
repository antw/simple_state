require 'rubygems'
require 'spec'

# $LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'simple_state'

Spec::Runner.configure do |config|
  
end

class SimpleStateTest
  extend SimpleState

  state_machine do
    state :prepared do
      event :requires_decompress, :transitions_to => :requires_decompress
      event :invalid_extension,   :transitions_to => :failed
      event :processed,           :transitions_to => :processed
      event :processing_failed,   :transitions_to => :failed
    end

    state :processed do
      event :stored,              :transitions_to => :stored
      event :store_failed,        :transitions_to => :failed
    end

    state :requires_decompress do
      event :decompressed,        :transitions_to => :complete
      event :decompress_failed,   :transitions_to => :failed
    end

    state :stored do
      event :cleaned,             :transitions_to => :complete
    end

    state :failed
    state :complete
  end
end
