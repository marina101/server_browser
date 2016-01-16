require 'socket'               

server = TCPServer.open(2000)  # Socket to listen on port 2000
loop {                         # Servers run the whole time
  socket = server.accept        # Wait for a client to connect, returns TCP socket representing connection once it gets one
  request = socket.gets
  STDERR.puts request

  elements = request.split(" ")
  
  if elements[0] == "GET"
    filename = elements[1]
    response = "Hello world! I am a server! Your file name is #{filename.to_s}"
    socket.print "HTTP/1.1 200 OK\r\n" +
               "Content-Type: text/plain\r\n" +
               "Content-Length: #{response.bytesize}\r\n" +
               "Connection: close\r\n"
    # Print a blank line to separate the header from the response body,
    # as required by the protocol.
    socket.print "\r\n"

    # Print the actual response body"
    socket.print response  
  else
    response = "Sorry, cannot perform that action"
    socket.print "HTTP/1.1 500 server_can't_do_request\r\n" +
               "Content-Type: text/plain\r\n" +
               "Content-Length: #{response.bytesize}\r\n" +
               "Connection: close\r\n"
    # Print a blank line to separate the header from the response body,
    # as required by the protocol.
    socket.print "\r\n"

    # Print the actual response body"
    socket.print response  

  end
  
  socket.close                 # Disconnect from the socket

  



  
 
  
}