class CredentialsForOthersController < ApplicationController
  def new
  end

  def create
    creator = Contact.find_or_create_by(email: current_user.email)
    participant_emails = params[:participants].split("\n")
    participants = participant_emails.map do |email|
      Contact.find_or_create_by(email: email)
    end
    skill = Skill.create(name: params[:name],
                         skill_type: params[:type],
                         description: params[:description])

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
  end
end
