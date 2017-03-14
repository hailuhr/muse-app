$(document).on('ready', function() {
  $("body").on("click", "#artist_search", getQuestion)
  // debugger;

});


function getQuestion(e){
  e.preventDefault()

  // debugger;

    //  $("#google").remove() || $(".ui.basic.segment.landpage-image").remove()

      var name = $("input[name*=search]").val()
      // $("#portfolio").remove()
      //

      $.ajax({
          cache: false,
          method: "get",
          url: "/artists/search",
          data: {
            search: name
          },
          error: function(data) {
          },
          success: function(data) {
            $("#trivia").html(data)
          }
        })
}
