class InviteAuthenticatorMailer < ApplicationMailer
  def invite
    @authenticator = params[:authenticator]
    @credential = params[:credential]
    @holder = params[:holder]
    if @authenticator.user.present?
      invite_existing
    else
      invite_new
    end
  end

  def invite_existing
    mail(to: @authenticator.email,
         subject: "New authentication request from #{ENV['LS_TEMPLATE_NAME']}",
         template_name: "invite_existing")
  end

  def invite_new
    mail(to: @authenticator.email,
         subject: "Welcome to #{ENV['LS_TEMPLATE_NAME']}",
         template_name: "invite_new")
  end
end
