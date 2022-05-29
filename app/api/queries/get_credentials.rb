require 'net/http'

module Queries
  class GetCredentials < Call
    def self.do(holder_id:)
      uri = URI("#{base_url}api/v1/users/#{holder_id}/credentials/")
      req = Net::HTTP::Get.new(uri)
      req['X-API-Key'] = api_key
      req['X-Auth-Token'] = auth_token

      res = Net::HTTP.start(uri.hostname, uri.port) {|http|
        http.request(req)
      }
      JSON.parse(res.body)
    rescue Errno::ECONNREFUSED => e
      Rails.logger.warn("cannot connect to api: #{e}")
      {}
    end
  end
end
