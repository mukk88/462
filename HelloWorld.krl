ruleset HelloWorldApp {
  meta {
    name "Hello World"
    description <<
      Hellop World
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
      pageQuery = page:url("query");
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

  rule HiTwo{
    select when pageview re#\?(.*)# setting (name)  
    pre {
      pageQuery = page:url("query");
    }
    {
      notify("Hello World", "pageQuery") with sticky = true;
    }
  }
}