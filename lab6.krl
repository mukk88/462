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
      val = app:mymap{key};
      val
    };
  }

  rule add_location_item{
    select when pds new_location_data
    pre{
      key = event:attr("key");
      value = event:attr("value");
    }
    send_directive(key) with location = value;
    fired{
      notify('fired', 'new location data');
      set app:mymap{key} value;
    }

  }

}