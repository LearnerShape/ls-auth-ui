## frozen_string_literal: true

class HomeController < ApplicationController

  before_action :authenticate_user!

  def index
    json = ::Queries::GetUsers.do
    @users = json.fetch('users', [])
    Rails.logger.warn("@users=#{@users}")
  end
end
