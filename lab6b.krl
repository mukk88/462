ruleset examine_location {
  meta {
    name "lab 6b"
    description <<
      display foursquare things
    >>
    author "mark woo"
    logging off
  }
  dispatch{

  }
  global {

  }
  rule start{
    select when web pageview url ".*" 
    {
      notify("starting", "lab6b");
    }

  }

}