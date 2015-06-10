
module Gnip
  class Ruler

    # Method to delete rules from the Gnip Rules API
    #
    # @param (String) JSON-ified string of Gnip rules to add to current ruleset
    # @return boolean
    #
    def make_delete_request(arg)
      rules = "{ \"rules\": #{arg} }"
      begin
          response = request_delete(rules)
      rescue
          sleep 5
          response = request_delete(rules)
      end

      return true if response.code == "200"
      false
    end
  end
end
