defmodule TCP do
	@server %{ip: {10, 100, 23, 147}, port: 33546} # Port for 0-terminated messages
	@client %{ip: {10, 100, 23, 158}, port: 15024} # Port chosen arbitrarily

	def main() do
		# Sends a message to the server to connect to this machine
		TCP.transmit(@server.ip, @server.port, 
"Connect to: #{@client.ip |> Tuple.to_list |> Enum.join(".")}:#{@client.port}\0")	
		
		# Sets up a socket to listen on port on the local host
		{:ok, listenSocket} = :gen_tcp.listen(@client.port, [])

		# Accepts an incoming connection
		{:ok, socket2} = :gen_tcp.accept(listenSocket, 5000) 		
		
		:gen_tcp.send(socket2, "Testmelding! Hei på deg!!\0")
		
		# Spawns a receiving process and hands over control of the receiving socket
		TCP.receiver(socket2)
		
	end

	def transmit(address, port, message) do
		{:ok, socket} = :gen_tcp.connect(address, port, [])
		:ok = :gen_tcp.send(socket, message)

		# Closes the socket that requested the connection
		:gen_tcp.close(socket) 
	end

	def receiver(socket) do
		receive do
			{:tcp, ^socket, data} ->
				IO.puts(data)
				receiver(socket)
		after 
			30_000 -> IO.puts "Connection idle for 30 seconds. Disconnecting..."
			:gen_tcp.close(socket)
		end
	end
end

