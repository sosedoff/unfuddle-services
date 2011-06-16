require 'rubygems'
require 'sinatra'
require 'yaml'
require 'resque'

$LOAD_PATH << '.' if RUBY_VERSION > '1.9'

require 'lib/unfuddle'
require 'lib/services'

UnfuddleServices.root = File.expand_path(File.dirname(__FILE__))

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
    xml = request.body.read
    changeset = Unfuddle::Changeset.new(xml)
    Resque.enqueue(Services::PushJob, xml)
  rescue Unfuddle::ChangesetError => e
    halt 400, "Changeset Error: #{e.message}"
  rescue Services::InvalidServiceError => e
    halt 400, "Service Error: #{e.message}"
  rescue e
    e.message
  end
end