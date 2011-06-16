require 'rest-client'

module Services
  extend ActiveSupport::Inflector
  
  class InvalidServiceError < Exception ; end
  
  class Base
    def http_post(url, params)
      RestClient.post(url, params)
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
