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
end
