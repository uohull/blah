module LibraryItemsHelper


  #<%= link_to t('blacklight.tools.refworks'), refworks_export_url(:id => @document), {:class => 'btn', :target => '_blank'}  %>   
  def render_request_library_item_link(library_item, class_parameter)
	  link_to "Request Item", "http://#{ catalogue_opac_addr }/search?/.#{ library_item.bib_no.to_s }/.#{ library_item.bib_no.to_s }/1%2C1%2C1%2CB/request~".html_safe, {:class => class_parameter }
  end	

  def render_bookable_library_item_link(library_item, class_parameter)
    link_to "Book Item", "http://#{ catalogue_opac_addr }/webbook?/#{ library_item.bib_no.to_s }&back=/search".html_safe, {:class => class_parameter }
  end 

  # item_bookable?(document)
  # This method will determine whether an item is 'bookable' based upon the the string stored in the loan_type_display. 
  # The string to match is stored in the blah_config.yml file.
  def item_bookable?(document)
    if document.has?("loan_type_display") && document["loan_type_display"].include?(bookable_item_loan_type)
      return true
    else
      return false
    end
  end

  # Display holdings information for a given doc_id
  # Creates a invisible div with the document_id that the jquery script uses to query the holdings_controller#index and populate
  # ...the empty holding-records-element
  # See jquery script at - app/assets/javascripts/holdings_records.js
  def jquery_holdings_display(doc_id)
    content_tag(:div, doc_id, {:id => "doc-id", :style => "display:none;"}) << content_tag(:div, "", :id => "holdings-record-element")
  end

  #Renders the holdings information in html using the holdings_record/_holdings_table.html.erb partial
  #To use @holdings_records needs to be instantiated within controller #action - See catalog_controller.rb
  def render_holdings_html_partial(library_item)
    unless library_item.holdings_records_collection.nil?
      content_tag(:div, :class => "holdings") do
        render :partial => 'library_items/holdings_table'
      end
    end
  end
  
  #Renders the holdings information for an item on a 'show page'
  #This method will format text and remove superfluous data
  #TODO: Tidy up the way it splits holdings into seperate location tables.. 
  def render_holdings_table(holdings_records)

    unless holdings_records.empty?
      render_holdings_table = ""

      bjl_items_records = []
      kdl_items_records = []
      map_items_records = []
      wise_items_records = []
      blaydes_items_records = []
      chemistry_items_records = [] 
      other_records = []   

      bjl_items_records = holdings_records.select { |record| record.local_location.downcase.include? "bjl" }
      kdl_items_records = holdings_records.select { |record| record.local_location.downcase.include? "kdl" }
      wise_items_records = holdings_records.select { |record| record.local_location.downcase.include? "wise" }
      map_items_records = holdings_records.select { |record| record.local_location.downcase.include? "map" }
      blaydes_items_records = holdings_records.select { |record| record.local_location.downcase.include? "blaydes" }
      chemistry_items_records = holdings_records.select { |record| record.local_location.downcase.include? "chemistry" }

      #All others...
      holdings_records.each do |record|
        unless((record.local_location.downcase.include? "bjl")  || (record.local_location.downcase.include? "kdl") || (record.local_location.downcase.include? "wise") || (record.local_location.downcase.include? "map") || (record.local_location.downcase.include? "blaydes") || (record.local_location.downcase.include? "chemistry")) then
          other_records << record
        end
      end 

      #BJL Ground Floor Reference (R) 	G 1818 C93 P5 	LIB USE ONLY
      #location_list = {"bjl" => "Brymor Jones Library", "kdl" => "Keith Donaldson Library"}

      # Playing more generic solutions...
       # availability = {}
       # location_list.each do |key,value|
       #   holdings_records.each do |record|
       #     if record.local_location.downcase.include?  key.downcase
       #      
       #      availability.merge!( Hash[ key => [:name => value, :list =>[ holdings_records.index(record) => [record.local_location, record.call_number, record.availability]]]])
       #     end 
       #   end
       # end
      

       render_holdings_table << holdings_table(bjl_items_records, "Brynmor Jones Library") <<  holdings_table(kdl_items_records, "Keith Donaldson Library") << holdings_table(wise_items_records, "Wilberforce Institute")  << holdings_table(map_items_records, "Map Library") << holdings_table(blaydes_items_records, "Blaydes house") << holdings_table(chemistry_items_records, "Chemistry Department") << holdings_table(other_records, "Library / Department Only")
    
       return render_holdings_table.html_safe
    end
  end
    
  #Creates a holdings table for a location
  #TODO Refactor to use content_tags 
  def holdings_table (records, location_title)
      
     holdings_table = ""

     if records.length > 0
       holdings_table <<  <<-EOS
          <table class="table availability-table">
	        <thead>
            <tr>   
              <td colspan="3"><h5>#{location_title}</h5><h5></h5></td>
            </tr>
          </thead>
          <tbody>
              <tr>
                <th>Location</th>
                <th>Classmark</th>
                <th>Status</th>
              </tr>        
        EOS
      
        records.each do |record|

          #Filter some words out of the location display
          local_location = record.local_location
          replacements = [ ["KDL", ""], ["Dept.", ""], ["Via", ""] ]
          replacements.each {|replacement| local_location.gsub!(replacement[0], replacement[1])}

          #Remove copy number from call_number
          call_number = record.call_number.gsub(/c.[0-9]+/, "")

          #Remove extra status information
          availability = record.availability
          #availability_replacements = [ [/\+[0-9]/, ""], ["HOLD", ""] ]
          #availability_replacements.each {|replacement| availability.gsub!(replacement[0], replacement[1])}

          status = ""
          due=""
          hold=""
          if availability.downcase.include? "available"
            status = '<div class="holdings-label label alert-success"><i class="icon-ok icon-white"></i> Available</div>'
          elsif availability.downcase.include? "due"
            due =  availability.sub(/DUE/, '')[1,8]
            hold = availability.sub(/DUE/, '')[9..-1]
            status = '<div class="holdings-label label alert-warning">Due ' + due + '<br/>' + hold + '</div>'
          elsif availability.downcase.include? "lost"
            hold = availability.sub(/DUE/, '')[11..-1]
            status = '<div class="holdings-label label alert-error">Lost in lib<br/>' + hold + '</div>'
          elsif availability.downcase.include? "lib use"
            status = '<div class="holdings-label label alert-limited">Use in Library only</div>'
	elsif availability.downcase.include? "ask at"
            status = '<div class="holdings-label label alert-limited">Available on request</div>'
          else
            status = availability
          end

          holdings_table << <<-EOS
           <tr>
              <td class="table-td-title">#{local_location}</td>
              <td class="table-td-title">#{call_number}</td>
              <td class="table-td-data">#{status}</td>
           </tr>
          EOS
        end 
        holdings_table << <<-EOS
            </tbody>
				  </table>
        EOS

      end
      return holdings_table

  end

  # Returns a holdings icon and appropiate text for a given availability, location, call_number
  def holdings_icon(availability_status, location, call_number)
    holdings_icon = ''

    available = availability_status.downcase =~ /available/

    if available
       holdings_icon = '<i title="Available" id="icon-holding-available" class="icon-ok icon-white"> </i>&nbsp; '
     else
        if  availability_status.downcase.include?("lib use only")
         holdings_icon = '<i title="Use in Library only" id="icon-holding-limited" class="icon-chevron-right icon-white"> </i> &nbsp;Use in Library only -&nbsp;'
	elsif availability_status.downcase.include?("ask at")
	holdings_icon = '<i title="Available on request" id="icon-holding-limited" class="icon-chevron-right icon-white"></i> &nbsp;Available on request -&nbsp;'
        else
         holdings_icon = '<i title="Not available" id="icon-holding-unavailable" class="icon-remove icon-white"></i>&nbsp;' + availability_status + '&nbsp;' 
        end
     end
     holdings_icon << location
     holdings_icon <<  "&nbsp;- #{call_number}"  if available 

     holdings_icon.html_safe  
  end

  # Holdings are now sorted based upon Call number + availability 
  # This will sort the collection itself (does not copy)
  def sort_holdings_collection(holdings_collection)
    unless holdings_collection.nil? && !holdings_collection.respond_to?(:sort)
      holdings_collection.sort!{ |x,y| "#{x.call_number} #{x.availability}" <=> "#{y.call_number} #{y.availability}" }
    end
  end

  def catalogue_opac_addr
    APP_CONFIG['catalogue_opac_address']
  end

  def bookable_item_loan_type
    APP_CONFIG['bookable_item']['loan_type']
  end

end
