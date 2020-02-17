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
```Loop:
	Input 1:
		state1: 
		state2:
		state3:
	Input 2:
		state1:
```

## 02: Testability
If asked to test a module, how easy is it? 
Very easy to make a mess of simple modules
Intuition: Testable code is good (and untestable code is bad)
What makes code testable?
* Easy: repeatable I/O-relations
* Hard: Dependencies outside of the module under test (e.g. network)
* Also hard: Unknown dependencies


