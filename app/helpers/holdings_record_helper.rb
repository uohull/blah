module HoldingsRecordHelper

  # Display holdings information for a given doc_id
  # Creates a invisible div with the document_id that the jquery script uses to query the holdings_controller#index and populate
  # ...the empty holding-records-element
  # See jquery script at - app/assets/javascripts/holdings_records.js
  def jquery_holdings_display(doc_id)
    content_tag(:div, doc_id, {:id => "doc-id", :style => "display:none;"}) << content_tag(:div, "", :id => "holdings-record-element")
  end

  #Renders the holdings information in html using the holdings_record/_holdings_table.html.erb partial
  #To use @holdings_records needs to be instantiated within controller #action - See catalog_controller.rb
  def render_holdings_html_partial
    content_tag(:div, :class => "holdings") do
      render :partial => 'holdings_record/holdings_table'
    end
  end

end
