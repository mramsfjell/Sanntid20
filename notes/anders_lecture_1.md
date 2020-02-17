# 01: Design patterns
Addressing *persistent* software (runs in a loop "forever")
And *robust* software (high maintanance cost, must function under unexpected errors)
Examples:
Embedded systems, infrastructure systems, games to a certain degree

## Pattern 1: State machines
Requires that the software runs in a loop
Output depends on history of inputs
Some I/O configurations are invalid 
Goals:
1. Make a framework pattern that can
	1. Loop
	1. React conditionally to inputs based on previous I/O
	1. Make invalid states inexpressible
1. Understand this pattern in terms of
	1. Analytical and intuitive approches to applying it
	1. Why this pattern is better than the alternatives

How to make the state machine:
1. Make loop
1. Find inputs and outputs of system
	1. Defined as descrete-time
1. Persist the prev. and current I/O
	1. Goal: have as little here as possible
	1. Different ways of doing this
		* Analytical: start with all data, reduce from there
		* Intuitive: Start with as little as possible and add data as seen required
		* Smart: A bit of both
1. Minimize
	1. We _could_ perform this entirely analytically
	1. E.g. transform multiple boolians to a single integer
	1. Data you could determine later does not require logging
	1. Find invalid/undesired states and eliminate
1. React
	1. Have the required components:
		1. The set of events (inputs and outputs)
		1. The enumeration of states
		1. The undesired states we eliminated
	1. Can now create a function of the current state and present inputs that produces an action/event to go to a different state
	1. Do we trigger the switch on the current state or the inputs first?
		* Prefer input-first if most inputs mostly creates the same action
Our state machine should produce code on the format:
```
Loop:
	Input 1:
		state1: 
		state2:
		state3:
	Input 2:
		state1:
...
```

## Pattern 2: Testability
If asked to test a module, how easy is it? 
Very easy to make a mess of simple modules
Intuition: Testable code is good (and untestable code is bad)
What makes code testable?
* Easy: repeatable I/O-relations
* Hard: Dependencies outside of the module under test (e.g. network)
* Also hard: Unknown dependencies

Code can be seperated into
1. Finding out what needs to be done (algorithms, e.g.)
1. Actually doing the actions
Divide these into core and shell functions
1. Core:
	* Code with explicit I/O functions
	* No variables outside of scope
1. Shell:
	* Code that received input, and modifies state and output
	* All variables go here
	* All communication (e.g. to network, disk)
	* _hard to test_
This helps to achieve:
* a seperation of decision and action
	* allows testing without setup of external world/devices
* easy integration with state machine
[The elevator algorithm on github](https://github.com/TTK4145/Project-resources/tree/master/elev-algo/) is a good example of core/shell and [state machine](https://github.com/TTK4145/Project-resources/tree/master/elev-algo/fsm.c) structure.

### Parallel state machines (and some references to their testability)
Acceptable/required(?) to split the state machine into multiple parallell state machines. 
 Split data/utput responsibilities based on if it needs to be modified together. Get copies of data if necessary.
ex: Elevator button press:
1. Distribute request
	* Need to know who got the request
1. Assignment
	* Has to decide who takes the order
1. Execution
	* Execute the order
_a lot of things said here was missed..._

ex2: The obstructed door:
A door can fail to close due to the user pushing buttons on the same floow repeatedly or the sensor on the door is blocked.
This is a 3-state SM for one, 5-state for both:
1. Closed, Open, OpenOvertime, Obstructed, Stuck
1. Two timers: normal timeput, overtime timeout
Parallel state machines achieves:
* Fewer total states (counting each state in every SM)
* Each individual SM is easier to maintain and test
* The product of states might be larger
	* But this is not necessarily a problem because each SM can be tested individually

### Interfaces between FSMs
Goal:
* The state machines need to interact => interface required 
* As few interactions as possible
	* No shared data/references
	* Preferably no synchronization
The common ways of interfacing:
1. The object way: Input is passed to a function
	* Problems with the objects:
	1. The _objects_ doesn't do the action, the callee has to do it
	1. The calling process needs to manipulate the object directly, making it hard/impossible to parallelize
	1. If two object needs eachother how do you detemine who has responsibility for modifying? And how do you deal with the circular references?
	1. Testing the interactions requires connecting to objects (real or fake)
1. The process: Input sent as a message in a queue/channel
	* Handles most (if not all) of the above problems

_next week: distributed systems_
