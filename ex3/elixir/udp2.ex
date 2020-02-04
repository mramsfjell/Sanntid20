defmodule UDP do

	local_addr = 158 # Local IP
	@server %{ip: {10, 100, 23, 147}, port: 30000} # Port for broadcasts 
	@client %{ip: {10, 100, 23, local_addr}, port: 20024} # Port for server UDP 

	def listen_init do

		{:ok, socket_broadcast} = :gen_udp.open(@server.port) # broadcast port
				
		{:ok, socket1} = :gen_udp.open(@client.port) # UDP assigned lab spot port

		listen_print(socket_broadcast, socket1)			
	end

	def listen_print(sock_broadcast, sock) do
		
		receive do
		#	{:udp, ^sock_broadcast, received_ip, received_port, message} ->
		#		IO.puts " Received broadcast:\n #{message}\n from (#{
		#		received_ip|>Tuple.to_list|>Enum.join(".")
		#		}:#{received_port})"
		
			{:udp, ^sock, received_ip, received_port, message} -> 
				IO.puts " Received:\n #{message}\n from (#{
				received_ip|>Tuple.to_list|>Enum.join(".")
				}:#{received_port})"
		after
			2_000 -> IO.puts "Received nothing..."
		end

		listen_print(sock_broadcast, sock)
	end

	def send(dest_ip, dest_port, message) do
		{:ok, sock_send} = :gen_udp.open(23456)
		
		:gen_udp.send(sock_send, dest_ip, dest_port, message)
		:gen_udp.close(sock_send)
	end
end
