class LibraryItemsController < ApplicationController
  def show
    bib_no = params["bib_no"]

    # Call with ignore_item_format as true - otherwise it will not return holdings (certain formats do no have holdings)
    @library_item = LibraryItem.new(bib_no, nil, { ignore_item_format: true })

    if bib_no
       @library_item.load_holdings_records_collection    
       render :layout => false
    end
  end
end
