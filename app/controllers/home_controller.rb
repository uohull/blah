class HomeController < ApplicationController
  	include BlacklightGoogleAnalytics::ControllerExtraHead
	include Blacklight::Configurable
	include Blacklight::SolrHelper

	copy_blacklight_config_from(CatalogController)
  
  	# Show the Home page for Bl@H aplication 
  	def show

  		referer = request.referer

 			#If the referer is library.hull.ac.uk display warning about catalogue terminal issue (images)
  		unless referer.nil? 
  			 if referer.include? "library.hull.ac.uk"
					flash[:notice] = t('blah.home.notice.opac_warning').html_safe
  			 end
  		end
  	
  		#show action uses the blacklight-home layout
  		render :layout => 'blacklight-home'
  	end
  	
  	# Get the FAQ page
	def faq
	end

	# Get the cookies page
	def cookies
	end

end