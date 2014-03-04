ruleset foursquare {
  meta {
    name "lab 5"
    description <<
      FourSquare
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
      notify("starting", "lab5");
    }

  }

  rule process_fs_checkin{
    select when foursquare checkin
    pre{
      checkin= ent:checkin;
    }
  }

  rule display_checkin{
    select when web cloudAppSelected
    pre{
      checkin = ent:checkin;
    }
    {
      notify("times", checkin);
    }
  }

}