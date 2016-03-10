# Simple Server by Marina C
# This is a simple server that is mean to work with the tiny browser
# It uses sockets to listen to browser requests. The server has two files on it
# and it replies with one or the other depending on the request. The server also
# can form data from the browser, integrate it into the requested file, and then
# return the file to the browser with the received data added in.
# To close the server press control-c

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
      body = socket.read(body_size)  #read the body of the message

      #parses message body into json object 
      params = JSON.parse(body)
      
      #adds submitted content into requested html file
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

  # header
  socket.print "HTTP/1.1 #{tag}\r\n" +
               "Content-Type: text/plain\r\n" +
               "Content-Length: #{response.bytesize}\r\n" +
               "Connection: close\r\n"
  # a blank line to separate the header from the response body,
  # as required by http protocol.
  socket.print "\r\n"

  # Sends the response body"
  socket.print response 
  
  socket.close                 # Disconnect from the socket
} 
