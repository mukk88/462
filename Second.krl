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
  rule First {
    select when pageview ".*" setting ()
    pre{

      extract = function(s){
        results = s.extract(re#(&|^)name=([^&]+)#).index(1);
        results;
      };

      pageQuery = page:url("query");
      name = pageQuery.match(re#(&|^)name=([^&]+)#) => extract(pageQuery) | "monkey";
    }
    // Display notification that will not fade.
    {
      notify("Hello World", "This ifsdfsdgs a sample " + name +". This is a test for the first");
      notify("Hello World", "This is not a another sample notification. This is a test for the second") with sticky = true;
    }
  }
}