require File.join(File.dirname(__FILE__), 'spec_helper.rb')

describe "SimpleState" do
  it "should add a state_machine method to the class" do
    class StateMachineMethodTest
      extend SimpleState
    end.methods.map do |m|
      # Ruby 1.9 compat.
      m.to_sym
    end.should include(:state_machine)
  end
end
