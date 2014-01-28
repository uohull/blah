# Load the rails application
require File.expand_path('../application', __FILE__)

# Load the Blah application config - Important needs to be loaded before the Application initializes
APP_CONFIG = YAML.load_file("#{Rails.root}/config/blah_config.yml")[Rails.env]

# Initialize the rails application
Blah::Application.initialize!