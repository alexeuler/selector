require 'socket'
require 'rack'


socket = TCPSocket.new("localhost", 9010)
# request = "GET /?user_id=1 HTTP/1.0"
request = <<-eos
GET / HTTP/1.1
Host: api.bonfire-project.eu:444
Accept: */*
Authorization: Basic XXX
Accept-Encoding: gzip, deflate

eos
# request = "GET /\r\n"
socket.write request