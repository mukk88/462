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
  rule Second {
    select when pageview ".*" setting ()
    // Display notification that will not fade.
    {
      notify("web rule", "change html.") with sticky = true;
    }
  }

}