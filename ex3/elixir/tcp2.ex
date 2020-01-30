defmodule TCP do
	@server %{ip: {10, 100, 23, 242}, port: 33546} # Port for 0-terminated messages
	@client %{ip: {127, 0, 0, 1}, port: 9002} # Port chosen arbitrarily

	def main() do

		{:ok, socket1} = :gen_tcp.connect(@server.ip, @server.port, [])  # Connects to a server
		{:ok, listenSocket} = :gen_tcp.listen(@client.port, []) # Sets up a socket to listen on port on the local host.
		:ok = :gen_tcp.send(socket1, "Connect to: 127.0.0.1:9002\0") # Sends a packet on the socket. Asks server to establish connection

		{:ok, socket2} = :gen_tcp.accept(listenSocket, 5000) # Accepts an incoming connection request on a listening socket.
		:gen_tcp.close(socket1) #Closes a TCP socket.
		spawn(TCP, :transmit, [socket2])
		recv = spawn(TCP, :receive, [])
		:gen_tcp.controlling_process(socket2, recv)
	end

	def transmit(socket) do
		:ok = :gen_tcp.send(socket, "TCP ftw!\0")
		:timer.sleep(2000)
		transmit(socket)
	end

	def receive() do
		receive do
			{:tcp, _socket, data} ->
			IO.puts(data)
		end
		receive()
	end
end

