module Unfuddle
  class Client
    include Unfuddle::Request
  
    attr_reader :account
  
    # Initialize a new Unfuddle::Client object
    #
    # subdomain - Unfuddle account subdomain
    # user      - Unfuddle account user
    # password  - Unfuddle account password
    #
    def initialize(subdomain, user, password)
      @account = Account.new(subdomain, user, password)
      check_credentials
    end
    
    # Get a single commit details
    #
    # repository_id - Repository ID (required)
    # revision      - Commit revision ID (required)
    #
    # @return [Unfuddle::Commit]
    #
    def commit(repository_id, revision)
      data = request("/repositories/#{repository_id}/commit", :commit => revision)
      Unfuddle::Commit.new(data)
    end
    
    private
    
    # Check unfuddle account credentials
    #
    # @return [Boolean]
    #
    def check_credentials
      begin
        request("/account")
        true
      rescue Exception => ex
        raise Unfuddle::AccountError, "Invalid account credentials!"
      end
    end
  end
end