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
  rule init{
    select when pageview url #.*#
    pre{
      blank_div = << <div id = "my_div">a simple div</div>  >>;
    }
  }
  rule show_form {
    select when pageview url #.*#
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
      append("#main",a_form);
      watch("#my_form","submit");
    }
  }

  rule on_submit{
    select when web submit "#my_form"
    pre{
      username = event:attr("first")+" "+event:attr("last");
    }
    {
      notify("your username", username);
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
      notify("you have", "<div> your username " + username + "</div>");
      replace_inner("#para", "<div> your username " + username + "</div>");
    }
  }



  rule clear_username{
    select when web pageview url ".*"
    pre{
      pageQuery = page:url("query");
      result = pageQuery.match(re#(^|&)clear=([^&]+)#) => pageQuery.extract(re#(^|&)clear([^&]+)#) | ["",""];
      toClear = result[1] eq "1";
      toDo = true;
    }
    if toDo then
      notify("clearing", toClear);
  }



}