
module Gnip
  class Ruler

    # Method to delete rules from the Gnip Rules API
    #
    # @param (String) JSON-ified string of Gnip rules to add to current ruleset
    # @return boolean
    #
    def make_delete_request(arg)
      # check if the rules set is empty, if so, return true, nothing to do.
      begin
          response = request_delete(arg)
      rescue
          sleep 5
          response = request_delete(arg)
      end

      return true if response.code == "200"
      false
    end
  end
end
