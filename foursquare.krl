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
      venue = event:attr("venue");
      city = event:attr("city");
      shout = event:attr("shout");
      createdAt = event:attr("createdAt");
    }
    fired{
      set ent:checkin "yes"
      set ent:venue venue;
      set ent:city city;
      set ent:shout shout;
      set ent:createdAt createdAt;
    }
  }

  rule display_checkin{
    select when web cloudAppSelected
    pre{
      info = <<
        <p> succeed: #{ent:checkin} </p>
        <p>Venue: #{ent:venue}</p>
        <p>City: #{ent:city}</p>
        <p>Shout: #{ent:shout}</p>
        <p>CreatedAt: #{ent:createdAt}</p>
      >>;
    }
    {
      SquareTag:inject_styling();
      CloudRain:createLoadPanel("Checkin Information", {}, info);
      notify("times", checkin);
    }
  }

}