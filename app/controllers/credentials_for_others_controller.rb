class CredentialsForOthersController < CredentialsController
  def new
  end

  def create
    creator = current_user.contact
    participants = participants_from_params
    skill = Skill.create(name: params[:name],
                         skill_type: params[:type],
                         description: params[:description])
    created_skill = ::Commands::CreateSkill.do(user_id: creator.api_id,
                                               skill_name: skill.name,
                                               skill_type: skill.skill_type,
                                               skill_description: skill.description)
    Rails.logger.info("CreateSkill: response from api: #{created_skill}")

    api_id = created_skill.fetch('id', nil)
    skill.update(api_id: api_id) if api_id

    logo = Logo.create(creator_id: current_user.id)
    logo.image.attach(params[:image])

    skill.update(logo_id: logo.id)

    Program.create(creator: creator, skill: skill)

    credentials_from_participants(creator: creator,
                                  skill: skill,
                                  participants: participants)

    redirect_to action: :index
  end

  def index
    @creator = current_user.contact
    update_transaction_ids_by_creator(creator: @creator)
    @programs = Program.where(creator: @creator)
  end

  def add_participants_form
    creator = current_user.contact
    @program = Program.where(id: params[:id]).first
    return head(:forbidden) if @program.creator != creator
  end

  def add_participants
    creator = current_user.contact
    program = Program.where(id: params[:id]).first
    return head(:forbidden) if program.creator != creator

    skill = program.skill
    participants = participants_from_params

    credentials_from_participants(creator: creator,
                                  skill: skill,
                                  participants: participants)

    redirect_to action: :index
  end

  def add_logo_form
    creator = current_user.contact
    @program = Program.where(id: params[:id]).first
    return head(:forbidden) if @program.creator != creator
  end

  def add_logo
    creator = current_user.contact
    program = Program.where(id: params[:id]).first
    return head(:forbidden) if program.creator != creator

    logo = Logo.create(creator_id: current_user.id)
    logo.image.attach(params[:image])

    skill = program.skill
    skill.update(logo_id: logo.id)

    redirect_to action: :index
  end

  def revoke
    creator = current_user.contact
    credential = Credential.where(id: params[:id]).first
    return head(:forbidden) unless credential.authentications.map(&:authenticator_id).include?(creator.id)

    authentications = credential.authentications

    authentications.map(&:mark_revoked)
    credential.mark_revoked

    authentications.each do |authentication|
      response = ::Commands::UpdateCredential.revoke(id: authentication.api_id,
                                                     issuer_id: authentication.authenticator.api_id)
      Rails.logger.info("UpdateCredential.revoke: response from api: #{response}")

    end

    redirect_to action: :index
  end

  private

  def participants_from_params
    participant_params = params[:participants].split("\n")
    participant_params.map do |row|
      ne = NameAndEmail.parse(row)
      Contact.retrieve_or_build(name: ne.name, email: ne.email)
    end
  end

  def credentials_from_participants(creator:, skill:, participants:)
    credentials = participants.map do |participant|
      Credential.create(holder: participant, skill: skill)
    end

    authentications = credentials.map do |credential|
      authentication = Authentication.create(credential: credential,
                                             authenticator: creator)

      created_credential = ::Commands::CreateCredential.do(holder: credential.holder.api_id,
                                                           skill: skill.api_id,
                                                           issuer: creator.api_id,
                                                           status: 'Issued')
      Rails.logger.info("CreateCredential: response from api: #{created_credential}")

      api_id = created_credential.fetch('id', nil)
      authentication.update(api_id: api_id) if api_id

      InviteParticipantMailer.with(authenticator: creator,
                                   credential: credential,
                                   holder: credential.holder)
        .invite
        .deliver_later

      authentication
    end

    authentications.map(&:mark_accepted)
    credentials.map(&:mark_authenticated)
  end
end
