class InviteParticipantMailer < ApplicationMailer
  def invite
    @authenticator = params[:authenticator]
    @credential = params[:credential]
    @holder = params[:holder]
    if @holder.user.present?
      invite_existing
    else
      invite_new
    end
  end

  def invite_existing
    mail(to: @holder.email,
         subject: "New credential from skillsgraph.learnershape.com",
         template_name: "invite_existing")
  end

  def invite_new
    mail(to: @holder.email,
         subject: "Welcome to skillsgraph.learnershape.com",
         template_name: "invite_new")
  end
end
