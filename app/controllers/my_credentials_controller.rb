class MyCredentialsController < ApplicationController
  def new
  end

  def create
    holder = current_user.contact
    authenticator_params = params[:authenticators].split("\n")
    authenticators = authenticator_params.map do |row|
      ne = NameAndEmail.parse(row)
      Contact.retrieve_or_build(name: ne.name, email: ne.email)
    end

    skill = Skill.create(name: params[:name],
                         skill_type: params[:type],
                         description: params[:description])

    created_skill = ::Commands::CreateSkill.do(user_id: holder.api_id,
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
      created_credential = ::Commands::CreateCredential.do(holder: holder.api_id,
                                                           skill: skill.api_id,
                                                           issuer: holder.api_id,
                                                           status: 'issued')
      api_id = created_credential.fetch('id', nil)
      holder_authentication.update(api_id: api_id) if api_id
    end

    authenticators.each do |authenticator|
      authentication = Authentication.create(credential: credential,
                                             authenticator: authenticator)
      created_credential = ::Commands::CreateCredential.do(holder: holder.api_id,
                                                           skill: skill.api_id,
                                                           issuer: authenticator.api_id,
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
    holder = current_user.contact
    @my_credentials = Credential.where(holder: holder).is_authenticated
  end
end
