require File.join(File.dirname(__FILE__), 'spec_helper.rb')

describe SimpleState::Mixins::Instance do
  describe '#initialize' do
    it 'should set the initial state' do
      c = state_class do
        state :begin
        state :finish
      end

      c.state.should == :begin
    end

    it 'should call the original #initialize' do
      parent = Class.new do
        attr_reader :called

        def initialize
          @called = true
        end
      end

      child = Class.new(parent) do
        extend SimpleState
        state_machine do
          state :begin
        end
      end

      child.new.called.should be_true
      child.new.state.should == :begin
    end

    it 'should have separate state machines for each class' do
      class_one = state_class do
        state :one
      end

      class_two = state_class do
        state :two
      end

      class_one.class.states.keys.should == [:one]
      class_two.class.states.keys.should == [:two]
    end
  end
end
