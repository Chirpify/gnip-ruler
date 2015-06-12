require "net/https"
require "uri"
require "json"

def json(arg)
  JSON.parse(arg)
end

# Gnip Rules API Connection and Formatter
#
# Tag notes:
# http://support.gnip.com/apis/powertrack/overview.html#RuleTags
# "Note that tags cannot be updated on an existing rule, but can only be
# included when a rule is created. In order to “update” a tag, you need to
# first remove the rule, then add it again with the updated tag. The best
# solution is to simply use a unique identifier as your tag, which your system
# can associate with various other data points within your own app..."
#
# Duplicate Rules, different Tags
# If a rule exists at Gnip and you are attempting to add a rule with a new tag
# (but same rule), the new rule will not be added ie the tag will not be
# updated on Gnip.
#
# Rules AND'ing and OR'ing notes:
# http://support.gnip.com/apis/powertrack/rules.html
# Spaces are logical AND's. OR's are explicitly stated. Parenthesis are available
# to group expressions.
# Example:
#   `(apple OR iphone) ipad`
#    is equal to: (apple ipad) OR (iphone ipad)
# Both expressions match "apple ipad" or "iphone ipad"
#
#
# @todo
# Ideally this gem should work like this:
# # for hashtags:
# ruler.new url, pass, username
# ruler.hashtag('foo')
# ruler.hashtag('bar')
# ruler.tag('this is a tag')
# # add optional location
# ruler.location.lat('123')
# ruler.location.lon('45')
# ruler.location.rad('0.01')
# # add rule to batch(adds to master queue array!)
# ruler.batch
# # produces rule: {'value':'#bar #foo point_radius:[123 45 0.01]', 'tag':'this is a tag'}
# # go again
# # ...
# # send queued rules to Gnip
# ruler.add
#
#
module Gnip
  class Ruler

    attr :url, :username, :password
    attr_reader :uri, :rules, :delete_rules, :current_rules_list

    def initialize (url, username, password)
      @url ||= url
      @username ||= username
      @password ||= password
    end

    def generate_rule_set( rules = [] )
      current_rule_set
    end

    # Idempotent adding of hashtags to track in the Gnip Rules set.
    #
    # {
    #   value => ['foo', 'bar'],
    #   tag = > 'mytag'
    # }
    #
    def hashtag( arg = {} )
      # if no hashtags, return
      return if arg['value'].nil?

      # produce alphabetic hashtag group and format
      # @todo remove formatting till last
      #
      temp = ''
      arg['value'].sort_by{|h| h.downcase}.each {|h| temp << "##{h.downcase} " }

      # new rule, set tag if it exists
      new_rule = { "value" => temp[0...-1], "tag" => arg['tag'] || nil }

      # append new rule if it doesn't already exist
      rules << new_rule unless rule_exists(new_rule)
    end

    # Takes an Array of hashes to produced hashtag-based-on-location results
    #
    # # lat decimal
    # # long decimal
    # # radius is miles
    # # hashtags array of strings
    #
    # Example:
    # {
    #   lat => '45.5192172',
    #   long => '-122.6755683',
    #   radius => 0.1,
    #   hashtags => [ 'foo', 'bar' ]
    # }
    #
    # @TODO todd@chirpify.com
    #
    def hashtag_location (arg = {})
      #point_radius:[lon lat radius]
      # produce:
      # "#foo #bar point_radius:[45.5192172 -122.6755683 0.1]"
    end

    # Delete hashtags from the Gnip Rule set
    #
    # Similar to adding hashtag, but optional tag ignored.
    #
    # Example:
    # {
    #   value => ['foo', 'bar'],
    # }
    #
    def delete_hashtag(arg = {})
      # if no hashtags, return
      return if arg['value'].nil?

      # produce alphabetical hashtag group
      temp = ''
      arg['value'].sort_by{|h| h.downcase}.each {|h| temp << "##{h.downcase} " }

      # rule to delete
      delete_rule = { "value" => temp[0...-1] }
      # append delete rule to list of delete rules
      delete_rules << delete_rule
    end

    #
    #
    def delete_hashtag_location(arg = {})
    end

    def rules
      @rules ||= []
    end

    def delete_rules
      @delete_rules ||= []
    end

    # Makes call to Gnip to determine the current rules we are tracking. Sets
    # the rules list for this instance.
    #
    def current_rules_list
      @current_rules_list ||= list
    end

    private

    # Checks if the new rule has already been added to the current rule set or
    # exists in the current Gnip rule set. If either is true, this returns true.
    #
    def rule_exists(new_rule)
      return true if rules.any?{|h| h == new_rule }
      return true if current_rules_list.any?{|h| h == new_rule }
      false
    end

    # Format the rules and JSON-ify the rules for the Gnip POST body
    #
    def rules_json
      {
        'rules' => rules
      }.to_json
    end
    def delete_rules_json
      {
        'rules' => delete_rules
      }.to_json
    end

    # Rules hashtag formater
    #
    def hashtag_format( hash )
      # hash.each{ |k| ...add hash...}
    end

    #
    ## Request Based code - this could be moved out its own Module/Class ##
    #
    def uri
      @uri ||= URI.parse(url)
    end

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
      delete = Net::HTTP::Delete.new(uri.path)
      delete.body = json_rules
      delete.basic_auth(username, password)
      http.request(delete)
    end

  end
end
