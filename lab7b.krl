ruleset location_data {
  meta {
    name "lab 7"
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

  }

  rule add_location_item{
    select when explicit location_nearby
    pre{
      d = event:attr("distance");
    }
    fired{
      set ent:distance d;
    }
  }

  rule start{
    select when web cloudAppSelected
    pre{
      distance = ent:distance;
    }
    {
      notify("part", distance);
    }

  }

}