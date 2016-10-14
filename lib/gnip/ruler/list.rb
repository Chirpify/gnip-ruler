
module Gnip
  class Ruler

    # Returns a Hash list of tracking rules from the Gnip API
    #
    def list_current_rules
      begin
        response = request_get
      rescue Exception => e
        puts "#{e.inspect}"
        response = request_get
      end
      return [] if response.body.nil?
      json(response.body)['rules']
      #json('[{"value":"#foo #bar","tag":null}]')
    end

    # For easy
    #
    def list
      list_current_rules
    end

    def list_parsed
      result = Hash.new
      list.each do |k|
        result.merge!( {'value' => deformat_hashtag(k['value']), 'tag' => k['tag']} )
      end
      result
    end

    private

    # Parse for hashtag information from Gnip rule string
    #
    def deformat_hashtag(string)
      value = Array.new
      # look for hashtags
      sp = string.split(' ')
      sp.each { |v| value << v.tr('#', '') if v.start_with? '#'}
      value.sort_by{|word| word.downcase}
    end

    # Parse for location information from Gnip rule string
    # @todo
    #
    def de_format_locations(string)
      #   lat => '45.5192172',
      #   long => '-122.6755683',
      #   radius => 0.1,
      # look for locations
      loc.each do |k|
        sp = k.split('point_radius:')
      end
      string
    end

  end
end
