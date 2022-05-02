require 'net/http'

class Call
  def self.base_url
    "http://ls-auth-api_web_1:5000/"
  end

  def self.api_key
    "a"
  end

  def self.auth_token
    "b"
  end
end
