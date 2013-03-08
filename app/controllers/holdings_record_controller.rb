class HoldingsRecordController < ApplicationController
  def index
    bib_no = params["bib_no"]

    if bib_no
        @holdings_records = HoldingsService.find_holdings( bib_no )
        render :layout => false
    end
  end
  

end
