module Services
  class Campfire < Services::Base
    def initialize(config={})
      @config     = config
      @subdomain  = config[:subdomain]
      @api_token  = config[:api_token]
      @room       = config[:room]
      @url        = "https://#{@api_token}:X@{@subdomain}.campfirenow.com"
    end
    
    def render(data)
      msg  = "<b>Commit</b><br/>"
      msg << "     ID: #{data.commit}<br/>"
      msg << " Author: #{data.author}<br/>on #{data.date}<br/><br/>"
      msg << "Message: #{data.message.gsub(/\n/, '<br/>')}"
      msg
    end
    
    def push(changeset)
      data = {:message => {:body => render(changeset), :type => "TextMessage"}}.to_json,
      http_post("#{@url}/room/#{@room}/speak.json", data)
    end
    
    def valid?
      ([:subdomain, :api_token, :project, :post] & @config.keys).size == 4
    end
  end
end