require 'rubygems'
require 'sinatra'
require 'yaml'

require_relative 'lib/unfuddle'
require_relative 'lib/services'

module UnfuddleServices
  VERSION = '0.1.0'.freeze
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
    hook = YAML.load(File.read(File.join(settings.root, 'config', 'hooks', "#{changeset.repo}.yml")))
    hook.each_pair do |type, data|
      service = Services.get(type, data.symbolize_keys)
      puts service.inspect
      service.push(changeset)
    end  
  rescue Unfuddle::ChangesetError => e
    halt 400, "Changeset Error: #{e.message}"
  rescue Services::InvalidServiceError => e
    halt 400, "Service Error: #{e.message}"
  rescue e
    e.message
  end
end