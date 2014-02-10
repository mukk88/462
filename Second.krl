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
      notify("Hello World", "First one");
      notify("Hello World", "Second one.") with sticky = true;
    }
  }
  rule First {
    select when pageview ".*" setting ()
    pre{
      extract = function(s){
        results = s.extract(re#(&|^)name=([^&]+)#);
        results[1];
      };
      pageQuery = page:url("query");
      name = pageQuery.match(re#(&|^)name=([^&]+)#) => extract(pageQuery) | "monkey";
    }
    // Display notification that will not fade.
    {
      notify("my name", "This is the " + name + ".");
    }
  }

  rule Count{
    select when pageview ".*" setting ()
    pre{
      x = ent:times + 1;
    }
    if x < 6 then
      notify("fired times", "it has fired " + x + " times.");
    fired{
      ent:times += 1 from 1;
    }else{

    }
  }

  rule Clear{
    select when pageview ".*" setting ()
    pre{
      pageQuery = page:url("query");
      toClear = pageQuery.match(re#(.*)clear(.*)#) => true | false ;
    }
    if toClear then
      notify("clearing", "number of times.");
    fired{
      clear ent:times;
    }else{

    }
  }
}