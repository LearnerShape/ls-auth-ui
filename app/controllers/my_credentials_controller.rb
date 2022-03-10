class MyCredentialsController < ApplicationController
  def new
  end

  def create
    holder = Contact.find_or_create_by(email: current_user.email)
    authenticator_emails = params[:authenticators].split('\n')
    authenticators = authenticator_emails.map do |email|
      Contact.find_or_create_by(email: email)
    end

    skill = Skill.create(name: params[:name],
                         skill_type: params[:type],
                         description: params[:description])

    credential = Credential.create(holder: holder, skill: skill)

    holder_authentication = Authentication.create(credential: credential,
                                                  authenticator: holder)
    holder_authentication.mark_accepted

    authenticators.each do |authenticator|
      Authentication.create(credential: credential,
                            authenticator: authenticator)
    end

    if credential.authentications.is_accepted.any?
      credential.mark_authenticated
    end
    redirect_to action: :index
  end

  def index
    holder = Contact.find_or_create_by(email: current_user.email)
    @my_credentials = Credential.where(holder: holder).order(:status)
  end
end
