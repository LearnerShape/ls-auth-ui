class MyInvitedAuthenticationsController < ApplicationController
  def index
    authenticator = current_user.contact
    my_authentications = Authentication.where(authenticator: authenticator)
    @invited_authentications = my_authentications.is_invited
    @accepted_authentications = my_authentications.is_accepted
    @refused_authentications = my_authentications.is_refused
  end

  def accept
    authentication = Authentication.find(params[:id])
    authentication.mark_accepted
    ::Commands::UpdateCredential.accept(id: authentication.api_id,
                                        issuer_id: authentication.authenticator.api_id)

    # Since the credential is already self-authenticated,
    # we shouldn't need to do this.
    authentication.credential.mark_authenticated

    redirect_to action: :index
  end

  def refuse
    authentication = Authentication.find(params[:id])
    authentication.mark_refused
    ::Commands::UpdateCredential.refuse(id: authentication.api_id,
                                        issuer_id: authentication.authenticator.api_id)

    redirect_to action: :index
  end
end
