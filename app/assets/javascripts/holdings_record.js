$(document).ready(function() {
  var id = $("#doc_id").text();
  if (id.length > 0) {
    $.ajax({
      url:  "/holdings_record/" + id,
      cache: false, 
      success: function(html) {
       $("#holdings-record-element").append(html);
      }
    });
  }
});
