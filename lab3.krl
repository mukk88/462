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
  rule show_form {
    select when pageview url #.*#
    pre {
      a_form = <<
        <form id="my_form" onsubmit="return false;">
          <input type="text" name="first" placeholder="First Name"/>
          <input type="text" name="last" placeholder="Last Name"/>
          <input type="submit" value="Submit" />
        </form>
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
    select when web pageview ".*" or web submit "#my_form"
    pre{
      username = ent:username => ent:username | "no name yet";
      intro_para = <<
        <p> your username: #(username) </p>
      >>;
    }
    {
      append("#main", "<div> your username " + username + "</div>");
      notify("your username", username);
    }
  }



}