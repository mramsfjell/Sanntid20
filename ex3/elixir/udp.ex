defmodule UDP do	
	@server %{ip: {10, 100, 23, 147}, port: 30000} # Port for 0-terminated messages
	@client %{ip: {10, 100, 23, 203}, port: 9999} # Port chosen arbitrarily

	def init do

		{:ok, socket1} = :gen_udp.open(@server.port)

		:gen_udp.controlling_process(socket1, self())
		
		recv(socket1)
	end

	def recv(socket) do
		{:ok, {address, port, message}} = :gen_udp.recv(socket, 0)
		IO.puts "#{inspect(message)} received from #{address} on port #{port}"
		recv(socket)
	end
end
