$(document).on('ready', function() {
  $("body").on("click", "#albums_search", getQuestion)
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
          url: "/albums/search",
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
