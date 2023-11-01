class MyCredentialsController < CredentialsController
  def new
  end

  def create
    @invalid_name = params[:name].blank?
    @invalid_authenticators = NameAndEmail.invalid?(params[:authenticators])
    if @invalid_name || @invalid_authenticators
      render :new, status: :unprocessable_entity and return
    end

    holder = current_user.contact

    skill = Skill.create(name: params[:name],
                         skill_type: params[:type],
                         description: params[:description])

    created_skill = ::Commands::CreateSkill.do(user_id: holder.api_id,
                                               skill_name: skill.name,
                                               skill_type: skill.skill_type,
                                               skill_description: skill.description)
    Rails.logger.info("CreateSkill: response from api: #{created_skill}")

    api_id = created_skill.fetch('id', nil)
    skill.update(api_id: api_id) if api_id

    logo = Logo.create(creator_id: current_user.id)
    logo.image.attach(params[:image])

    skill.update(logo_id: logo.id)

    credential = Credential.create(holder: holder, skill: skill)

    holder_authentication = Authentication.create(credential: credential,
                                                  authenticator: holder)
    holder_authentication.mark_accepted

    if skill.api_id
      created_credential = ::Commands::CreateCredential.do(holder: holder.api_id,
                                                           skill: skill.api_id,
                                                           issuer: holder.api_id,
                                                           status: 'Issued')
      Rails.logger.info("CreateCredential (status 'Issued'): response from api: #{created_credential}")

      api_id = created_credential.fetch('id', nil)
      holder_authentication.update(api_id: api_id) if api_id
    end

    build_authentications_for_credential(holder: holder,
                                         credential: credential,
                                         authenticators: authenticators_from_params)

    if credential.authentications.is_accepted.any?
      credential.mark_authenticated
    end
    redirect_to action: :index
  end

  def index
    holder = current_user.contact
    update_transaction_ids_by_holder(holder_api_id: holder.api_id)
    @my_credentials = Credential.where(holder: holder).is_authenticated
  end

  def add_authenticators_form
    holder = current_user.contact
    @credential = Credential.where(id: params[:id]).first
    return head(:forbidden) if @credential.holder != holder
  end

  def add_authenticators
    @invalid_authenticators = NameAndEmail.invalid?(params[:authenticators])
    if @invalid_authenticators
      holder = current_user.contact
      @credential = Credential.where(id: params[:id]).first
      return head(:forbidden) if @credential.holder != holder
      render :add_authenticators_form, status: :unprocessable_entity and return
    end

    holder = current_user.contact
    credential = Credential.where(id: params[:id]).first
    return head(:forbidden) if credential.holder != holder

    build_authentications_for_credential(holder: holder,
                                         credential: credential,
                                         authenticators: authenticators_from_params)

    redirect_to action: :index
  end

  def add_logo_form
    holder = current_user.contact
    @credential = Credential.where(id: params[:id]).first
    return head(:forbidden) if @credential.holder != holder
  end

  def add_logo
    holder = current_user.contact
    credential = Credential.where(id: params[:id]).first
    return head(:forbidden) if credential.holder != holder

    logo = Logo.create(creator_id: current_user.id)
    logo.image.attach(params[:image])

    skill = credential.skill
    skill.update(logo_id: logo.id)

    redirect_to action: :index
  end

  private

  def authenticators_from_params
    NameAndEmail.retrieve_or_build_contacts(params[:authenticators])
  end

  def build_authentications_for_credential(holder:, credential:, authenticators:)
    authenticators.each do |authenticator|
      authentication = Authentication.create(credential: credential,
                                             authenticator: authenticator)
      created_credential = ::Commands::CreateCredential.do(holder: holder.api_id,
                                                           skill: credential.skill.api_id,
                                                           issuer: authenticator.api_id,
                                                           status: 'Requested')
      Rails.logger.info("CreateCredential (status 'Requested'): response from api: #{created_credential}")

      api_id = created_credential.fetch('id', nil)
      authentication.update(api_id: api_id) if api_id

      InviteAuthenticatorMailer.with(authenticator: authenticator,
                                     credential: credential,
                                     holder: holder)
        .invite
        .deliver_later
    end
  end
end
