require File.join(File.dirname(__FILE__), 'spec_helper.rb')

describe SimpleState, 'generated predicate methods' do
  before(:each) do
    @predicate_test = state_class do
      state :state_one
      state :state_two
      state :state_three
    end
  end

  it 'should return true if the current state matches the predicate' do
    @predicate_test.should be_state_one
  end

  it 'should return false if the current state does not match the predicate' do
    @predicate_test.should_not be_state_two
    @predicate_test.should_not be_state_three
  end

  it 'should permit the use of super when overriding them' do
    @c = Class.new do
      attr_reader :called

      extend SimpleState

      state_machine do
        state :begin
      end

      def begin?
        @called = true
        super()
      end
    end.new

    lambda { @c.begin? }.should_not raise_error(NoMethodError)
    @c.called.should be_true
  end

  it 'should work when the state has been set to a String' do
    # ... such as might be the case when persisting the state in a DB.

    def @predicate_test.state
      'state_two'
    end

    @predicate_test.should_not be_state_one
    @predicate_test.should be_state_two
    @predicate_test.should_not be_state_three
  end
end
