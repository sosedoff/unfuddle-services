require 'spec_helper'

describe Services do
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
  end
end
