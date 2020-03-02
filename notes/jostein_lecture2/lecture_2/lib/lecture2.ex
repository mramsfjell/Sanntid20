defmodule Lecture2 do
	def start do
		
		children = [
			AtomicStack
		]

		Supervisor.start_link(children, strategy: :one_for_one)
	end
end
