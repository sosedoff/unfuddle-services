require 'spec_helper'

describe Services::Campfire do
  it 'should be valid' do
    campfire.valid?.should == false
    campfire(:subdomain => 'foobar').valid?.should == false
    
    campfire(
      :subdomain => 'foobar',
      :api_token => 'bar'
    ).valid?.should == false
    
    campfire(
      :subdomain => 'foobar',
      :api_token => 'bar',
      :room => '1'
    ).valid?.should == true
  end
  
  it 'should perform a http request' do
    stub_request(:post, "https://bar:X@foobar.campfirenow.com/room/1/speak.json").
      to_return(:status => 200, :body => fixture('campfire_speak.json'))
      
    stub_request(:post, "https://bar:X@foo.campfirenow.com/room/1/speak.json").
      to_return(:status => 401, :body => fixture('campfire_speak.json'))
      
    stub_request(:post, "https://bar:X@bar.campfirenow.com/room/1/speak.json").
      to_return(:status => 404, :body => fixture('campfire_speak.json'))
    
    
    changeset = Unfuddle::Changeset.new(fixture('changeset.xml'))
    
    s1 = campfire(:subdomain => 'foobar', :api_token => 'bar', :room => '1')
    s2 = campfire(:subdomain => 'foo', :api_token => 'bar', :room => '1')
    s3 = campfire(:subdomain => 'bar', :api_token => 'bar', :room => '1')
    
    s1.valid?.should == true
    s2.valid?.should == true
    s3.valid?.should == true
    
    s1.push(changeset).should == 200
    s2.push(changeset).should == 401
    s3.push(changeset).should == 404
  end
end
