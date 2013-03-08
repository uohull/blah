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
end  