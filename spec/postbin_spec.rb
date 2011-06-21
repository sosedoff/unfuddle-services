require 'spec_helper'

describe Services::Postbin do
  it 'should be valid' do
    postbin.valid?.should == false
    postbin({}).valid?.should == false
    postbin(:token => nil).valid?.should == false
    postbin(:token => '').valid?.should == false
    postbin(:token => '  ').valid?.should == false
    postbin(:token => 'qwe123').valid?.should == true
  end
  
  it 'should perform a http request' do
    stub_request(:post, "http://www.postbin.org/foo").
      with(:body => fixture('changeset.xml')).to_return(:status => 200)
      
    stub_request(:post, "http://www.postbin.org/bar").
      with(:body => fixture('changeset.xml')).to_return(:status => 404)
    
    changeset = Unfuddle::Changeset.new(fixture('changeset.xml'))
      
    s = postbin(:token => 'foo')
    s.valid?.should == true  
    s.push(changeset).should == 200
    
    s = postbin(:token => 'bar')
    s.valid?.should == true  
    s.push(changeset).should == 404
  end
end