var express = require('express');
var http = require('http');
var app = express();

app.get('/', function(req, res){
  res.send('Hello World');
});


var server = http.createServer(app);
server.listen(3000, function () {
  console.log('Express server listening on port 3000';
});