require 'active_support/core_ext'

module Unfuddle
  class ChangesetError < Exception ; end
  
  class Changeset
    FIELDS = %w(repository_id revision message committer_name committer_date).freeze
    
    attr_reader :author
    attr_reader :message
    attr_reader :date
    attr_reader :commit
    attr_reader :repo
    
    def initialize(xml)
      xml = xml.to_s.strip
      raise ChangesetError, 'Changeset XML required!' if xml.empty?
      
      begin
        @data = Hash.from_xml(xml)
      rescue REXML::ParseException
        raise ChangesetError, 'Invalid XML data!'
      end
      
      raise ChangesetError, 'Invalid changeset!' unless @data.key?('changeset')
      
      @data = @data['changeset']
      
      unless (FIELDS & @data.keys).size == FIELDS.size
        raise ChangesetError, 'Invalid changeset!'
      end
      
      @commit  = @data['revision']
      @author  = @data['committer_name']
      @message = @data['message']
      @date    = @data['committer_date']
      @repo    = @data['repository_id']
    end
  end
end