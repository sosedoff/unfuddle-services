require 'rest-client'
require 'multi_json'

module Unfuddle
  module Request
    # Perform a GET request
    #
    # path - Request path (not absolute)
    # params - Hash with request parameters (optional)
    #
    # @return [Hash]
    #
    def request(path, params={})
      url = account.api_url
      url  << path
      body = RestClient.get(url, params.merge(:accept => :json)).body
      MultiJson.decode(body)
    end
  end
end