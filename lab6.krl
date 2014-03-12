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
    provides get_location_data, test
  }
  dispatch{

  }
  global {

    test = "hi";

    get_location_data = function(key){
      val = ent:mymap{"fs_checkin"};
      val
    }
  }

  rule add_location_item{
    select when pds new_location_data
    pre{
      key = event:attr("key");
      value = event:attr("value");
      newmap = {};
    }
    fired{
      set ent:key 3;
      set ent:mymap{key} val;
    }

  }

  rule start{
    select when web cloudAppSelected
    pre{
      test = ent:test;
      key = ent:key;
      val = ent:mymap{"fs_checkin"};
      venue = val.pick("$..createdAt"); 
    }
    {
      notify("my venue", venue);
      notify("key2", key);
    }

  }


}