require File.join(File.dirname(__FILE__), 'spec_helper.rb')

describe SimpleState, 'generated predicate methods' do
  before(:each) do
    @predicate_test = state_class do
      state :state_one
      state :state_two
      state :state_three
    end

    # TODO: remove once default state is set.
    @predicate_test.instance_variable_set(:@state, :state_one)
  end

  it 'should return true if the current state matches the predicate' do
    @predicate_test.should be_state_one
  end

  it 'should return false if the current state does not match the predicate' do
    @predicate_test.should_not be_state_two
    @predicate_test.should_not be_state_three
  end
end
