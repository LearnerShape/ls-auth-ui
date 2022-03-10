class MyInvitedAuthenticationsController < ApplicationController
  def index
    authenticator = Contact.find_or_create_by(email: current_user.email)
    @my_authentications = Authentication.where(authenticator: authenticator).is_invited
  end
end
