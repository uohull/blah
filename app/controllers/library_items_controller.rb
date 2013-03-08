class LibraryItemsController < ApplicationController
  def show
  	bib_no = params["bib_no"]

  	@library_item = LibraryItem.new(bib_no)

    if bib_no
       @library_item.load_holdings_records_collection
     
       render :layout => false
    end
  end
end
