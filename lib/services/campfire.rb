module Services
  class Campfire < Services::Base
    def initialize(config={})
      @config     = config
      @subdomain  = config[:subdomain]
      @api_token  = config[:api_token]
      @room       = config[:room]
      @url        = "https://#{@api_token}:X@#{@subdomain}.campfirenow.com"
    end
    
    def render(c)
      "New repo commit #{c.commit[0,7]} by #{c.author} on #{c.date} -> #{c.message}"
    end
    
    def push(changeset)
      headers = {:content_type => :json, :accept => :json}
      data = {:message => {:body => render(changeset), :type => "TextMessage"}}.to_json
      http_post("#{@url}/room/#{@room}/speak.json", data, headers) do |resp|
        return resp.code
      end
    end
    
    def valid?
      ([:subdomain, :api_token, :room] & @config.keys).size == 3
    end
  end
end