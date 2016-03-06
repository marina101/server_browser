require 'socket'            
require 'json'

server = TCPServer.open(2000)  # Socket to listen on port 2000
loop {                         # Servers run the whole time
  socket = server.accept      # Wait for a client to connect, returns TCP
                               # socket representing connection once it gets one
  

  # Reads the header of incoming http request
  lines = []
  header = ""
  while 
    line = socket.gets
    lines.push(line)
    header += line
    break if header =~ /\r\n\r\n$/
  end 
  STDERR.puts header.to_s 

  # Assembles http response header and message based on request type
  response = ""
  tag = ""
  elements = lines[0].split(" ")
  filename = elements[1]

  if File.exist?(filename)
    
    file_contents = File.read(filename)
    tag = "200 OK"
    
    if elements[0] == "GET"
      response = file_contents

    elsif elements[0] == "POST"
      
      body = ""
      # parse out the size, in bytes, of the request body from the header
      size_line = lines[2].split(" ")
      body_size = size_line[1].to_i  
      body = socket.read(body_size.to_i)  #read the body of the message

      #parses json object and adds submitted content into original html file
      params = JSON.parse(body)
      
      people = "<li>name: #{params['person']['name']}</li><li>e-mail: " +
        "#{params['person']['email']}</li>"
      modified_file = file_contents.gsub("<%= yield %>", people) 
      response = modified_file
      tag = "200 OK"
    else
      response = "Sorry, cannot perform that action"
      tag = "500 server_can't_do_request"
    end
  else
    response = "404 Error, your file does not exit."
    tag = "404 File_not_found"
  end
  
  # Sends response back to browser:

  socket.print "HTTP/1.1 #{tag}\r\n" +
               "Content-Type: text/plain\r\n" +
               "Content-Length: #{response.bytesize}\r\n" +
               "Connection: close\r\n"
  # Print a blank line to separate the header from the response body,
  # as required by the protocol.
  socket.print "\r\n"

  # Print the actual response body"
  socket.print response 
  
  socket.close                 # Disconnect from the socket
} 
