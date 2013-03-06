class HoldingsRecord
  attr_accessor :local_location, :call_number, :availability 

  def initialize(local_location, call_number, availability)
    @local_location = local_location
    @call_number = call_number
    @availability = availability
  end
end
