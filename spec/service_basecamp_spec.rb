require 'spec_helper'

describe Services do
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
    
    it 'should send a request to basecamp' do
      stub_request(:post, "https://API_TOKEN:X@foobar.basecamphq.com/projects/1/posts/1/comments").
         with(:body => "comment[body]=%3Cb%3ECommit%3C%2Fb%3E%3Cbr%2F%3E%20%20%20%20%20ID%3A%209ff4adb49339636e63e0faa25d5259313b0f7b7c%3Cbr%2F%3E%20Author%3A%20Dan%20Sosedoff%3Cbr%2F%3Eon%202011-06-14%2019%3A04%3A40%20UTC%3Cbr%2F%3E%3Cbr%2F%3EMessage%3A%20commit%20message").
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
end
