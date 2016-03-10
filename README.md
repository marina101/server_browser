# server_browser#
A mini server and command line text-based browser that can send and reply with basic http GET and POST requests

A simple web server that receives requests and sends a response based on those requests. The command line browser can issue either a GET or POST http request (which submits the user's name and email).

a) GET request: the server will reply with a small html page "index.html"

b) POST request: you will be asked to enter a name and email. These will be sent to the server, who will integrate them into the html document "thanks.html" and will send the modified html document to the browser.

This server-browser pair uses JSON objects and sockets to send data between each other.

To run:
1) run simple_oo_server.rb in one terminal window
2) open another terminal window (while the server is running) and run tiny_browser.rb, follow its instructions
3) to close the server when you are finished, press control-c

Note: the server must be actively running for the browser to be able to work

