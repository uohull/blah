class ContactController < ApplicationController

 def new
    @message = Message.new
  end

  def create
    @message = Message.new(params[:message])

    if @message.valid?
      #Used delayed job to asynchronously deal with message (.delay.)
      NotificationsMailer.delay.new_message(@message)
      redirect_to(root_path, :notice => "Your message has been sent.")
    else
      flash.now.alert = "Please fill all fields."
      render :new
    end
  end

end
