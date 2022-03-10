## frozen_string_literal: true

class HomeController < ApplicationController

  before_action :authenticate_user!

  def index
    authenticator = Contact.find_or_create_by(email: current_user.email)
    @invited_authentications_count = Authentication.where(authenticator: authenticator).is_invited.count
  end
end
