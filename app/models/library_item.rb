class LibraryItem
	#bib_no - Bibliographic reference number used by Millenium 
  attr_accessor :bib_no, :holdings_records_collection


  def initialize(bib_no, options={})
  	self.bib_no = bib_no
  	self.holdings_records_collection = options[:holdings_records_collection] || nil
  end

  def available?
  	 available = false
  	 availability = self.holdings_records_collection.availabilities 
     available_statuses = LibraryItem.available_status_list

     unless availability.nil?
   			available_statuses.each do |status| 
   			   available = availability.any? { |s| s.downcase.include?(status) }
   			   break if available   		
   			end
      end
     return available
  end 

  def bookable?
    bookable = false
    item_locations  = self.holdings_records_collection.local_locations
    bookable_locations = LibraryItem.bookable_item_locations

    unless item_locations.nil?
        bookable_locations.each do |locations|
          bookable = item_locations.any? { |l| l.downcase.include?(locations.downcase) }
          break if bookable
        end
    end
    return bookable
  end

  def load_holdings_records_collection
    self.holdings_records_collection = HoldingsService.find_holdings(self.bib_no)
  end
 

  def self.available_status_list
    APP_CONFIG['record_status']['available']
  end

  def self.bookable_item_locations
    APP_CONFIG['bookable_item']['location']
  end

end   
