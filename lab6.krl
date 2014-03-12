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
      val = app:mymap{"fs_checkin"};
      val
    };
  }

  rule add_location_item{
    select when pds new_location_data
    pre{
      key = event:attr("key");
      value = event:attr("value");
    }
    fired{
      set app:key value.pick("$..createdAt");
      set app:mymap{"fs_checkin"} value;
    }

  }

  rule start{
    select when web cloudAppSelected
    pre{
      test = app:test;
      key = app:key;
      val = app:mymap{"fs_checkin"};
      venue = val.pick("$..createdAt"); 
    }
    {
      notify("my venue", venue);
      notify("key3", key);
    }

  }


}