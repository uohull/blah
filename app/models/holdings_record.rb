require 'zoom'
require 'nokogiri'

class HoldingsRecord

  def connection
    zoom_conn = ZOOM.new
    zoom_conn.connect(catalog_server_addr, catalog_server_port)
    zoom_conn.database_name = 'INNOPAC'
    zoom_conn.preferred_record_syntax = 'OPAC'     
  end

  def holdings(bib_record_no)

    lib_conn = connection
    
    unless bib_record_no.nil?
      #We need to chop the last digit off (control no) the bib_record to undertake the search... 
      id = bib_record_no.chop      
      rset = lib_conn.search('@attr 1=12 "' + id + '"')
      
      if rset.length > 0
        #We expect there to be only one unique bib record
        record_xml = rset.first.xml 

        noko_xml = Nokogiri::XML(record_xml)
 
        holdings_array = []
  
        noko_xml.xpath('//opacRecord/holdings/holding').each do |node|
          local_location = node.xpath('localLocation').text 
          call_number = node.xpath('callNumber').text
          public_note = node.xpath('publicNote').text
     
          #Add to holdings array... 
          holdings_array << {:local_location => local_location, :call_number => call_number, :public_note => public_note}          
        end


        #[{:location => "bjl", :call_number => "4546465", :note => "note"}] Format...
      end
      
    end
  end


  def catalog_server_addr
    'libsys.lib.hull.ac.uk'
  end

  def catalog_server_port
   210
  end

end
