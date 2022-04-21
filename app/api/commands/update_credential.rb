module Commands
  class UpdateCredential < Call
    def self.accept(id:)
      self.do(id: id, status: 'Issued')
    end

    def self.refuse(id:)
      self.do(id: id, status: 'Rejected')
    end

    def self.do(id:, status:)
      uri = URI("#{base_url}api/v1/credentials/#{id}/")
      res = Net::HTTP.start(uri.host, uri.port) do |http|
        req = Net::HTTP::Put.new(uri)
        req['Content-Type'] = 'application/json'
        req['X-API-Key'] = api_key
        req['X-Auth-Token'] = auth_token
        req.body = { status: status }.to_json
        http.request(req)
      end
      JSON.parse(res.body)
    rescue Errno::ECONNREFUSED => e
      Rails.logger.warn("cannot connect to api: #{e}")
      {}
    end
  end
end
