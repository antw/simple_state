require File.join(File.dirname(__FILE__), 'spec_helper.rb')

# Event Validation ===========================================================

describe 'Generated event methods when the transition is valid' do
  before(:each) do
    @c = state_class do
      state :begin do
        event :go, :transitions_to => :state_one
      end

      state :state_one
    end
  end

  it 'should return the new state' do
    @c.go!.should == :state_one
  end

  it 'should transition the instance to the new state' do
    @c.go!
    @c.should be_state_one
  end
end

describe 'Generated event methods when the transition is not valid' do
  before(:each) do
    @c = state_class do
      state :begin do
        event :go, :transitions_to => :state_one
      end

      state :state_one do
        event :go_again, :transitions_to => :state_two
      end

      state :state_two
    end
  end

  it 'should return false' do
    @c.go_again!.should be_false
  end

  it "should not change the instance's state" do
    @c.go_again!
    @c.should be_begin
  end
end


# Multiple Paths Definition ==================================================

describe 'Generated event methods when mulitple states share the same event' do
  before(:each) do
    @path = state_class do
      state :begin do
        event :s1, :transitions_to => :state_one
        event :s2, :transitions_to => :state_two
      end

      state :state_one do
        event :go, :transitions_to => :state_three
      end

      state :state_two do
        event :go, :transitions_to => :state_four
      end

      state :state_three
      state :state_four
    end
  end

  it 'should transition to state_three if currently in state_one' do
    @path.s1!
    @path.go!
    @path.should be_state_three
  end

  it 'should transition to state_four if current in state_two' do
    @path.s2!
    @path.go!
    @path.should be_state_four
  end
end


# Test full workflow =========================================================
# This tests all the possible transition permutations of a state machine.

describe 'Generated event methods (integration)' do
  before(:each) do
    @c = state_class do
      state :prepared do
        event :requires_decompress, :transitions_to => :requires_decompress
        event :invalid_extension,   :transitions_to => :halted
        event :processed,           :transitions_to => :processed
        event :processing_failed,   :transitions_to => :halted
      end

      state :processed do
        event :stored,              :transitions_to => :stored
        event :store_failed,        :transitions_to => :halted
      end

      state :requires_decompress do
        event :decompressed,        :transitions_to => :complete
        event :decompress_failed,   :transitions_to => :halted
      end

      state :stored do
        event :cleaned,             :transitions_to => :complete
      end

      state :halted do
        event :cleaned,             :transitions_to => :failed
      end

      state :failed
      state :complete
    end
  end

  it 'should successfully change the state to complete via the ' \
           'intermediate states' do

    # begin -> processed -> stored -> complete

    @c.should be_prepared

    @c.processed!.should == :processed
    @c.should be_processed

    @c.stored!.should    == :stored
    @c.should be_stored

    @c.cleaned!.should   == :complete
    @c.should be_complete
  end

  it 'should successfully change the state to complete via successful ' \
     'decompress' do

    # begin -> requires_decompress -> complete

    @c.requires_decompress!.should == :requires_decompress
    @c.should be_requires_decompress

    @c.decompressed!.should == :complete
    @c.should be_complete
  end

  it 'should successfully change the state to failed via failed decompress' do
    # begins -> requires_decompress -> halted -> failed

    @c.requires_decompress!.should == :requires_decompress
    @c.should be_requires_decompress

    @c.decompress_failed!.should == :halted
    @c.should be_halted

    @c.cleaned!.should == :failed
    @c.should be_failed
  end

  it 'should successfully change the state to failed via invalid extension' do
    # begins -> halted -> failed

    @c.invalid_extension!.should == :halted
    @c.should be_halted

    @c.cleaned!.should == :failed
    @c.should be_failed
  end

  it 'should successfully change the state to failed via failed processing' do
    # begins -> halted -> failed

    @c.processing_failed!.should == :halted
    @c.should be_halted

    @c.cleaned!.should == :failed
    @c.should be_failed
  end

  it 'should successfully change the state to failed via failed storage' do
    # begins -> processed -> halted -> failed

    @c.processed!.should == :processed
    @c.should be_processed

    @c.store_failed!.should == :halted
    @c.should be_halted

    @c.cleaned!.should == :failed
    @c.should be_failed
  end
end
