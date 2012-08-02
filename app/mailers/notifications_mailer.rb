class NotificationsMailer < ActionMailer::Base
  default :from => "noreply@hull.ac.uk"
  default :to => APP_CONFIG['contact_form_email']

  def new_message(message)
    @message = message
    mail(:subject => "Blacklight Feedback: #{message.subject}")
  end


end
