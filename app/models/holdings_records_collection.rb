class HoldingsRecordsCollection < Array
  
  def call_numbers
    collect do |i|
      i.call_number
    end
  end

  def local_locations
    collect do |i|
      i.local_location
    end
  end

  def availabilities
    collect do |i|
      i.availability
    end
  end 

  # Returns holdings that are held at the location specified by prefix i.e. "bjl" or "kdl" etc...
  def holdings_at location_prefix
    HoldingsRecordsCollection.new(select {|h| h.local_location.downcase.include? location_prefix.downcase })
  end

end  