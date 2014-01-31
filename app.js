var express = require('express');
var app = express();
var routes = require('./routes');
var user = require('./routes/user');
var http = require('http');
var path = require('path');
var https = require('https');
var fs = require('fs');
var RedisStore = require('connect-redis')(express);
var passport = require('passport')
  , util = require('util')
  , FoursquareStrategy = require('passport-foursquare').Strategy;
var helpers = require('express-helpers');
helpers(app);

//variables
var token = null;
var curID = 1;
var user = 0;
var idaccess = {};

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
    // callbackURL: "https://localhost:8081/auth/foursquare/callback"
  },
  function(accessToken, refreshToken, profile, done) {
    process.nextTick(function () {
      token = accessToken;
      return done(null, profile);
    });
  }
));

//configure
app.configure(function(){
	app.set('views', path.join(__dirname, 'views'));
	app.use(express.favicon());
	app.use(express.logger('dev'));
	app.use(express.json());
	app.use(express.urlencoded());
	app.use(express.cookieParser());
	app.use(express.bodyParser());
	app.use(express.methodOverride());
	app.use(express.session({ 
    // store: new RedisStore({
    //   host:'localhost',
    //   port: 6397,
    //   db:2,
    //   pass: 'RedisPASS'
    // }),
    secret: 'keyboard cat'
  }));
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

//home
app.get('/', function(req, res){
  // if logged in
  if(req.session.userid){
    // if checked in with 4 sq
  	if(idaccess[req.session.userid] && idaccess[req.session.userid].token){
      res.render('index.html',{token:true,loginid:idaccess[req.session.userid].username, people:idaccess} );
  	}else{
      res.render('index.html', {token:false,loginid:idaccess[req.session.userid].username, people:idaccess});
    }
  }else{
    res.render('index.html',{token:false, loginid:false, people:idaccess});
  }
});

app.post('/', function(req,res){
  var post = req.body;
  for(var id in idaccess){
    if(idaccess[id].username == post.username){
      req.session.userid = id;
      res.redirect('/');
      break;
    }
  }
  res.send('no such username, try again');
})

//login
app.get('/create', function(req, res){
  res.render('create.html', { user: req.user });
});

app.post('/create', function(req,res){
  req.session.userid = curID;
  var post = req.body;
  idaccess[curID] = {username:post.username,token:false};
  curID++;
  res.redirect('/');
});

app.get('/logout', function(req, res){
  delete req.session.userid;
  req.logout();
  res.redirect('/');
});

app.get('/user/:userid', function(req,res){
  var userid = req.url.split('/').pop();
  var checkin = '';
  if(idaccess[userid] && idaccess[userid].token){
    var url = (userid==req.session.userid) ? {
      host: 'api.foursquare.com',
      port:443,
      path: '/v2/users/self/checkins?oauth_token='+idaccess[userid].token +'&v=20140130',
      method:'GET'
    } : {
      host: 'api.foursquare.com',
      port:443,
      path: '/v2/users/self/checkins?limit=1&oauth_token='+idaccess[userid].token +'&v=20140130',
      method:'GET'      
    };

    var request = https.request(url, function(response) {
      response.on('data', function(d) {
        checkin += d
        var checkintext = JSON.parse(checkin);
        res.render('account.html', {info:checkintext});
      });
    });
    request.end();

    request.on('error', function(e) {
      console.error(e);
    });
  }else{
    res.send('this person has not checked into four square. yet. ');
  }
});

//foursquare
app.get('/foursquare', ensureAuthenticated, function(req, res){
  res.redirect('/', { user: req.user });
});

app.get('/auth/foursquare',passport.authenticate('foursquare'));
app.get('/auth/foursquare/callback', 
  passport.authenticate('foursquare', { failureRedirect: '/login' }),
  function(req, res) {
    idaccess[req.session.userid].token = token;
    res.redirect('/');
  });

app.get('/fsqlogin', function(req, res){
  res.render('foursquare.html', { user: req.user });
});

function ensureAuthenticated(req, res, next) {
  if (req.isAuthenticated()) { return next(); }
  res.redirect('/fsqlogin')
}

//start server
http.createServer(app).listen(8080, function(){
  console.log('Express server listening on port 8080');
});

https.createServer(options, app).listen(443);



