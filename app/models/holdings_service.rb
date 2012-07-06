require 'zoom'
require 'nokogiri'

class HoldingsService
  
  def find_holdings(bib_record_no, chop_last_bib_digit = true)
    lib_conn = connection
    holdings_array = []
    
    unless bib_record_no.nil?
      #We need to chop the last digit off (control no) the bib_record to undertake the search... 
      id = chop_last_bib_digit ? bib_record_no.chop : bib_record_no
      rset = lib_conn.search('@attr 1=12 "' + id + '"')
      
      if rset.length > 0
        #We expect there to be only one unique bib record
        record_xml = rset[0].xml 

        noko_xml = Nokogiri::XML(record_xml)       
  
        noko_xml.xpath('//opacRecord/holdings/holding').each do |node|
          local_location = node.xpath('localLocation').text 
          call_number = node.xpath('callNumber').text
          public_note = node.xpath('publicNote').text
     
          #Add to holdings array... 
          #holdings_array << {:local_location => local_location, :call_number => call_number, :public_note => public_note}
          holdings_array << HoldingsRecord.new(local_location, call_number, public_note)          
        end
      end      
    end
    
    return holdings_array

  end
  
  private

  def connection
    zoom_conn = ZOOM::Connection.new
    zoom_conn.connect(catalog_server_addr, catalog_server_port)
    zoom_conn.database_name = 'INNOPAC'
    zoom_conn.preferred_record_syntax = 'OPAC'  
    return zoom_conn   
  end

  def catalog_server_addr
    'libsys.lib.hull.ac.uk'
  end

  def catalog_server_port
   210
  end

end

