var express = require('express');
var http = require('http');
var https = require('https');
var fs = require('fs');

var options = {
  key: fs.readFileSync('../key.pem'),
  cert: fs.readFileSync('../cert.pem')
};

var app = express();
app.get('/', function(req, res){
  res.send('Hello World');
});


http.createServer(app).listen(8080);
https.createServer(options, app).listen(443);
