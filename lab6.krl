ruleset location_data {
  meta {
    name "lab 6"
    description <<
      DataStorage
    >>
    author "mark woo"
    logging off
    use module a169x701 alias CloudRain
    use module a41x186  alias SquareTag
    provides get_location_data
  }
  dispatch{

  }
  global {
    get_location_data = function(key){
      val = ent:mymap{key};
      val;
    }
  }
  rule start{
    select when web cloudAppSelected
    pre{
      val = ent:mymap{"fs_checkin"};
      venue = val.pick("$.venue"); 
    }
    {
      notify("starting", venue);
    }

  }

  rule add_location_item{
    select when pds new_location_event
    pre{
      key = event:attr("key");
      value = event:attr("value");
    }
    fired{
      set ent:mymap{key} val
    }

  }

}