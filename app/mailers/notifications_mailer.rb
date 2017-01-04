class NotificationsMailer < ActionMailer::Base
  default :from => "noreply@hull.ac.uk"

  def new_message(message)
    @message = message
    mail(:to => APP_CONFIG['contact_form_email'], :bcc => APP_CONFIG['contact_form_bcc'], :subject => "Blacklight Feedback: #{message.subject}")
  end


end
