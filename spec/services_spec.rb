require 'spec_helper'

describe Services do
  it 'should raise InvalidServiceError if no valid service was found' do
    proc { Services.get('foobar', {}) }.should raise_error Services::InvalidServiceError
  end
  
  it 'should return an instance of service' do
    Services.get('basecamp', {}).should be_an_instance_of Services::Basecamp
  end
  
  it 'should return true/false for exists?' do
    Services.exists?('basecamp').should == true
    Services.exists?('foobar').should == false
  end
end
