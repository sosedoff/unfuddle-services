module Services
  class Basecamp < Services::Base
    def initialize(config={})
      @config     = config
      @subdomain  = config[:subdomain]
      @api_token  = config[:api_token]
      @project    = config[:project]
      @post       = config[:post]
      @url        = "https://#{@api_token}:X@#{@subdomain}.basecamphq.com"
    end
    
    def render(data)
      msg  = "<b>Commit</b><br/>"
      msg << "     ID: #{data.commit}<br/>"
      msg << " Author: #{data.author}<br/>on #{data.date}<br/><br/>"
      msg << "Message: #{data.message.gsub(/\n/, '<br/>')}"
      msg
    end
    
    def push(changeset)
      data = {:comment => {:body => render(changeset)}}
      http_post("#{@url}/projects/#{@project}/posts/#{@post}/comments", data)
    end
    
    def valid?
      ([:subdomain, :api_token, :project, :post] & @config.keys).size == 4
    end
  end
end