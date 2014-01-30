
/**
 * Module dependencies.
 */

var express = require('express');
var routes = require('./routes');
var user = require('./routes/user');
var http = require('http');
var path = require('path');
var https = require('https');
var fs = require('fs');
var passport = require('passport')
  , util = require('util')
  , FoursquareStrategy = require('passport-foursquare').Strategy;

//ssl
var options = {
  key: fs.readFileSync('../key.pem'),
  cert: fs.readFileSync('../cert.pem')
};

//4sq
var FOURSQUARE_CLIENT_ID = "ADKJ24OB2LPM0DZ1Y3X1VM53FRNKYLGT4W0PISMZCQNJQ1NG"
var FOURSQUARE_CLIENT_SECRET = "EIXOFQJHCZ1ALUJQ2TJPUUXFRE1HINHEDNLZS4K3BXM413U5";

passport.serializeUser(function(user, done) {
  done(null, user);
});

passport.deserializeUser(function(obj, done) {
  done(null, obj);
});

passport.use(new FoursquareStrategy({
    clientID: FOURSQUARE_CLIENT_ID,
    clientSecret: FOURSQUARE_CLIENT_SECRET,
    callbackURL: "https://ec2-54-242-119-246.compute-1.amazonaws.com/auth/foursquare/callback"
  },
  function(accessToken, refreshToken, profile, done) {
    // asynchronous verification, for effect...
    process.nextTick(function () {
      
      // To keep the example simple, the user's Foursquare profile is returned
      // to represent the logged-in user.  In a typical application, you would
      // want to associate the Foursquare account with a user record in your
      // database, and return that user instead.
      return done(null, profile);
    });
  }
));



var app = express();

app.configure(function(){
	app.set('views', path.join(__dirname, 'views'));
	app.use(express.favicon());
	app.use(express.logger('dev'));
	app.use(express.json());
	app.use(express.urlencoded());

	app.use(express.cookieParser());
	app.use(express.bodyParser());
	app.use(express.methodOverride());
	app.use(express.session({ secret: 'keyboard cat' }));
	app.use(passport.initialize());
	app.use(passport.session());
	app.use(app.router);
	app.use(express.static(path.join(__dirname, 'public')));
	app.engine('html', require('ejs').renderFile);
});

// development only
if ('development' == app.get('env')) {
  app.use(express.errorHandler());
}

app.get('/', function(req, res){
  res.render('index.html');
});

app.get('/account', ensureAuthenticated, function(req, res){
  res.render('account.html', { user: req.user });
});

app.get('/login', function(req, res){
  res.render('login.html', { user: req.user });
});

app.get('/auth/foursquare',
  passport.authenticate('foursquare'),
  function(req, res){
    // The request will be redirected to Foursquare for authentication, so this
    // function will not be called.
  });

app.get('/auth/foursquare/callback', 
  passport.authenticate('foursquare', { failureRedirect: '/login' }),
  function(req, res) {
    res.redirect('/');
  });

app.get('/logout', function(req, res){
  req.logout();
  res.redirect('/');
});

http.createServer(app).listen(8080, function(){
  console.log('Express server listening on port 8080');
});

https.createServer(options, app).listen(443);

function ensureAuthenticated(req, res, next) {
  if (req.isAuthenticated()) { return next(); }
  res.redirect('/login')
}
