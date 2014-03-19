ruleset eventnetwork {
  meta {
    name "lab 7"
    description <<
      LatLongTwilio
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
      notify("starting", "lab7");
    }

  }

  rule process_fs_checkin{
    select when location currnt
    pre{
      lat = event:attr("lat");

    }
    send_directive(venue) with checkin = venue;
    fired{
      set ent:lat lat;
    }
  }

  rule display_checkin{
    select when web cloudAppSelected
    pre{
      info = <<
        <p>Lat: #{ent:lat}</p>
      >>;
    }
    {
      SquareTag:inject_styling();
      CloudRain:createLoadPanel("Checkin Information", {}, info);
      notify("displaying", "new checkin");
    }
  }

}