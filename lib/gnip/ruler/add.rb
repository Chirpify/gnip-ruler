module Gnip
  class Ruler
    # Add rules for tracking on the twitter stream
    #
    # @param (String) JSON-ified string of Gnip rules to add to current ruleset
    # @return boolean
    #
    def make_add_request(arg)
      # Attempt to update the Gnip rule set
      rules = "{ \"rules\": #{arg} }"
      begin
        response = request_post(rules)
      rescue
        sleep 5
        response = request_post(rules)
      end
      return true if response.code.to_s == "201"
      false
    end

  end
end

