class LibraryItem
	#bib_no - Bibliographic reference number used by Millenium 
  attr_accessor :bib_no, :item_format, :holdings_records_collection, :ignore_item_format
  # ignore_item_format set to true; will allow code to load holdings without checking whether the format has holdings available
 
  def initialize(bib_no, item_format='Unknown', options={})
  	self.bib_no = bib_no
    self.item_format = item_format
  	self.holdings_records_collection = options[:holdings_records_collection] || nil
    self.ignore_item_format = options[:ignore_item_format] || false
  end


  # Can the item be request/put on hold.. The item availaility needs to be false and there needs to be holding information stored for the item
  # Item is requestable if any of the requestable_locations (See blah config file) copies are unavailable
  # Modified requestable rules for new reservation service: all items with holdings in a requestable location are requestable regardless of availability
  def requestable?
    requestable = false

    LibraryItem.requestable_locations.each do |location_prefix|
      available = self.send("available_at_#{location_prefix}?")
     !available.nil? &&available ? true : false
      break if requestable
    end
    requestable
  end


  #DEPRECATED: This should no longer be used to determine the whether an item is bookable# Use LibraryItemsHelper#item_bookable?(document)
  #Can the item be booked (see: blah_config - bookable_item.location) - Bases bookability based upon the location stored within the item_locations field
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
    # ignore_item_format - true will disregard whether holdings are available for that type of library item
    if ignore_item_format || self.holdings_available?
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

  # Is the item available for inter_library_loan? 
  def inter_library_loan?
    inter_library_loan = false

    # unless there isn't holdings_record_collection or it is empty...
    unless self.holdings_records_collection.nil? || self.holdings_records_collection.empty?
      item_locations  = self.holdings_records_collection.local_locations

      item_locations.each do |location|
        inter_library_loan = location.include? "Via Inter Library Loan"
        break if inter_library_loan
      end
    end

    return inter_library_loan
  end
 
  private

  def self.available_status_list
    APP_CONFIG['record_status']['available']
  end

  def self.bookable_item_locations
    APP_CONFIG['bookable_item']['location']
  end

  def self.holdings_ignore_list
    APP_CONFIG['holdings']['ignore']
  end

  def self.requestable_locations
    APP_CONFIG['requestable_locations']
  end

  # Method based upon the requestable_locations config
  # Builds available_at_#{location_prefix}? methods to determine whether an item is available at particular location
  # Location_prefix is loaded from list stored in the config requestable_locations in blah_config.yml
  LibraryItem.requestable_locations.each do |location_prefix|
    define_method("available_at_#{location_prefix}?") do |*args| 
      available = nil

      if holdings_available? 
        availability = self.holdings_records_collection.holdings_at(location_prefix).availabilities

        # availability is empty when the item doesn't exist at that particular location (so no availability processing needed)
        unless availability.empty? 
          available_statuses = LibraryItem.available_status_list
          available = false

          unless availability.nil?
            available_statuses.each do |status| 
              available = availability.any? { |s| s.downcase.include?(status) }
              break if available       
            end
          end
        end
      end
      return available
    end
  end

end
