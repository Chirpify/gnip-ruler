
module Gnip
  class Ruler

    # Method to delete rules from the Gnip Rules API
    #
    # @param (String) JSON-ified string of Gnip rules to add to current ruleset
    # @return boolean
    #
    def make_delete_request(arg)
      puts "Submitting to Rules FOR *DELETING* Endpoint The Following: ==>"
      rules = "{ \"rules\": #{arg} }"
      puts rules
      begin
        response = request_delete(rules)
      rescue
        sleep 5
        response = request_delete(rules)
      end
      puts "Gnip Response for Deleting!!"
      puts response
      return true if response.code.to_s == "200"
      false
    end
  end
end
