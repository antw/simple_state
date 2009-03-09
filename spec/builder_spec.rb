require File.join(File.dirname(__FILE__), 'spec_helper.rb')

# Basic State Machine ========================================================

class BasicStateClass
  extend SimpleState

  state_machine do
    state :prepared
    state :processed
  end
end

describe SimpleState::Builder do
  it 'should add a private state writer' do
    BasicStateClass.private_instance_methods.map { |m| m.to_sym }.should \
      include(:state=)
  end

  it 'should add a state reader' do
    BasicStateClass.instance_methods.map { |m| m.to_sym }.should \
      include(:state)
  end
end

describe 'when defining states with no events' do
  it 'should create a predicate' do
    methods = BasicStateClass.instance_methods.map { |m| m.to_sym }
    methods.should include(:prepared?)
    methods.should include(:processed?)
  end
end
