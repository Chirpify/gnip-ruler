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
      puts "Submitting to Rules Endpoint The Following: ==>"
      puts rules
      begin
        response = request_post(rules)
      rescue
        sleep 5
        response = request_post(rules)
      end
      puts "Response From Gnip Was =====>"
      puts response
      return true if response.code.to_s == "201"
      false
    end

  end
end

