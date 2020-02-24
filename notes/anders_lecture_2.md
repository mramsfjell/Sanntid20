# Pattern 3: Distributed systems

## Unreliable communication
Communication unreliable due to:
	* Lost messages: Time doesn't happen
	* Reordered messages: Time happends in the wrong order
	* Duplicated messages: Time happens more than one time
Note how all these are written to have some _time dependence_, and "solving" this is difficult.

__Cap theorem__: You can at most two of either _Consistency_, _Availability_ and _Partitionability_. 

For the elevator project, we choose to omit some consistency.

## Dealing with inconsistency
Consistency can be defined as:
> Free from contradiction
And contradiction usually comes from negation and self-reference. Thus, to enforce consistency, we should decrease these negations and self-references.
	1. Self-reference: Not possible to have our system not refer to itself
	1. Negation: Actions similar to reverse, reset, delete, etc. can cause negation. Limiting these or having strict rules for when negation is fine is a reasonable approach. Some message acceptance rules are given below.

### When to discard messages
	1. Discard non-constant rate messages (Lockstep):  Accept only if everything is received and in the correct order (TCP)
	1. Discard non-monotonic messages (upward counter): Only accept if message is newer than what we have
	1. Accept a few non-monotonic messages (cyclic counter): Accept messages that _reset_ a counter under some condition
	1. Accept everything: All messages can overwrite everything.

### General consistency tips
	* Make as much as possible _additive_. Only add, never remove.
	* Have a single point of _negation_:, if one has to. E.g. always reset to an equal state.
	* The system is sequential by nature (not combinatorial). Treat it as such! Tips: Find I/O combinations, make state machines

## State machines in distributed systems
Analyze and find what is reqiured of Consistency, Availability and Partitioning.
If inconsitency: formulate this in terms of negation.
Formulate communication of information to be as additive as possible.
But: Distributed systems require analysis on a case-by-case basis.


# Code quality
> Most of the time we spend looking at code, is spent looking at broken code. --Anders, 2020
_Code Complete_ gives some checklists for good coding practices, but lists is not as good as the correct intuition.
What is this _intuition_, and how do we acquire it?

