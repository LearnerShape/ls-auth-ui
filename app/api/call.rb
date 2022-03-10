require 'net/http'

class Call
  def self.base_url
    "http://host.docker.internal:5000/"
  end

  def self.api_key
    "a"
  end

  def self.auth_token
    "b"
  end
end
