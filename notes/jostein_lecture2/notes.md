# Second Elixir lecture: With focus on OTP platforms

Certain constructs in Elixir were made to alleviate the use of boilerplate code. 
Examples of this: Tasks, GenServer, Agent.

## Mix

Create new project with
``mix new <project name>``

mix.exs is where dependencies are put.


## Agent

The Agent creates a shared variable. Start the agent with:
```elixir
{:ok, my_agent} = Agent.start_link(fn -> 1 end, [])
```

Agents only respond to anonymous functions. 
It has an initial value inside the agent of 1.
We modify the valye by sending the agent a function with `Agent.update()`:
```elixir
Agent.update(my_agent, fn state -> state + 1 end)
```

Read the state of the agent with `Agent.get()`:
```elixir
Agent.get(my_agent, fn state -> state end)
```

*Agents are not very Elixir-like, so think twice before using one.*

Example code with Agent is found in the code-folder.

#### Process registery

Elixir uses Process Identifiers (PIDs) to label processes. 
These can be hard, or seemingly "random" to use, so we use `Process.register(pid, :atom)`.
This is a registry of process identifiers that simplifies using PIDs (and makes distributed systems easier).

But what if we have multiple processes that wants to register as the same :atom in the process registry?
Can use `__MODULE__` to let the preprocessor insert the module name for us:
```elixir
Agent.start_link(fn -> 1 end, name: __MODULE__)
``` 

## Task

Tasks are used for repeated actions. 
It is a nice way to seperate repeated actions (like busy-waiting) from our more *receive-sleep* Elixir-style code.

Start a task (a function you have defined) with:
```elixir
Task.start_link(ModuleName, :process_name_from_module, [])
```
This starts the procedure `ModuleName.process_name_from_module` and runs it in the default supervision tree. See code folder for example.


## GenServer

Short for General Server. Uses mostly two functions `call()` and `cast()`. 
`call` is used to send some message to the server without expecting a reply. 
The message might be lost, much like UDP.
`cast` also sends messages, but expects a reply before continuing its execution.
When using `cast`, timeouts and other fail safes can be used.

The example we used in the lecture is heavily inspired by the GenServer chapter of the Elixir tutorial.

1. We use `start_link())` much like before.
1. Then we need an `init()` function to initialize some data structure. It is automatically called by the GenServer. 
This procedure should return the initial state of our GenServer.
1. From here we can use `handle_cast()` to implement functionality that does not return anything. 
These procedures should return a tuple on the form `{:noreply, <functionality>}` that the GenServer uses.
    1. Then we can define outward-facing function names that call on these GenServer-specific calls
1. `handle_call()` is used in a similar way to implement functions that return something.
Both of these have parameter lists and return values that conform to the GenServer "API".
See code in the code folder for examples and specific syntax details.

Note: The code written crashes *badly* on two conditions:
Popping from an empty list, and pushing a tuple (because the logger can't log a tuple).

## Supervisors

Assume our "broken" code from the GenServer-example is in production and we can't change it.
We use the supervisor by editing the mix project's "main" file (`lecture_2.ex` in our case).
In a start-function we define a children list and include that in the line
`Supervisor.start_link(<children list>, strategy: :one_for_one)`.
Jostein proposed we use `:one_for_one` as the strategy option pretty much all the time.
The only change to the AtmoicStack-file is changing `use GenServer` to `use GenServer, restart: :permanent`.

We can restart the AtomicStack structure to default values by passing a tuple on the form `{AtomicStack, [initial_value]}` to the `Supervisor.start_link()`-call.

Note: We should use supervision trees more carefully if we want to add our new module to a different project.
Also, we need to start our `AtomicStack` with `Lecture2.start` instead of the "normal" way.

If we have multiple instances of the same module running, we need to include IDs in the children-list of `Lecture2.start`.
