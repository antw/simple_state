require File.join(File.dirname(__FILE__), 'spec_helper.rb')

# Basic State Machine ========================================================

describe SimpleState::Builder do
  before(:each) do
    @c = state_class do
      state :prepared
      state :processed
    end
  end

  it 'should add a private state writer' do
    @c.private_methods.map { |m| m.to_sym }.should include(:state=)
  end

  it 'should add a state reader' do
    @c.methods.map { |m| m.to_sym }.should include(:state)
  end

  describe 'when defining states with no events' do
    it 'should create a predicate' do
      methods = @c.methods.map { |m| m.to_sym }
      methods.should include(:prepared?)
      methods.should include(:processed?)
    end

    it 'should add the state to register' do
      @c.class.states.keys.should include(:prepared)
      @c.class.states.keys.should include(:processed)
    end
  end
end

# State Machine with Events ==================================================

describe 'when defining a state with an event' do
  before(:each) do
    @evented_state = state_class do
      state :prepared do
        event :process,           :transitions_to => :processed
        event :processing_failed, :transitions_to => :failed
      end

      state :processed
    end
  end

  it 'should add a bang method for the transition' do
    @evented_state.methods.map { |m| m.to_sym }.should \
      include(:process!)
    @evented_state.methods.map { |m| m.to_sym }.should \
      include(:processing_failed!)
  end

  it 'should add the state to register' do
    @evented_state.class.states.keys.should include(:prepared)
    @evented_state.class.states.keys.should include(:processed)
  end

  it 'should raise an argument error if no :transitions_to is provided' do
    lambda {
      Class.new do
        extend SimpleState
        state_machine do
          state(:prepared) { event :process }
        end
      end
    }.should raise_error(ArgumentError)
  end
end
