require 'rubygems'
require 'sinatra'
require 'yaml'
require 'resque'
require 'logger'

$LOAD_PATH << '.' if RUBY_VERSION > '1.9'

require 'lib/unfuddle'
require 'lib/services'
require 'lib/push_job'

UnfuddleServices.root = File.expand_path(File.dirname(__FILE__))
UnfuddleServices.setup_logger

configure :production do
  set :static,              false
  set :sessions,            false
  set :show_exceptions,     false
  set :raise_errors,        false
  set :run,                 false
  set :dump_errors,         false
  set :views,               false
end

helpers do
  def logger
    UnfuddleServices.logger
  end
end

get '/' do
  'hello'
end

get '/version' do
  UnfuddleServices::VERSION
end

post '/push' do
  begin
    xml = request.body.read
    changeset = Unfuddle::Changeset.new(xml)
    Resque.enqueue(PushJob, xml)
  rescue Unfuddle::ChangesetError => e
    logger.error "[error] Changeset error: #{e.inspect}, Content: #{xml.inspect}"
    halt 400, "Changeset Error: #{e.message}"
  rescue Services::InvalidServiceError => e
    logger.error "[error] Invalid service: #{e.inspect}, Content: #{xml.inspect}"
    halt 400, "Service Error: #{e.message}"
  rescue e
    e.message
  end
end