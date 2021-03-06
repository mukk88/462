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
    subscribers = 
     [{"name":"plusone",
       "cid":"5F93D4AC-B122-11E3-AC23-000C647EDFE5"
      },
      {"name":"plustwo",
       "cid":"8B339A0C-B122-11E3-86D1-3C9EE71C24E1"
      }
     ];
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
      lat = info.pick("$..lat").as("num");
      lng = info.pick("$..lng").as("num");

    }
    send_directive(venue) with checkin = venue;
    fired{
      set ent:venue venue;
      set ent:city city;
      set ent:shout shout;
      set ent:createdAt createdAt;
      set ent:lat lat;
      set ent:lng lng;

      raise pds event new_location_data for b505197x5 with 
        key = "fs_checkin" and
        value = {"venue": venue, "city":city, "shout":shout, "createdAt": createdAt, "lat":lat, "long":lng};
    }
  }

  rule dispatch {
    select when foursquare checkin
      foreach subscribers setting (pico)
        event:send(pico,"location","notification")
            with attrs = {"venue" : ent:venue,
                          "city": ent:city,
                          "lat": ent:lat,
                          "long": ent:lng
                          };
  }

  rule display_checkin{
    select when web cloudAppSelected
    pre{
      info = <<
        <p>Venue: #{ent:venue}</p>
        <p>City: #{ent:city}</p>
        <p>Shout: #{ent:shout}</p>
        <p>CreatedAt: #{ent:createdAt}</p>
        <p>Lat: #{ent:lat}</p>
        <p>Long: #{ent:lng}</p>
      >>;
    }
    {
      SquareTag:inject_styling();
      CloudRain:createLoadPanel("Checkin Information", {}, info);
      notify("displaying", "new checkin");
    }
  }

}