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
end
