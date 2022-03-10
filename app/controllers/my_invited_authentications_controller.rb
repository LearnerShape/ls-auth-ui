class MyInvitedAuthenticationsController < ApplicationController
  def index
    authenticator = Contact.find_or_create_by(email: current_user.email)
    my_authentications = Authentication.where(authenticator: authenticator)
    @invited_authentications = my_authentications.is_invited
    @accepted_authentications = my_authentications.is_accepted
    @refused_authentications = my_authentications.is_refused
  end

  def accept
    authentication = Authentication.find(params[:id])
    authentication.mark_accepted

    # Since the credential is already self-authenticated,
    # we shouldn't need to do this.
    authentication.credential.mark_authenticated

    redirect_to action: :index
  end

  def refuse
    authentication = Authentication.find(params[:id])
    authentication.mark_refused
    redirect_to action: :index
  end
end
