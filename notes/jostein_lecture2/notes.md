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

