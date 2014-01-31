
/*
 * GET home page.
 */

exports.index = function(req, res){
  //if logged in
  if(req.session.userid){
    var checkin = '';
    // if checked in with 4 sq
  	if(idaccess[req.session.userid]){
      var url = {
        host: 'api.foursquare.com',
        port:443,
        path: '/v2/users/self/checkins?oauth_token='+idaccess[req.session.userid]+'&v=20140130',
        method:'GET'
      };

      var request = https.request(url, function(response) {
        response.on('data', function(d) {
          checkin += d
          var checkintext = JSON.parse(checkin);
          console.log("hello?");
          res.render('index.html', { result:checkintext, loginid:req.session.userid });
        });
      });
      request.end();

      request.on('error', function(e) {
        console.error(e);
      });
  	}else{
      res.render('index.html', {result:false,loginid:req.session.userid});
    }
  }else{
    console.log("no user id");
    res.render('index.html',{result:false, loginid:false});
  }
};