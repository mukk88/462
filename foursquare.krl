ruleset foursquare {
  meta {
    name "lab 5"
    description <<
      FourSquare
    >>
    author "mark woo"
    logging off
    use module a169x701 alias CloudRain
    use module a41x186  alias SquareTag
  }
  dispatch{

  }
  global {

  }
  rule start{
    select when web cloudAppSelected
    {
      notify("starting", "lab5");
    }

  }

  rule process_fs_checkin{
    select when foursquare checkin
    pre{
      venue = event:attr("venue")
      city = event:attr("city")
      shout = event:attr("shout")
      createdAt = event:attr("createdAt")
    }
    fired{
      set ent:venue venue;
      set ent:city city;
      set ent:shout shout;
      set ent:createdAt createdAt;
    }
  }

  rule display_checkin{
    select when web cloudAppSelected
    pre{
      venue = ent:venue;
      city = ent:city;
      shout = ent:shout;
      createdAt = ent:createdAt;
      info = <<
        <h1>ni hao</h1>
      >>;
    }
    {
      SquareTag:inject_styling();
      CloudRain:createLoadPanel("Checkin Information", {}, info);
      notify("times", checkin);
    }
  }

}