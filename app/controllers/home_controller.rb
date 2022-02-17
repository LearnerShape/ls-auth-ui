require 'net/http'

class HomeController < ApplicationController

  before_action :authenticate_user!

  def index

    uri = URI('http://0.0.0.0:5000/api/v1/users/')
    req = Net::HTTP::Get.new(uri)
    req['X-API-Key'] = 'a'
    req['X-Auth-Token'] = 'b'

    res = Net::HTTP.start(uri.hostname, uri.port) {|http|
      http.request(req)
    }

    @users = JSON.parse(res.body)['users']
    Rails.logger.warn("@users=#{@users}")
  end
end
