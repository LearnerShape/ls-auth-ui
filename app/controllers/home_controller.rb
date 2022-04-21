class HomeController < ApplicationController

  def index
    authenticator = current_user.contact
    @invited_authentications_count = Authentication.where(authenticator: authenticator).is_invited.count
  end
end
