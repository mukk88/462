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
      lat = event:attr("lat");
      lng = event:attr("long");
    }
    fired{
      set ent:venue venue;
      set ent:city city;
      set ent:lat lat;
      set ent:lng lng;
    }
  }

  rule start{
    select when web cloudAppSelected
    pre{
      info = <<
        <p> Venue: #{ent:venue} </p>
        <p> City: #{ent:city} </p>
        <p> Lat: #{ent:lat} </p>
        <p> Long: #{ent:lng} </p>
      >>;
    }
    {
      SquareTag:inject_styling();
      CloudRain:createLoadPanel("Checkin Information", {}, info);
      notify("lab8", "starting git hub is lame");
    }

  }

}
