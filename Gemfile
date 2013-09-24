source 'https://rubygems.org'

gem 'rails', '3.2.13'

gem 'blacklight', '4.0.1'
gem 'blacklight_advanced_search', '~> 2.1.1'
#Blacklight google analytics plugin by Jason Ronallo
gem 'blacklight_google_analytics', '~> 0.0.1.pre2'

gem 'sqlite3'
gem 'json'

group :development do
  gem 'debugger', '~> 1.3.3'
end

group :production do
  # Uncomment for production
  # Add mysql config to database.yml
  #gem "mysql2", "~> 0.3.13"
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'jquery-rails'  
  gem 'bootstrap-sass', '~> 2.2.0'
  
  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platform => :ruby
  gem 'uglifier', '>= 1.0.3'
end


gem 'devise', '~> 2.2.7'
#devise_cas_authenticable is used to enable CAS integration
gem 'devise_cas_authenticatable', '~> 1.2.0'

gem 'unicode'

#Zoom Ruby binding to Z40.50 http://rubygems.org/gems/zoom
#gem 'zoom', '~> 0.4.1'
gem 'zoom', :git => 'https://github.com/bricestacey/ruby-zoom.git'

#Honeypot captcha - See https://github.com/curtis/honeypot-captcha
gem 'honeypot-captcha'

#connection_pool gem that enables us to pool Z39.50 connections - https://github.com/mperham/connection_pool
gem 'connection_pool', '~> 1.1.0'
