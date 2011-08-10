require 'spec_helper'

describe 'Unfuddle::Account' do
  it 'raises AccountError on missing parameters' do
    proc { Unfuddle::Account.new(nil, nil, nil) }.
      should raise_error Unfuddle::AccountError
      
    proc { Unfuddle::Account.new('w', nil, nil) }.
      should raise_error Unfuddle::AccountError
      
    proc { Unfuddle::Account.new('w', 't', nil) }.
      should raise_error Unfuddle::AccountError
      
    proc { Unfuddle::Account.new('w', 't', 'f') }.
      should_not raise_error Unfuddle::AccountError
  end
  
  it 'returns a proper API url' do
    acc = Unfuddle::Account.new('foo', 'bar', 'megabar')
    acc.api_url.should == 'https://bar:megabar@foo.unfuddle.com/api/v1'
  end
end