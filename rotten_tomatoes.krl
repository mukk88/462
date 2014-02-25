ruleset labthree {
  meta {
    name "lab three"
    description <<
      Rotten Tomahtoes
    >>
    author "mark woo"
    logging off
    use module a169x701 alias CloudRain
    use module a41x186  alias SquareTag
  }
  dispatch{

  }
  global {
    emit <|
      function showMeTheMoney() {
       r = http:get("http://api.rottentomatoes.com/api/public/v1.0/movies.json",
          {
            "apikey":"uvjbkdcys98bm9f8wzk9kke8",
            "q":"Toy Story 3",
            "page_limit":"1"
          });
        return r;
      }
    |>;

  }
  rule Start {
   select when web cloudAppSelected
    pre {
      a_form = <<
        <form id="my_form" onsubmit="return false;">
          <input type="text" name="title" placeholder="Movie Title"/>
          <input type="submit" value="Submit" />
        </form>
        <div id = "para"></div>
      >>;
    }
   {
    SquareTag:inject_styling();
    CloudRain:createLoadPanel("Hello World!", {}, a_form);
    watch("#my_form","submit");
   }
  }

  rule on_submit{
    select when web submit "#my_form"
    pre{
      title = event:attr("title");
    }
    {
      notify("hi", title);
    }
    fired{
      set ent:title title;
    }
  }

  rule show_name{
    select when web cloudAppSelected or web submit "#my_form"
    pre{
      title = ent:title;
    }    
    if (ent:title) then {
      replace_inner("#para", "<div> your title is " + title + "");
    }
  }

}