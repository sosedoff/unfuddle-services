module UnfuddleServices
  VERSION = '0.2.0'.freeze
    
  class InvalidConfigError  < Exception ; end
  class ConfigNotFoundError < Exception ; end
    
  # Returns a configuration file assigned with repo
  def self.load_config(repo_id)
    path = "#{@@root}/config/hooks/#{repo_id}.yml"
    unless File.exists?(path)
      raise UnfuddleServices::ConfigNotFoundError, "Config file #{path} was not found!"
    end
    YAML.load_file(path)
  end
  
  # Returns a current app root
  def self.root
    @@root
  end
  
  # Sets a new root path
  def self.root= (path)
    @@root = path
  end
  
  # Creates a logger for the app
  def self.setup_logger
    path = File.join(@@root, 'tmp')
    Dir.mkdir(path) unless File.exists?(path)
    env = ENV['RACK_ENV'] || ENV['ENV'] || 'development'
    @@logger = Logger.new(File.join(path, "#{env}.log"))
  end
  
  # Returns a current application logger
  def self.logger
    @@logger
  end
end

require 'lib/services/base'
require 'lib/services/basecamp'
require 'lib/services/campfire'
require 'lib/services/postbin'