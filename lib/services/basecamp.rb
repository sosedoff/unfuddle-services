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
      msg  = "<br/><b>##{data.commit}</b><br/>"
      msg << "by #{data.author} on #{data.date.strftime("%a, %B %d @ %I:%M %p")}<br/>"
      msg << "<i>#{data.message.gsub(/\n/, '<br/>')}</i>"
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