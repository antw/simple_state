require File.join(File.dirname(__FILE__), 'spec_helper.rb')

describe SimpleState, 'generated predicate methods' do
  it 'should return true if the current state matches the predicate' do
    test = SimpleStateTest.new
    # TODO: remove once default state is set
    test.instance_variable_set(:@state, :prepared)
    test.should be_prepared
  end

  it 'should return false if the current state does not match the predicate' do
    test = SimpleStateTest.new
    # TODO: remove once default state is set
    test.instance_variable_set(:@state, :prepared)
    test.should_not be_requires_decompress
    test.should_not be_failed
    test.should_not be_processed
    test.should_not be_stored
    test.should_not be_complete
  end
end
