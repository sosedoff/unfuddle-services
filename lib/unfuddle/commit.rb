module Unfuddle
  class CommitError < StandardError ; end

  class Commit
    REQUIRED_FIELDS = ['commit', 'message', 'files'].freeze
  
    attr_reader :revision
    attr_reader :message
    attr_reader :files
  
    # Initialize a new Unfuddle::Commit object
    #
    # data - Hash with commit data (required)
    #
    def initialize(data={})
      raise CommitError, "Commit data required!" if data.empty?
      
      unless (REQUIRED_FIELDS & data.keys).size == REQUIRED_FIELDS.size
        raise CommitError, "Invalid commit data!"
      end
      
      @revision = data['commit']
      @message  = data['message']
      @files    = data['files'].map { |f| f['file'] }
    end
    
    # Returns a string representation of commit
    #
    # html - Render as html if set to true (default: false)
    #
    # @return [String]
    #
    def to_s(html=false)
      str = []
      @files.each { |f| str << "[#{f['action']}] #{f['name']}" }
      str.join(html ? "<br/>" : "\n")
    end
  end
end