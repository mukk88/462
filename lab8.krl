ruleset location_data {
  meta {
    name "lab 8"
    description <<
      Dispatching
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

  rule add_location_item{
    select when location notification
    pre{
      venue = event:attr("venue");
      city = event:attr("city");
    }
    fired{
      set ent:venue venue;
      set ent:city city;
    }
  }

  rule start{
    select when web cloudAppSelected
    pre{
      info = <<
        <p> Venue: #{ent:venue} </p>
        <p> City: #{ent:city} </p>
      >>;
    }
    {
      SquareTag:inject_styling();
      CloudRain:createLoadPanel("Checkin Information", {}, info);
      notify("lab8", "start");
    }

  }

}