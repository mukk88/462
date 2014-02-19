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
  rule ChangeHtml {
    select when pageview ".*" setting ()
    pre{
      random_text = <<
      <span> hello </span>
      >>;
      append("#main", random_text);
    }
    {
      notify("web rule", "change html.") with sticky = true;
      append("#main", random_text);
    }
  }

}