ruleset examine_location {
  meta {
    name "lab 6b"
    description <<
      display foursquare things
    >>
    use module b505197x5 alias fsq 

    author "mark woo"
    logging off
  }
  dispatch{

  }
  global {

  }
  rule show_fs_location{
    select when web pageview url ".*" 
    pre{
      value = fsq:get_location_data("fs_checkin");
      venue = value.pick("$..venue");
      city = value.pick("$..city");
      shout = value.pick("$..shout");
      created = value.pick("$..createdAt");
    }
    {
      notify("data", "venue: " + venue + "\ncity: " + city + "\nshout: " + shout + "\ncreate at: " + created);
    }

  }

}