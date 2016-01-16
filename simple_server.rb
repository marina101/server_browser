require 'socket'               

server = TCPServer.open(2000)  # Socket to listen on port 2000
loop {                         # Servers run the whole time
  client = server.accept        # Wait for a client to connect, returns TCP socket representing connection once it gets one
  client.puts(Time.now.ctime)   # Send the time to the client
  client.puts "Closing the connection. Bye!"
  client.close                 # Disconnect from the client
}