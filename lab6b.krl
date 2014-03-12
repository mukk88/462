ruleset examine_location {
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
    {
      notify("starting", "lab6");
    }

  }

  rule add_location_item{
    select when pds new_location_event
    pre{
      key = event:attr("key");
      value = event.attr("value");
    }
    fired{
      set ent:mymap{key} val
    }

  }

}