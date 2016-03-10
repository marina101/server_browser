# Tiny Browser by Marina C
# This is a tiny command-line text based browser
# For it to run, the "simple server" must already be running as localhost
# The browser can submit two types of requests - GET and POST
# The POST requests asks the user for their name and email, that are then 
# submitted to the server.
# The browser then displays the response from the server.

require 'socket'
require 'json'
 
host = 'localhost'        # The web server
port = 2000               # Default HTTP port
path = "index.html"       # The files being requested
path2 = "thanks.html"

begin
  puts "Hello, welcome to the command-line browser!\n" + 
       "This browser can make a simple GET or POST request.\n" + 
       "It will then receive and display the response from the server.\n"
       "Please make sure the server is already running before issuing a request.\n\n"

  puts "What kind of request do you want to send? Enter GET or POST:"
  answer = gets.chomp
  if answer == "GET"
    # Formats http request to send to the server
    request = "GET #{path} HTTP/1.1\r\n\r\n"

    socket = TCPSocket.open(host,port)  # Connect to server
    socket.print(request)               # Send request
    response = socket.read              # Read complete response
    # Split response at first blank line into headers and body
    headers, body = response.split("\r\n\r\n", 2) 
    print body  

  elsif answer =="POST"
    #Get input from user that will be sent to the server
    puts "Please enter your name:"
    name = gets.chomp
    puts "Please enter your email:"
    email = gets.chomp
    data = {:person => {:name => name, :email => email}}
    ready_data = data.to_json
    request = "POST #{path2} HTTP/1.1\r\n" +
              "Content-Type: text/plain\r\n" +
              "Content-Length: #{ready_data.bytesize}\r\n" + 
              "\r\n" +
              "#{ready_data}" 

    socket = TCPSocket.open(host,port)  # Connect to server
    socket.print(request)               # Send request
    response = socket.read              # Read complete response
    # Split response at first blank line into headers and body
    headers,body = response.split("\r\n\r\n", 2) 
    print body  
  else
    raise ArgumentError, "Invalid request type"
  end
rescue => e
  puts e
end