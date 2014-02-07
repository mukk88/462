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
  rule Second {
    select when pageview ".*" setting ()
    // Display notification that will not fade.
    {
      notify("Hello World", "This ifsdfsdgs a sample notification. This is a test for the first");
      notify("Hello World", "This is not a another sample notification. This is a test for the second") with sticky = true;
    }
  }
}