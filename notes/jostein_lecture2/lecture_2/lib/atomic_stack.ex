defmodule AtomicStack do
	use GenServer, restart: :permanent
	require Logger

	def start_link([]) do
		GenServer.start_link(__MODULE__, [], name: __MODULE__)
	end

	def init([]) do
		{:ok, []}
	end

	def handle_cast({:push, element}, elements) do
		Logger.info "Added element #{element} to my stack"
		{:noreply, [element | elements]}
	end

	def handle_call({:pop}, _from, [head | tail]) do
		Logger.info "Popped the value #{head} from my stack"
		{:reply, head, tail}
	end

	def push(element) do
		GenServer.cast(__MODULE__, {:push, element})
	end

	def pop() do
		GenServer.call(__MODULE__, {:pop})
	end
end
