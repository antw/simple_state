# SimpleState

Yet another state machine library for Ruby.

## Why _another_ state machine library?

There are several existing implementations of state machines in Ruby, notably
[pluginaweek/state_machine][pluginaweek], [rubyist/aasm][rubyist] and
[ryan-allen/workflow][ryanallen]. However, all felt rather heavy and
cumbersome, when all I really needed was a lightweight means for setting the
state of a class instance, and transitioning from one state to another.

There is no support for adding your own code to customise transitions, nor is
is there any support for callbacks or event guards. It's called
**Simple**State for a reason! The library adds some helper methods to your
class, keeps track of the valid states, makes sure that a transition is
permitted, and that's about it.

## Why use SimpleState?

 * Lightweight.
 * method_missing isn't used. ;)
 * No dependencies.
 * No extensions to core classes.
 * Tested on Ruby 1.8.6 (p287), 1.8.7 (p72), and 1.9.1 (p0).
 * Uses an API similar to Workflow, which I find to be more logical than that
   in the acts\_as\_state\_machine family.

## Why use something else?

 * SimpleState has no support for customising transitions with your own code.
 * No support for callbacks.
 * No support for guard conditions.
 * SimpleState forces you to use an attribute called `state` - other libraries
   let you choose whatever name you want.
 * Uses a class variable to keep track of transitions - doesn't lend itself
   all that well to subclassing your state machines.

The three libraries mentioned above have support for callbacks and guard
conditions: if you need these features then you'd be better off choosing one
of those libraries instead of SimpleState.

## Examples

    require 'rubygems'
    require 'simple_state'

    class SimpleStateMachine
      extend SimpleState  # Adds state_machine method to this class.

      state_machine do
        state :not_started do
          event :start,  :transitions_to => :started
        end

        state :started do
          event :finish, :transitions_to => :finished
          event :cancel, :transitions_to => :cancelled
        end

        state :finished
        state :cancelled
      end
    end

SimpleState makes one assumption: that the first call to `state` in the
`state_machine` block is the default state; every instance of
SimpleStateMachine will begin with the state `:not_started`.

_Note: if you define `#initialize` in your class, you should ensure that you
call `super` or the default state won't get set._

The above example declares four states: `not_started`, `started`, `finished`
and `cancelled`. If your instance is in the `not_started` state it may
transition to the `started` state by calling `SimpleStateMachine#start!`. Once
`started` it can then transition to `finished` or `cancelled` using
`SimpleStateMachine#finish!` and `SimpleStateMachine#cancel!`.

Along with the bang methods for changing an instance's state, there are
predicate methods which will return true or false depending on the current
state of the instance.

    instance = SimpleStateMachine.new  # Initial state will be :not_started

    instance.not_started? # => true
    instance.started?     # => false
    instance.finished?    # => false
    instance.cancelled?   # => false

    instance.start!

    instance.not_started? # => false
    instance.started?     # => true
    instance.finished?    # => false
    instance.cancelled?   # => false

    # etc...

It is possible for the same event to be used in multiple states:

    state :not_started do
      event :start,  :transitions_to => :started
      event :cancel, :transitions_to => :cancelled  # <--
    end
    
    state :started do
      event :finish, :transitions_to => :finished
      event :cancel, :transitions_to => :cancelled  # <--
    end

... or for the event to do something different depending on the object's
current state:

    state :not_started do
      event :start,  :transitions_to => :started
      event :cancel, :transitions_to => :cancelled_before_start  # <--
    end

    state :started do
      event :finish, :transitions_to => :finished
      event :cancel, :transitions_to => :cancelled               # <--
    end

    state :finished
    state :cancelled
    state :cancelled_before_start

## ORM Integration

SimpleState should play nicely with your ORM of choice. When an object's state
is set, `YourObject#state=` is called with a symbol representing the state.
Simply add a string/enum property called `state` to your DataMapper class, or
a `state` field to your ActiveRecord database and things should be fine. I
confess to having no familiarity with Sequel, but I don't foresee any
difficulty there either.

## License

SimpleState is released under the MIT License; see LICENSE for details.

[pluginaweek]: http://github.com/pluginaweek/state_machine (pluginaweek's state_machine library)
[rubyist]: http://github.com/rubyist/aasm (rubyist's aasm library)
[ryanallen]: http://github.com/ryan-allen/workflow (ryan-allen's Workflow library)
