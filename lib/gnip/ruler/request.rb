require 'base64'
require 'rest-client'
module Gnip
  module Request
    # Make a GET request to the Gnip Rules API
    #
    def request_get
      response = RestClient.get(@url, {:Authorization => form_auth_header}) 
      response
    end

    # Make a POST request to the Gnip Rules API
    #
    def request_post(json_rules)
      payload = json_rules
      response = RestClient.post(@url, payload, {:Authorization => form_auth_header}) 
      response
    end

    # Make a DELETE request to the Gnip Rules API
    #
    def request_delete(json_rules)
      url_with_delete = "#{@url}?_method=delete"
      payload = json_rules
      response = RestClient.post(url_with_delete, payload, {:Authorization => form_auth_header}) 
      response
    end
    
    def form_auth_header
      raw = "#{username}:#{password}"
      encoded = Base64.encode64(raw)
      "Basic #{encoded}"
    end
    
  end
end
