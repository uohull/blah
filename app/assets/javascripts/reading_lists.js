/*
 * Talis Aspire - ReadingLists Integration javascript file
 * This javascript file provides basic 'Aspire' reading list integration 
 * The script calls the json service at:-
 *    http://readinglists.hull.ac.uk/lcn/$bib_code/lists.json?cb=?
 * The output JSON is then outputted into the relevant HTML elements on the Millennium 
 * bib_display page.  
 * This code comes from Keele, See http://support.talisaspire.com/attachments/token/40lk3pfjpehusic/?name=asplnk2.pdf
 * Code modified to sort the module list return
 * Simon Lamb - Feb 2013 
 */

$(document).ready(function () {	
  // For Blacklight record pages, we are embedding a hidden field with id bib_record_id that contains the bib id
	var bibliographic_id = $('#bib_record_id').val();

	if (bibliographic_id !== null) { 
		reading_list_url = 'http://readinglists.hull.ac.uk/lcn/'+bibliographic_id+'/lists.json?cb=?';
		retrieve_json(reading_list_url);
	} 
});

function retrieve_json(url) {	

	var success = false;

	 $.getJSON(url,function(data) { 

	 		//Create an empty reading_lists_array
       var reading_list_array = new Array();

       //In order to allow sorting of the module list, we need to move the return data into a 'sortable' array
       $.each(data, function(key, val) {
         reading_list_array.push({"module": val, "url": key });
       })

       //Run the generic method to sort the reading_list_array by the 'module' value
       sortObjectsByKey(reading_list_array, 'module');

       var items = [];
       $.each(reading_list_array, function(key, val) { 
			  items.push('<tr><td class="table-td-title"><a href=' + val.url + '>' + val.module + '</a></td></tr>'); 
			 }) 

			 //Adds the reading lists to the ul within reading-list div(markup within app/views/catalog/_show_reading_lists.html.erb) 
			 $('<tbody/>', { 
			  html: items.join('')}).appendTo('.reading-list-table'); 
			  success = true;
			  $('.reading-lists-container').show();	
		 });
}

/* Generic method to sort a Javascript object */ 
function sortObjectsByKey(objects, key){
    objects.sort(function() {
        return function(a, b){
            var objectIDA = a[key];
            var objectIDB = b[key];
            if (objectIDA === objectIDB) {
                return 0;
            }
            return objectIDA > objectIDB ? 1 : -1;        
        };
    }());
}