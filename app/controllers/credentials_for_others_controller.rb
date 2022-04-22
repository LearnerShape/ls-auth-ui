class CredentialsForOthersController < ApplicationController
  def new
  end

  def create
    creator = current_user.contact
    participant_params = params[:participants].split("\n")
    participants = participant_params.map do |row|
      ne = NameAndEmail.parse(row)
      Contact.retrieve_or_build(name: ne.name, email: ne.email)
    end
    skill = Skill.create(name: params[:name],
                         skill_type: params[:type],
                         description: params[:description])
    created_skill = ::Commands::CreateSkill.do(user_id: creator.api_id,
                                               skill_name: skill.name,
                                               skill_type: skill.skill_type,
                                               skill_description: skill.description)
    api_id = created_skill.fetch('id', nil)
    skill.update(api_id: api_id) if api_id

    Program.create(creator: creator, skill: skill)

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
      api_id = created_credential.fetch('id', nil)
      authentication.update(api_id: api_id) if api_id
      authentication
    end

    authentications.map(&:mark_accepted)
    credentials.map(&:mark_authenticated)

    redirect_to action: :index
  end

  def index
    creator = current_user.contact
    @programs = Program.where(creator: creator)
  end
end
