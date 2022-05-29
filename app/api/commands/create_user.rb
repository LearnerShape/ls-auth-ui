module Commands
  class CreateUser < Call
    def self.do(name:, email:)
      uri = URI("#{base_url}api/v1/users/")
      res = Net::HTTP.start(uri.host, uri.port) do |http|
        req = Net::HTTP::Post.new(uri)
        req['Content-Type'] = 'application/json'
        req['X-API-Key'] = api_key
        req['X-Auth-Token'] = auth_token
        req.body = {name: name, email: email}.to_json
        http.request(req)
      end
      JSON.parse(res.body)
    rescue Errno::ECONNREFUSED => e
      Rails.logger.warn("cannot connect to api: #{e}")
      {}
    rescue => e
      Rails.logger.warn("error: #{e}")
      {}
    end
  end
end
