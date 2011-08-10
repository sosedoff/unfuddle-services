require 'spec_helper'

describe Services::Basecamp do
  it 'should be valid' do
    basecamp.valid?.should == false
    basecamp(:subdomain => 'foobar').valid?.should == false
    
    basecamp(
      :subdomain => 'foobar',
      :api_token => 'bar'
    ).valid?.should == false
    
    basecamp(
      :subdomain => 'foobar',
      :api_token => 'bar',
      :project => '1',
      :post => '1'
    ).valid?.should == true
  end
  
  it 'should perform a http request' do
    stub_request(:post, "https://API_TOKEN:X@foobar.basecamphq.com/projects/1/posts/1/comments").
       with(:body => "comment[body]=%3Cbr%2F%3E%3Cb%3E%239ff4adb49339636e63e0faa25d5259313b0f7b7c%3C%2Fb%3E%3Cbr%2F%3Eby%20Dan%20Sosedoff%20on%20Tue%2C%20June%2014%20%40%2007%3A04%20PM%3Cbr%2F%3E%3Ci%3Ecommit%20message%3C%2Fi%3E").
       to_return(:status => 200, :body => "", :headers => {})
    
    s = basecamp(
      :subdomain => 'foobar',
      :api_token => 'API_TOKEN',
      :project   => '1',
      :post      => '1'
    )
    changeset = Unfuddle::Changeset.new(fixture('changeset.xml'))
    
    s.valid?.should == true  
    s.push(changeset)
  end
end