var express = require('express');
var http = require('http');
var https = require('https');
var fs = require('fs');

var options = {
  key: fs.readFileSync('key.pem'),
  cert: fs.readFileSync('cert.pem')
};

app.get('/', function(req, res){
  res.send('Hello World');
});

var app = express();

http.createServer(app).listen(80);
https.createServer(options, app).listen(443);