require File.join(File.dirname(__FILE__), 'spec_helper.rb')

describe SimpleState, 'generated event methods' do
  before(:each) do
    @instance = SimpleStateTest.new
    # TODO: remove once default state is set
    @instance.instance_variable_set(:@state, :prepared)
  end

  describe 'when the event transition is valid' do
    it 'should return the new state' do
      @instance.processed!.should == :processed
    end

    it 'should transition to the new state declared by the event' do
      @instance.state.should == :prepared
      @instance.processed!
      @instance.state.should == :processed
    end
  end

  describe 'when the event transition is not valid' do
    it 'should return false'
    it 'should not change the state'
  end
end
