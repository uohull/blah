class HomeController < ApplicationController
  include BlacklightGoogleAnalytics::ControllerExtraHead
  include Blacklight::Configurable
  include Blacklight::SolrHelper

  copy_blacklight_config_from(CatalogController)
  
  # Show the Home page for Bl@H aplication 
  def show
  end

  # Get the FAQ page
  def faq
  end

  # Get the cookies page
  def cookies
  end

end