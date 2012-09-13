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
      

       render_holdings_table << holdings_table(bjl_items_records, "Brynmor Jones Library") <<  holdings_table(kdl_items_records, "Keith Donaldson Library") << holdings_table(wise_items_records, "Wilberforce Institute")  << holdings_table(map_items_records, "Map Library") << holdings_table(blaydes_items_records, "Blaydes house") << holdings_table(chemistry_items_records, "Chemistry Department") << holdings_table(other_records, "Other")
    
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
                <th></th>
                <th>Status</th>
              </tr>        
        EOS
      
        records.each do |record|

          #Filter some words out of the location display
          local_location = record.local_location
          replacements = [ ["BJL", ""], ["KDL", ""], ["Dept.", ""], ["Via", ""] ]
          replacements.each {|replacement| local_location.gsub!(replacement[0], replacement[1])}

          #Remove copy number from call_number
          call_number = record.call_number.gsub(/c.[0-9]+/, "")

          #Remove extra status information
          availability = record.availability
          availability_replacements = [ [/\+[0-9]/, ""], ["HOLD", ""] ]
          availability_replacements.each {|replacement| availability.gsub!(replacement[0], replacement[1])}

          status = ""
          if availability.downcase.include? "available"
            status = '<span class="label label-success"><i class="icon-ok icon-white"></i>Available</span>'
          elsif availability.downcase.include? "due"
            status = '<span class="label label-warning">Due:' + availability.sub(/DUE/, '') + '</span>'
          elsif availability.downcase.include? "lib use"
            status = '<span class="label label-important"><i class="icon-remove icon-white"></i>Library use</span>'
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


end

