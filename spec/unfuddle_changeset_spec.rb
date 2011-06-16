require 'spec_helper'

describe Unfuddle::Changeset do
  it 'should raise ArgumentError if no XML data were provided' do
    proc { Unfuddle::Changeset.new }.should raise_error ArgumentError
  end
  
  it 'should validate incoming XML content' do
    proc {
      Unfuddle::Changeset.new('')
    }.should raise_error Unfuddle::ChangesetError, 'Changeset XML required!'
    
    proc {
      Unfuddle::Changeset.new('foobar')
    }.should raise_error Unfuddle::ChangesetError, 'Invalid XML data!'
    
    proc {
      Unfuddle::Changeset.new(fixture('sample.xml'))
    }.should raise_error Unfuddle::ChangesetError, 'Invalid changeset!'
    
    proc {
      Unfuddle::Changeset.new(fixture('invalid_changeset.xml'))
    }.should raise_error Unfuddle::ChangesetError, 'Invalid changeset!'
  end
  
  it 'should be filled with a proper data' do
    changeset = Unfuddle::Changeset.new(fixture('changeset.xml'))
  end
end
