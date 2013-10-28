$(document).ready(function() {
  //Iterate through the document classes on search results
  $('.document').each(function(index, element) {
     //get the document#id from the doc_id div
     var id = $(element).find('#doc-id').text();
      if (id.length > 0) {
        //If it exists, retrieve holdings and add to #holdings-record-element     
        $.ajax({
          url:  "/items/" + id,
          cache: false, 
          success: function(html) {
            $(element).find("#holdings-record-element").append(html);
          }
        });
      } 
  });
});

//Display the 'content help desk' paragraph if there isn't any holdings content
$(document).ready(function() {
   if ($('.availability-table').children().length == 0) {
      $('#no-holdings').show();
    }
});
