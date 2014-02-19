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
    pre{
      random_text <<
      <span> hello </span>
      >>;
    }
    {
      notify("web rule", "change html.") with sticky = true;
      replace_html("#main", random_text);
    }
  }

}