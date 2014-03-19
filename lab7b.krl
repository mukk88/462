ruleset twilio_sms {
  meta {
    name "lab 7"
    description <<
      DataStorage
    >>
    key twilio{ "account_sid" : "AC3b6dfe5e26e6d01074ff0966b903adbe",
                "auth_token" : "2c8dce524c1c6f3379b14b71e268b9dc"
    }
    author "mark woo"
    logging off
    use module a169x701 alias CloudRain
    use module a41x186  alias SquareTag
    use module a8x115 alias twilio with twiliokeys = keys:twilio()
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
      twilio:send_sms('8017194232', '3852751465', 'random text');      
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