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
  rule clear_username{
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