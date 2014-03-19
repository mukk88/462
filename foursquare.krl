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
      info = event:attr("checkin").decode();
      venue = info.pick("$.venue.name");
      city = info.pick("$.venue.location.city");
      shout = info.pick("$.shout");
      createdAt = info.pick("$.createdAt").as("num");
      lat-long = info.pick("#..lat-long").as("str");
    }
    send_directive(venue) with checkin = venue;
    fired{
      set ent:venue venue;
      set ent:city city;
      set ent:shout shout;
      set ent:createdAt createdAt;

      raise pds event new_location_data for b505197x5 with 
        key = "fs_checkin" and
        value = {"venue": venue, "city":city, "shout":shout, "createdAt": createdAt, "lat-long": lat-long};
    }
  }

  rule display_checkin{
    select when web cloudAppSelected
    pre{
      info = <<
        <p>Venue: #{ent:venue}</p>
        <p>City: #{ent:city}</p>
        <p>Shout: #{ent:shout}</p>
        <p>CreatedAt: #{ent:createdAt}</p>
      >>;
    }
    {
      SquareTag:inject_styling();
      CloudRain:createLoadPanel("Checkin Information", {}, info);
      notify("displaying", "checkin");
    }
  }

}