
module Gnip
  class Ruler

    # Method to delete rules from the Gnip Rules API
    #
    # @param (String) JSON-ified string of Gnip rules to add to current ruleset
    # @return boolean
    #
    def delete(arg = delete_rules_json)
      # check if the rules set is empty, if so, return true, nothing to do.
      return true if delete_rules == []
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
