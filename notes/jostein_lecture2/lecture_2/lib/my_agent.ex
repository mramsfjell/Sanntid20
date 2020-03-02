defmodule MyAgent do
	use Agent

	def start_link [] do
		Agent.start_link(fn -> 1 end, name: __MODULE__)
	end

	def increment do
		Agent.update(__MODULE__, fn val -> val + 1 end)
	end

	def decrement do
		Agent.update(__MODULE__, fn val -> val - 1 end)
	end

	def get_val do
		Agent.get(__MODULE__, fn val -> val end)
	end
	
end
