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
    use module b505197x5 alias fsq
  }
  dispatch{

  }
  global {

  }

  rule check_lat{
    select when location currnt
    pre{
      lat = event:attr("lat");
      long = event:attr("long");
      info = fsq:get_location_data("fs_checkin");
      fslat = info.pick("$..lat");
      fslong = info.pick("$..long");
    }
    fired{
      set ent:lat lat;
      set ent:fslat fslat;
    }
  }

  rule display_checkin{
    select when web cloudAppSelected
    pre{
      info = <<
        <p>Lat: #{ent:lat}</p>
        <p>FourSquare Lat: #{ent:fslat}</p>
      >>;
    }
    {
      SquareTag:inject_styling();
      CloudRain:createLoadPanel("Checkin Information", {}, info);
      notify("displaying", "new checkin");
    }
  }

}