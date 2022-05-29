require 'net/http'

class Call
  def self.base_url
    ENV["LS_AUTH_API_URI"]
  end

  def self.api_key
    ENV['LS_AUTH_API_KEY']
  end

  def self.auth_token
    ENV['LS_AUTH_AUTH_TOKEN']
  end
end
