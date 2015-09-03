require "net/https"
require "uri"
require "json"

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
# Example:
# # for hashtags:
# ruler.new url, pass, username
# ruler.hashtag('foo')
# ruler.hashtag('bar')
# ruler.tag('this is a tag')
# # add optional location
# ruler.location.lat('123')
# ruler.location.long('45')
# ruler.location.rad('0.01')
# # add rule to batch(adds to master queue array!)
# ruler.batch
# # produces rule: {'value':'#bar #foo point_radius:[123 45 0.01]', 'tag':'this is a tag'}
# # rule to get all tweets with twitter place id
# ruler.place('07d9d783adc83002')
# ruler.tag('twitter place id')
# ruler.batch
# # produces rule: {'value':'place:07d9d783adc83002', 'tag':'twitter place id'}
# # rule to get all tweets with twitter place id and hashtags
# ruler.place('07d9d783adc83002').hashtag('foo').hashtag('bar')
# ruler.tag('twitter place id and hashtags')
# ruler.batch
# # produces rule: {'value':'#foo #bar place:07d9d783adc83002', 'tag':'twitter place id'}
# # ...
# # send queued rules to Gnip
# ruler.add
#
# # delete hashtag
# ruler.new url, pass, username
# ruler.hashtag('foo')
# ruler.hashtag('bar')
# ruler.batch
# ruler.delete
#
#
module Gnip
  class Ruler

    include Gnip::Request

    attr_reader :uri, :url, :password, :username
    attr_reader :hashtags, :batch, :locations, :lat, :long, :places, :radius, :tag

    def initialize (url, username, password)
      @uri = URI.parse(url)
      @username = username
      @password = password
      @batch = []
      set_rule_vars
    end

    def hashtag( arg )
      @hashtags << arg
      self
    end

    def add_rules(params)
      result = make_add_request(params)
      result
    end
    
    def delete_rules(params)
      result = make_delete_request(params)
      result
    end

    # Add location data to the rule
    #
    def location
      self
    end

    def lat(arg)
      @lat = arg.to_f
      self
    end

    def long(arg)
      @long = arg.to_f
      self
    end

    # Miles
    #
    def radius(arg)
      @radius = arg.to_f
      self
    end

    # Add place ids to rules
    #
    def place( id )
      @places << id
      self
    end
    
    # Add tag to gnip rule
    #
    def tag(arg)
      @tag = arg.to_s
      self
    end

    # Generate the entire Gnip rule string for this instance.  Add rule to
    # batch.  Reset Gnip rule vars in preparation for next rule addition.
    #
    def batch
      # Add location rule, if set
      unless hashtags_format_gnip.empty? && location_format_gnip.empty? && places_format_gnip.empty?
        @batch << { 'value' => hashtags_format_gnip << location_format_gnip << places_format_gnip, 'tag' => @tag }
      end
      # Reset gnip rule vars to defaults
      set_rule_vars
      @batch
    end

    # Show current batch rule set. This is the pre-json rules we are submitting
    # to Gnip.
    #
    def show
      @batch
    end
    
    def reset
      @batch = []
    end

    # Send entire Gnip rule string (@batch) to Gnip
    #
    def add
      make_add_request @batch.to_json
    end

    # Send entire Gnip rule string (@batch) to Gnip
    #
    def delete
      make_delete_request @batch.to_json
    end

    #
    #
    def delete_hashtag_location(arg = {})
    end

    private

    # Generate hashtags string for the Gnip rules
    #
    def hashtags_format_gnip
      gnip_rule = ''
      # remove dups(uniq), downcase, reject empty strings
      # NOTE downcase make it easier to delete rules from Gnip
      @hashtags.uniq.reject{ |c| c.empty? }.each{|h| gnip_rule << "##{h.downcase} " }
      gnip_rule[0...-1]
    end

    # Generate location string for Gnip rules if lat, long, and radius are set
    # else return empty string
    #
    def location_format_gnip
      unless @lat.nil? || @long.nil? || @radius.nil?
        location = "point_radius:[#{@long} #{@lat} #{@radius}]"
        # prepend space for the rule if hashtags have been set
        location.prepend(" ") if @hashtags.any?
        location
      else
        ''
      end
    end

    # Generate places string for the Gnip rules.
    #
    def places_format_gnip
      place_string = ''
      unless @places.nil?
        @places.each do |place|
          place_string = "place:#{place}"
          place_string.prepend(" ") if @hashtags.any?
        end
        place_string
      else
        ''
      end
    end

    # Set Gnip rule variables to nil
    def set_rule_vars
      # reset rule vars to nil
      @hashtags = []
      @places = []
      @lat = nil
      @long = nil
      @radius = nil
      @tag = nil
    end

  end
end
