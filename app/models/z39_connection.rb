require 'singleton'
require 'zoom'

# A Z39Connection Singleton Object that returns a connection pool to a Z39.50 Server (using the RubyZoom library)
# uses connection_pool library to create the pool. 
#
# On initialization the new connection pool is created with preset size and timeout.  
# Classes utilising the singleton object can call 'reload_connection_pool' if there are connection issues
#
class Z39Connection 
  include Singleton

  attr_reader :conn_pool

  def initialize
    create_connection_pool 
  end

  # Reload the connection pool
  def reload_connection_pool
  	#nil's conn_pool attribute and recreates using create_connection_pool
    @conn_pool = nil
    create_connection_pool
  end

  private

  def create_connection_pool
    @conn_pool = ConnectionPool.new(size: z39_connection_pool_size, timeout: z39_connection_timeout) { ZOOM::Connection.open(catalogue_server_addr, catalogue_server_port) }
  end

  def catalogue_server_addr
    APP_CONFIG['catalogue_server_address']
  end

  def catalogue_server_port
    APP_CONFIG['catalogue_server_port']
  end

  def z39_connection_pool_size
    APP_CONFIG['z39_connection_pool_size']
  end

  def z39_connection_timeout
    APP_CONFIG['z39_connection_timeout']
  end

end