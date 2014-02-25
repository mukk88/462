ruleset labthree {
  meta {
    name "lab three"
    description <<
      Hello World
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
  rule Start {
   select when web cloudAppSelected
    pre {
      a_form = <<
        <form id="my_form" onsubmit="return false;">
          <input type="text" name="first" placeholder="First Name"/>
          <input type="text" name="last" placeholder="Last Name"/>
          <input type="submit" value="Submit" />
        </form>
        <div id = "para"></div>
      >>;
    }
   {
    SquareTag:inject_styling();
    CloudRain:createLoadPanel("Hello World!", {}, a_form);
   }
  }

  rule on_submit{
    select when web submit "#my_form"
    pre{
      username = event:attr("first")+" "+event:attr("last");
    }
    fired{
      set ent:username username;
      notify("hi", "mark");
    }
  }

  rule show_name{
    select when web cloudAppSelected or web submit "#my_form"
    pre{
      username = ent:username;
    }    
    if (ent:username) then {
      replace_inner("#para", "<div> your username is " + username + ", add clear=1 as query to url to clear username</div>");
    }
  }

}