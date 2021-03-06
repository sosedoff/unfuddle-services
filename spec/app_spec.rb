require 'spec_helper'

describe 'Application' do
  it 'should respond "hello" on /' do
    get '/'
    last_response.should be_ok
    last_response.body.should == 'unfuddle-services'
  end
  
  it 'should respond application version at /version' do
    get '/version'
    last_response.should be_ok
    last_response.body.should == UnfuddleServices::VERSION
  end
  
  it 'should process empty push request' do
    post '/push'
    last_response.status.should == 400
    last_response.body.should match /changeset xml required/i
  end
  
  it 'should process invalid push request' do
    post '/push', 'some stupid data'
    last_response.status.should == 400
    last_response.body.should match /invalid xml data/i
    
    post '/push', fixture('sample.xml')
    last_response.status.should == 400
    last_response.body.should match /invalid changeset/i
    
    post '/push', fixture('invalid_changeset.xml')
    last_response.status.should == 400
    last_response.body.should match /invalid changeset/i
  end
  
  it 'should provide documentation at /help' do
    get '/help'
    last_response.status.should == 200
    
    files = Dir.glob("#{app.settings.root}/docs/*").map { |f| File.basename(f) }
    files.each do |f|
      last_response.body.include?(f).should == true
    end
  end
  
  it 'should provide help information for a service at /help/:service' do
    files = Dir.glob("#{app.settings.root}/docs/*").map { |f| File.basename(f) }
    files.each do |f|
      get "/help/#{f}"
      last_response.status.should == 200
    end
  end
end
