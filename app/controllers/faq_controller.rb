class FaqController < ApplicationController
	  include Blacklight::Configurable
  include Blacklight::SolrHelper

  copy_blacklight_config_from(CatalogController)
  
	def index
	end
end