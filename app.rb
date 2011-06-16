require 'rubygems'
require 'sinatra'
require 'yaml'

$LOAD_PATH << '.' if RUBY_VERSION > '1.9'

require 'lib/unfuddle'
require 'lib/services'

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