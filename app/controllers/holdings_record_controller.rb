class HoldingsRecordController < ApplicationController
  def index
    bib_no = params["bib_no"]
    if bib_no
       holdings_service = HoldingsService.new
       @holdings_records = holdings_service.find_holdings( bib_no )
       
       respond_to do |format|        
        format.html #index.html.erb
        format.json { render :json => @holdings_records }
      end

    end
  end

end
