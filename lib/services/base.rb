require 'rest-client'

module Services
  extend ActiveSupport::Inflector
  
  class InvalidServiceError < Exception ; end
  
  class Base
    def http_post(url, params)
      RestClient.post(url, params)
    end
  end
  
  def self.get(name, data={})
    begin
      Services.const_get(classify(name)).new(data)
    rescue NameError
      raise InvalidServiceError, "Service #{name} is not available"
    end
  end
end
