require 'spec_helper'

describe Services do
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
      
    end
  end
end
