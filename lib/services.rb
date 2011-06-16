require 'lib/services/base'
require 'lib/services/basecamp'

module UnfuddleServices
  VERSION = '0.1.0'.freeze
    
  class InvalidConfigError  < Exception ; end
  class ConfigNotFoundError < Exception ; end
    
  def self.load_config(repo_id)
    path = "#{@@root}/config/hooks/#{repo_id}.yml"
    unless File.exists?(path)
      raise UnfuddleServices::ConfigNotFoundError, "Config file #{path} was not found!"
    end
    YAML.load_file(path)
  end
  
  def self.root
    @@root
  end
  
  def self.root= (path)
    @@root = path
  end
end