defmodule HelloMachine do
	use Task

	def start_link [] do
		Task.start_link(HelloMachine, :hello_machine_loop, [])
	end

	def hello_machine_loop do
		:timer.sleep(3000)
		IO.puts "Hello"

		hello_machine_loop
	end
end
