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
      a_form = <<
        <form id="my_form" onsubmit="return false;">
          <input type="text" name="first" placeholder="First Name"/>
          <input type="text" name="last" placeholder="Last Name"/>
          <input type="submit" value="Submit" />
        </form>
        <div id = "para"></div>
      >>;
    }
   {
    SquareTag:inject_styling();
    CloudRain:createLoadPanel("Hello World!", {}, a_form);
   }
  }

}