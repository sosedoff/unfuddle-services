module Services
  class Postbin < Services::Base
    def initialize(config={})
      @config = config || {}
      @token  = @config[:token].to_s.strip
    end
    
    def push(changeset)
      http_post("http://www.postbin.org/#{@token}", changeset.xml)
    end
    
    def valid?
      !@token.empty?
    end
  end
end