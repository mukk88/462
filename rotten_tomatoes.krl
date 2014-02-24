ruleset labthree {
  meta {
    name "lab three"
    description <<
      Hello World
    >>
    author "mark woo"
    logging off
  }
  dispatch{

  }
  global {
   
  }
  rule clear_username{
    select when web pageview url ".*"
    pre{
      pageQuery = page:url("query");
      toClear = pageQuery.match(re#(.*)clear=1(.*)#);
    }
    if toClear then{
      notify("username cleared!", "enter a new username");
    }fired{
      clear ent:username;
    }
  }

  rule show_form {
    select when pageview url #.*#
    pre {
      a_form = <<
        <form id="my_form" onsubmit="return false;">
          <input type="text" name="first" placeholder="First Name"/>
          <input type="text" name="last" placeholder="Last Name"/>
          <input type="submit" value="Submt" />
        </form>
        <div id = "para"></div>
      >>;
    }
    {
      append("#main",a_form);
      watch("#my_form","submit");
    }
  }

  rule on_submit{
    select when web submit "#my_form"
    pre{
      username = event:attr("first")+" "+event:attr("last");
    }
    fired{
      set ent:username username;
    }
  }

  rule show_name{
    select when web pageview url ".*" or web submit "#my_form"
    pre{
      username = ent:username;
    }    
    if (ent:username) then {
      replace_inner("#para", "<div> your username is " + username + ", add clear=1 as query to url to clear username</div>");
    }
  }

}