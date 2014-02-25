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
    f = function(title) {
      info = http:get("http://api.rottentomatoes.com/api/public/v1.0/movies.json",
      {
        "apikey":"uvjbkdcys98bm9f8wzk9kke8",
        "q":title
      }).pick("$.content").decode();
      total = info.pick("$.total").as("num");

      have = <<
        <h1>Movie Found!</h1>
        <p>Movie Thumbnail: <img src="#{info.pick("$.movies[0].posters.thumbnail")}"></p>
        <p>Title</p>
        <p>Release Year</p>
        <p>Synopsis</p>
        <p>Critic Rating</p>
        <br>
      >>;

      no_have = <<
        <h1>#{title} not Found!</h1>
        <p>Please try again</p>
        <br>
      >>;

      result = (total>0) => have | no_have;
      result;
    }
  }
  rule Start {
   select when web cloudAppSelected
    pre {
      a_form = <<
        <div id = "para"></div>
        <form id="my_form" onsubmit="return false;">
          <input type="text" name="title" placeholder="Movie Title"/>
          <input type="submit" value="Submit" />
        </form>
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
      q = f(title);
    }
    {
      replace_inner("#para", q);
      notify("you chose", title);
    }
  }

}