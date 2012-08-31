class NotificationsMailer < ActionMailer::Base
  default :from => "noreply@hull.ac.uk"
  default :to => APP_CONFIG['contact_form_email']

  def new_message(message)
    @message = message
    mail(:subject => "Blacklight Feedback: #{message.subject}")
  end

  def email_record(documents, details, url_gen_params)
    subject = I18n.t('blah.email_record.subject', :count => documents.length, :title => (documents.first.to_semantic_values[:title] rescue 'N/A') )
    documents_display = ""

    documents.each do |document|
      semantics = document.to_semantic_values
      body = []
      body << I18n.t('blacklight.email.text.title', :value => semantics[:title].join(" ")) unless semantics[:title].blank?
      body << I18n.t('blacklight.email.text.author', :value => semantics[:author].join(" ")) unless semantics[:author].blank?
      body << I18n.t('blacklight.email.text.language', :value => semantics[:language].join(" ")) unless semantics[:language].blank?
      body << t('blacklight.email.text.url', :url =>polymorphic_path(document, {:only_path => false}.merge(url_gen_params))) 
      body << "" unless body.empty?
      body << "" unless body.empty?    
 
      documents_display << body.join("\n") unless body.empty?

     end

    @documents_display = documents_display
    @message        = details[:message]

    mail(:to => details[:to],  :subject => subject)
  end


end
