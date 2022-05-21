require 'net/http'

class Call
  def self.base_url
    "http://ls-auth-api_web_1:5000/"
  end

  def self.api_key
    ENV['LS_AUTH_API_KEY']
  end

  def self.auth_token
    ENV['LS_AUTH_AUTH_TOKEN']
  end
end
