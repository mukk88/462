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
  }
  dispatch{

  }
  global {
    get_location_data = function(){
      5
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

    }
    fired{
      set ent:value 1;
    }

  }

}