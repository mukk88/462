ruleset labthree {
  meta {
    name "lab three"
    description <<
      Hello World
    >>
    author "mark woo"
    logging off
    use module a169x701 alias CloudRain
    use module a41x186  alias SquareTag
  }
  dispatch{

  }
  global {
   
  }
  rule Start {
   select when web cloudAppSelected
    pre {
      my_html = <<
        <h5>Hello, World!</h5>
      >>;
    }
   {
    SquareTag:inject_styling();
    CloudRain:createLoadPanel("Hello World!", {}, my_html);
   }
  }

}