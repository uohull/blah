class HomeController < ApplicationController
	include Blacklight::Configurable
	include Blacklight::SolrHelper

	copy_blacklight_config_from(CatalogController)
  
  	# Show the Home page for Bl@H aplication 
  	def show
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