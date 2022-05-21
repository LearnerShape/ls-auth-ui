class MyCredentialsController < ApplicationController
  def new
  end

  def create
    holder = current_user.contact
    authenticators = retrieve_or_build_authenticators_from_params

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
                                                           status: 'Issued')
      api_id = created_credential.fetch('id', nil)
      holder_authentication.update(api_id: api_id) if api_id
    end

    build_authentications_for_credential(holder: holder,
                                         credential: credential,
                                         authenticators: authenticators)

    if credential.authentications.is_accepted.any?
      credential.mark_authenticated
    end
    redirect_to action: :index
  end

  def index
    holder = current_user.contact
    @my_credentials = Credential.where(holder: holder).is_authenticated
  end

  def add_authenticators_form
    holder = current_user.contact
    @credential = Credential.where(id: params[:id]).first
    return head(:forbidden) if @credential.holder != holder
  end

  def add_authenticators
    holder = current_user.contact
    credential = Credential.where(id: params[:id]).first
    return head(:forbidden) if credential.holder != holder

    authenticators = retrieve_or_build_authenticators_from_params
    build_authentications_for_credential(holder: holder,
                                         credential: credential,
                                         authenticators: authenticators)

    redirect_to action: :index
  end

  private

  def retrieve_or_build_authenticators_from_params
    authenticator_params = params[:authenticators].split("\n")
    authenticator_params.map do |row|
      ne = NameAndEmail.parse(row)
      Contact.retrieve_or_build(name: ne.name, email: ne.email)
    end
  end

  def build_authentications_for_credential(holder:, credential:, authenticators:)
    authenticators.each do |authenticator|
      authentication = Authentication.create(credential: credential,
                                             authenticator: authenticator)
      created_credential = ::Commands::CreateCredential.do(holder: holder.api_id,
                                                           skill: credential.skill.api_id,
                                                           issuer: authenticator.api_id,
                                                           status: 'Requested')
      api_id = created_credential.fetch('id', nil)
      authentication.update(api_id: api_id) if api_id

      InviteAuthenticatorMailer.with(authenticator: authenticator, credential: credential, holder: holder).invite.deliver_now
    end
  end
end
