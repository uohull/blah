class HoldingsRecordController < ApplicationController
  def show
      @message = "test"
      flash[:message] = "Test message"
     #@holdings_record = HoldingsRecord
  end
end
