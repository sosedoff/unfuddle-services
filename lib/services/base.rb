require 'rest-client'

module Services
  extend ActiveSupport::Inflector
  
  class InvalidServiceError < Exception ; end
  
  class Base
    def http_post(url, params)
      RestClient.post(url, params)
    end
  end
  
  class PushJob
    @queue = :push_jobs
    
    def self.perform(changeset_xml)
      changeset = Unfuddle::Changeset.new(changeset_xml)  
      config = UnfuddleServices.load_config(changeset.repo)
      unless config.empty?
        config.each_pair do |service_name, options|
          begin
            service = Services.get(service_name, options.symbolize_keys)
            service.push(changeset)
          rescue Services::InvalidServiceError
            # TODO: Log this
          end
        end
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
