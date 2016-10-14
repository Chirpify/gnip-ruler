require 'base64'
require 'rest-client'
module Gnip
  module Request
    def http
      h = Net::HTTP.new(uri.host, uri.port)
      h.use_ssl = true
      h
    end

    # Make a GET request to the Gnip Rules API
    #
    def request_get
      get = Net::HTTP::Get.new(uri.request_uri)
      get.basic_auth(username, password)
      http.request(get)
    end

    # Make a POST request to the Gnip Rules API
    #
    def request_post(json_rules)
      post = Net::HTTP::Post.new(uri.path)
      post.body = json_rules
      post.basic_auth(username, password)
      http.request(post)
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
