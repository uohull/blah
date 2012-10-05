require 'zoom'
require 'nokogiri'
require 'lib/blah/exceptions'

class HoldingsService

  include Blah::Exceptions
  
  def find_holdings(bib_record_no, chop_last_bib_digit = true)
    holdings = []  
    begin 
      unless bib_record_no.nil?
        #We need to chop the last digit off (control no) the bib_record to undertake the search... 
        id = chop_last_bib_digit ? bib_record_no.chop : bib_record_no
        #get the holdings 
        holdings = get_holdings(id)
      end
    rescue HoldingsException => e
      Rails.logger.error e
    end  

    return holdings
  end 
  
  private

  def get_holdings(id)
   
    holdings_array = []
    rset = []
    connection_attempts = 0
   
    begin
      #Using block to ensure connection is closed for service durability 
      ZOOM::Connection.open(catalog_server_addr, catalog_server_port) do |conn|
        conn.database_name = 'INNOPAC'
        conn.preferred_record_syntax = 'OPAC'
        rset = conn.search('@attr 1=12 "' + id + '"')
      end
    rescue => e
      #Let's retry two more times before giving up...
      connection_attempts += 1
      retry unless connection_attempts > 2
      raise HoldingsException, "Error connecting or querying the holdings Z39.50 database: " + e.to_s 
    end   

    begin
      if rset.length > 0
       #We expect there to be only one unique bib record
       record_xml = rset[0].xml

       noko_xml = Nokogiri::XML(record_xml)

        noko_xml.xpath('//opacRecord/holdings/holding').each do |node|
          local_location = node.xpath('localLocation').text
          call_number = node.xpath('callNumber').text
          public_note = node.xpath('publicNote').text

          #Add to holdings array... 
          holdings_array << HoldingsRecord.new(local_location, call_number, public_note)
        end
     end 
     rescue => e
       raise HoldingsException, "There was an issue retrieving the holdings information for: " +  id.to_s
     end      
    
     return holdings_array
  end

  def catalog_server_addr
    APP_CONFIG['catalog_server_address']
  end

  def catalog_server_port
    APP_CONFIG['catalog_server_port']
  end

end

