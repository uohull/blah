require 'active_support'

module Blah
  extend ActiveSupport::Autoload
  autoload :Exceptions
end

require 'blah'