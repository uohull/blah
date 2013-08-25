class LibraryItem
	#bib_no - Bibliographic reference number used by Millenium 
  attr_accessor :bib_no, :item_format, :holdings_records_collection


  def initialize(bib_no, item_format='Unknown', options={})
  	self.bib_no = bib_no
    self.item_format = item_format
  	self.holdings_records_collection = options[:holdings_records_collection] || nil
  end


  #Can the item be request/put on hold.. The item availaility needs to be false and there needs to be holding information stored for the item
  def requestable?
    !self.available?.nil? && !self.available? ? true : false 
  end

  #available? returns boolean for availability. This will return nil if no availbility information is available
  def available?
  	 available = nil

     if holdings_available? 
       available = false

    	 availability = self.holdings_records_collection.availabilities 
       available_statuses = LibraryItem.available_status_list

       unless availability.nil?
     			available_statuses.each do |status| 
     			   available = availability.any? { |s| s.downcase.include?(status) }
     			   break if available   		
     			end
        end
    end
    return available
  end 

  #Can the item be booked (see: blah_config - bookable_item.location)
  def bookable?
    bookable = false

    if holdings_available? 
      item_locations  = self.holdings_records_collection.local_locations
      bookable_locations = LibraryItem.bookable_item_locations

      unless item_locations.nil?
          bookable_locations.each do |locations|
            bookable = item_locations.any? { |l| l.downcase.include?(locations.downcase) }
            break if bookable
          end
      end
    end
    return bookable
  end

  #Will populated the holdings_records_collection if holdings are available
  def load_holdings_records_collection 
    if self.holdings_available?
      #HoldingsRecordCollections gives us some handy methods... 
      @holdings_records_collection = HoldingsRecordsCollection.new
      #Pass in a reference to the HoldingsRecordCollections otherwise the HoldingsService defaults to using a standard array
      HoldingsService.find_holdings(self.bib_no, @holdings_records_collection)
    else
      ActiveRecord::Base.logger.info "Library item: #{@bib_no} of the format #{@item_format} is ignored for holdings information "
    end

  end

  #holdings_available is determined based upon a configured holdings ignore list in blah_config
  def holdings_available? 
    ignore_items = LibraryItem.holdings_ignore_list        
    ignore_items.include?(@item_format) ? false : true
  end
 

  def self.available_status_list
    APP_CONFIG['record_status']['available']
  end

  def self.bookable_item_locations
    APP_CONFIG['bookable_item']['location']
  end

  def self.holdings_ignore_list
    APP_CONFIG['holdings']['ignore']
  end

end   
