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

    Program.create(creator: creator, skill: skill)

    credentials = participants.map do |participant|
      Credential.create(holder: participant, skill: skill)
    end

    authentications = credentials.map do |credential|
      Authentication.create(credential: credential,
                            authenticator: creator)
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
