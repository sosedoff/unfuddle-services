require 'spec_helper'

describe 'Application' do
  it 'should respond "hello" on /' do
    get '/'
    last_response.should be_ok
    last_response.body.should == 'hello'
  end
  
  it 'should respond application version on /version' do
    get '/version'
    last_response.should be_ok
    last_response.body.should == "unfuddle-services v#{UnfuddleServices::VERSION}"
  end
  
  it 'should raise UnfuddleServices::InvalidConfigError if repo config was not found' do
    proc { UnfuddleServices.load_config(12345) }.should raise_error UnfuddleServices::InvalidConfigError
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
end
