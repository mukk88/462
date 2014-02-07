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


  rule HiTwo{
    select when pageview re#\?(.*)# setting (name)  
    {
      notify("Hello World", "pageQuery") with sticky = true;
    }
  }
}