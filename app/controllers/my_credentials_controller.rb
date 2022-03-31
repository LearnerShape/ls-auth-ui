class MyCredentialsController < ApplicationController
  def new
  end

  def create
    holder = Contact.find_or_create_by(email: current_user.email)
    authenticator_emails = params[:authenticators].split("\n")
    authenticators = authenticator_emails.map do |email|
      Contact.find_or_create_by(email: email)
    end

    skill = Skill.create(name: params[:name],
                         skill_type: params[:type],
                         description: params[:description])

    created_skill = ::Commands::CreateSkill.do(user_id: current_user.api_id,
                                               skill_name: skill.name,
                                               skill_type: skill.skill_type,
                                               skill_description: skill.description)
    api_id = created_skill.fetch('id', nil)
    skill.update(api_id: api_id) if api_id

    credential = Credential.create(holder: holder, skill: skill)

    holder_authentication = Authentication.create(credential: credential,
                                                  authenticator: holder)
    holder_authentication.mark_accepted

    if skill.api_id
      created_credential = ::Commands::CreateCredential.do(holder: current_user.api_id,
                                                           skill: skill.api_id,
                                                           issuer: current_user.api_id,
                                                           status: 'issued')
      api_id = created_credential.fetch('id', nil)
      holder_authentication.update(api_id: api_id) if api_id
    end

    authenticators.each do |authenticator|
      authentication = Authentication.create(credential: credential,
                                             authenticator: authenticator)
      created_credential = ::Commands::CreateCredential.do(holder: current_user.api_id,
                                                           skill: skill.api_id,
                                                           issuer: User.where(email: authenticator.email).first.api_id,
                                                           status: 'requested')
      api_id = created_credential.fetch('id', nil)
      authentication.update(api_id: api_id) if api_id
    end

    if credential.authentications.is_accepted.any?
      credential.mark_authenticated
    end
    redirect_to action: :index
  end

  def index
    holder = Contact.find_or_create_by(email: current_user.email)
    @my_credentials = Credential.where(holder: holder).is_authenticated
  end
end
