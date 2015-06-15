module Gnip
  class Ruler
    # Add rules for tracking on the twitter stream
    #
    # @param (String) JSON-ified string of Gnip rules to add to current ruleset
    # @return boolean
    #
    def make_add_request(arg)
      # Attempt to update the Gnip rule set
      begin
        response = request_post(arg)
      rescue
        sleep 5
        response = request_post(arg)
      end
      return true if response.code == "201"
      false
    end

  end
end

