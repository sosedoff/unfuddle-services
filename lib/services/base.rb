require 'rest-client'

module Services
  extend ActiveSupport::Inflector
  
  class InvalidServiceError < Exception ; end
  
  class Base
    # HTTP Post helper
    # Yields response if block given
    def http_post(url, params={}, headers={})
      if block_given?
        RestClient.post(url, params, headers) { |resp, req, result| yield(resp) }
      else
        RestClient.post(url, params, headers)
      end
    end
  end
  
  # Initialize a new service with data
  def self.get(name, data={})
    begin
      Services.const_get(classify(name)).new(data)
    rescue NameError
      raise InvalidServiceError, "Service #{name} is not available"
    end
  end
  
  # Returns true if service exists
  def self.exists?(name)
    begin
      Services.const_get(classify(name))
      true
    rescue NameError
      false
    end
  end
end
