var express = require('express');
var http = require('http');
var app = express();

app.get('/', function(req, res){
  res.send('Hello World');
});


var server = http.createServer(app);
var port = process.env.PORT ||  3000; 
server.listen(port, function () {
  console.log('Express server listening on port ' + port);
});