require 'active_support'

module Blah
  extend ActiveSupport::Autoload
  autoload :Exceptions
  autoload :Utils
end

require 'blah'