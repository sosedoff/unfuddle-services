require 'rubygems'
require 'sinatra'
require 'yaml'

require_relative 'lib/unfuddle'
require_relative 'lib/services'

module UnfuddleServices
  VERSION = '0.1.0'.freeze
  
  class InvalidConfigError < Exception ; end
  
  def self.load_config(repo_id)
    path = File.join(settings.root, 'config', 'hooks', "#{repo_id}.yml")
    unless File.exists?(path)
      raise UnfuddleServices::InvalidConfigError, "Config file #{path} was not found!"
    end
    YAML.load_file(path)
  end
end

configure :production do
  set :static,              false
  set :sessions,            false
  set :show_exceptions,     false
  set :raise_errors,        false
  set :run,                 false
  set :dump_errors,         false
  set :views,               false
end

get '/' do
  'hello'
end

get '/version' do
  "unfuddle-services v#{UnfuddleServices::VERSION}"
end

post '/push' do
  begin
    changeset = Unfuddle::Changeset.new(request.body.read)
    config = UnfuddleServices.load_config(changeset.repo)
    unless config.empty?
      config.each_pair do |service_name, options|
        service = Services.get(service_name, options.symbolize_keys)
        service.push(changeset)
      end
    end
  rescue Unfuddle::ChangesetError => e
    halt 400, "Changeset Error: #{e.message}"
  rescue Services::InvalidServiceError => e
    halt 400, "Service Error: #{e.message}"
  rescue e
    e.message
  end
end