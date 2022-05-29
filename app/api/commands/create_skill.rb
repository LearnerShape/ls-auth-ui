module Commands
  class CreateSkill < Call
    def self.do(user_id:, skill_name:, skill_type:, skill_description:)
      uri = URI("#{base_url}api/v1/users/#{user_id}/skills/")
      res = Net::HTTP.start(uri.host, uri.port) do |http|
        req = Net::HTTP::Post.new(uri)
        req['Content-Type'] = 'application/json'
        req['X-API-Key'] = api_key
        req['X-Auth-Token'] = auth_token
        req.body = { author_id: user_id,
                     skill_type: skill_type,
                     skill_details: { name: skill_name, subject: skill_description }}.to_json
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
