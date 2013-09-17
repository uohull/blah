require 'zoom'
require 'nokogiri'

class HoldingsService
  include Blah::Exceptions
  
  def self.find_holdings(bib_record_no, holdings_collection, chop_last_bib_digit = false)
    holdings_collection = holdings_collection || [] 

    begin 
      unless bib_record_no.nil?
        #We need to chop the last digit off (control no) the bib_record to undertake the search... 
        id = chop_last_bib_digit ? bib_record_no.chop : bib_record_no
        #get the holdings 
        holdings_collection = get_holdings(id, holdings_collection)
      end
    rescue HoldingsException => e
      Rails.logger.error e
    end  

    return holdings_collection
  end 
  
  private

  def self.get_holdings(id, holdings_collection)   
    
    rset = []
    connection_attempts = 0
   
    begin
      # Uses Z39Connection Singleton to get the conn_pool - See z39_connection.rb 
      @conn_pool = Z39Connection.instance.conn_pool

      # using @conn_pool.with to get a connection from the pool 
      @conn_pool.with do |conn|
        conn.database_name = 'INNOPAC'
        conn.preferred_record_syntax = 'OPAC'
        rset = conn.search('@attr 1=12 "' + id + '"')
      end

    rescue => e
      #Let's retry two more times before giving up...
      connection_attempts += 1
      Rails.logger.error "Problem connecting to Z39.50, reloading connection pool...Retrying"
      
      # Try to reload the connection pool...
      begin
        # RubyZoom isn't self healing, so attempt to reload the connection_pool 
        Z39Connection.instance.reload_connection_pool
      rescue
        Rails.logger.error "Failed to reload connection pool"
      end

      retry unless connection_attempts > 3      
      raise HoldingsException, "Error connecting or querying the holdings Z39.50 database: " + e.to_s
    end

    begin
      if rset.length > 0
       #We expect there to be only one unique bib record
       record_xml = rset[0].xml

       noko_xml = Nokogiri::XML(record_xml)

        noko_xml.xpath('//opacRecord/holdings/holding').each do |node|
          local_location = node.xpath('localLocation').text.strip
          call_number = node.xpath('callNumber').text.strip
          public_note = node.xpath('publicNote').text.strip

          #Add to holdings array... 
          holdings_collection << HoldingsRecord.new(local_location, call_number, public_note)
        end

     end 
     rescue => e
       raise HoldingsException, "There was an issue retrieving the holdings information for: " +  id.to_s
     end      
    
     return holdings_collection
  end

  def self.catalogue_server_addr
    APP_CONFIG['catalogue_server_address']
  end

  def self.catalogue_server_port
    APP_CONFIG['catalogue_server_port']
  end

end

