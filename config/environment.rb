# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Blah::Application.initialize!

APP_CONFIG = YAML.load_file("#{Rails.root}/config/blah_config.yml")[Rails.env]
