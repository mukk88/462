ruleset HelloWorldApp {
  meta {
    name "Hello World"
    description <<
      Hello World
    >>
    author ""
    logging off
  }
  dispatch{

  }
  global {
   
  }
  rule HelloWorld {
    select when pageview ".*" setting ()  
    pre {
      my_html = <<
        <h5>Helloe, World!</h5>
      >>;
    }
    // Display notification that will not fade.
    {
      notify("Hello World", "This is a sample notification.");
      notify("Hello World", "This is a another sample notification.") with sticky = true;
    }
  }
  rule HelloWorld2 {
    select when pageview re#\?(.*)# setting (name)  
    // Display notification that will not fade.
    {
      notify("Hello World", "This is aasfdaasf sample notification.");
      notify("Hello World", "This is a anotherfsdfsdg sample notification.") with sticky = true;
    }
  }
}