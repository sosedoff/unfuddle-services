module Unfuddle
  class AccountError < StandardError ; end

  class Account
    attr_reader :subdomain
    attr_reader :user
    attr_reader :password
  
    # Initialize a new unfuddle account
    #
    # subdomain - Unfuddle account subdomain
    # user      - Unfuddle account user
    # password  - Unfuddle account password
    #
    def initialize(subdomain, user, password)
      @subdomain = subdomain.to_s.strip
      @user      = user.to_s.strip
      @password  = password.to_s.strip
      
      raise AccountError, "Subdomain required!" if @subdomain.empty?
      raise AccountError, "Username required!"  if @user.empty?
      raise AccountError, "Password required!"  if @password.empty?
    end
    
    # Returns an API base url
    #
    def api_url
      "https://#{@user}:#{@password}@#{@subdomain}.unfuddle.com/api/v1"
    end
  end
end