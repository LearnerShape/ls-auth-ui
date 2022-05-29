module Commands
  class UpdateCredential < Call
    def self.accept(id:, issuer_id:)
      self.do(id: id, issuer_id: issuer_id, status: 'Issued')
    end

    def self.refuse(id:, issuer_id:)
      self.do(id: id, issuer_id: issuer_id, status: 'Rejected')
    end

    def self.revoke(id:, issuer_id:)
      self.do(id: id, issuer_id: issuer_id, status: 'Revoked')
    end

    def self.do(id:, issuer_id:, status:)
      uri = URI("#{base_url}api/v1/users/#{issuer_id}/credentials/#{id}/")
      res = Net::HTTP.start(uri.host, uri.port) do |http|
        req = Net::HTTP::Patch.new(uri)
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
    rescue => e
      Rails.logger.warn("error: #{e}")
      {}
    end
  end
end
