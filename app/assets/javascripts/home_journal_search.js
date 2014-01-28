/* 
 * Home Journal Search
 * This JS file adds the ability to use a checkbox to select whether the Blacklight search will 
 * search against just E-Journals/Periodicals.  This replicates an advanced search with the correct
 * Format facets selected and 'title' box populated with query text.
 * Checkbox is required on the search form to enable this code.
 */

// Configuration variables - use jquery style #html_id for ids 
var search_form_id = '#form-search-main';
var search_form_submit = '#main-search-submit';
var query_text_box_id = '#q';
var search_journals_checkbox_id = '#search-journals';

$(document).ready(function() {
  //Iterate through the document classes on search results
  $(search_form_submit).click(function() {
    
    var search_journals = $(search_journals_checkbox_id).is(':checked');
    // Escape characters that can cause problems (partic "" and '')
    var query_text = htmlEscape($(query_text_box_id).val());

    if (search_journals) {
      $(search_form_id).append('<input type="hidden" id="f_inclusive_format_E-Journal" name="f_inclusive[format][E-Journal]"  value="1" />');
      $(search_form_id).append('<input type="hidden" id="f_inclusive_format_Journal" name="f_inclusive[format][Journal]" value="1" />');
      $(search_form_id).append('<input type="hidden" id="search_field" name="search_field" value="advanced" />');
      $(search_form_id).append('<input type="hidden" id="title" name="title" value="' + query_text + '" />');
    }

  });
});

function htmlEscape(str) {
  return String(str)
    .replace(/&/g, '&amp;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#39;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;');
}