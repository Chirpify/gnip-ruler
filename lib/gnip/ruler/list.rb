
module Gnip
  class Ruler

    # Returns a Hash list of tracking rules from the Gnip API
    #
    def list
      begin
        response = request_get
      rescue
        sleep 5
        response = request_get
      end
      return nil if response.body.nil?
      json(response.body)
    end

  end
end
