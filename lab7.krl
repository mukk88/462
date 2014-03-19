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
      distance = function(lat,long,fslat,fslong){
        48;
      };

      lat = event:attr("lat");
      long = event:attr("long");
      info = fsq:get_location_data("fs_checkin");
      fslat = info.pick("$..lat");
      fslong = info.pick("$..long");

      d = distance(lat,long,fslat,fslong);
    }
    if d > 50 then{
      notify("this", "does not work");    
    }
    fired{
      set ent:distance 'farer';
      raise explicit event location_far for b505197x8
      with
        distance = d;
    }else{
      set ent:distance 'nearer';
      raise explicit event location_nearby for b505197x8
      with
        distance = d;
    }
  }

  rule display_checkin{
    select when web cloudAppSelected
    pre{
      info = <<
        <p>#{ent:distance} </p>
      >>;
    }
    {
      SquareTag:inject_styling();
      CloudRain:createLoadPanel("Checkin Information", {}, info);
      notify("displaying", "new checkin1");
    }
  }

}