require "rails_helper"

RSpec.describe "Credentials for others", type: :request do
  before do
    sign_in User.create_with_contact(name: "Cristina Tutor",
                                     email: "cristina.tutor@example.com",
                                     password: "calufrax")
  end

  it "creates a credential per participant" do
    post "/credentials_for_others", params: { name: 'name',
                                              type: 'EducationCredential',
                                              description: 'description',
                                              participants: "Beth Student <beth.student@example.com>\nBodil Student <bodil.student@example.com>" }

    expect(Contact.count).to eq(3)
    expect(Skill.count).to eq(1)

    skill = Skill.first
    expect(skill.name).to eq('name')
    expect(skill.skill_type).to eq('EducationCredential')
    expect(skill.description).to eq('description')

    expect(Credential.count).to eq(2)
    participants = Contact.where(email: ['beth.student@example.com', 'bodil.student@example.com'])
    credentials = Credential.all
    expect(credentials.map(&:holder)).to match_array(participants)
    expect(credentials.map(&:skill).uniq).to eq([skill])
    expect(credentials.map(&:status).uniq).to eq(['authenticated'])

    expect(Authentication.count).to eq(2)
    authentications = Authentication.all
    tutor = Contact.where(email: 'cristina.tutor@example.com').first
    expect(authentications.map(&:credential)).to match_array(credentials)
    expect(authentications.map(&:authenticator).uniq).to eq([tutor])
    expect(authentications.map(&:status).uniq).to eq(['accepted'])

    expect(Program.count).to eq(1)
    program = Program.first
    expect(program.creator).to eq(tutor)
    expect(program.skill).to eq(skill)
    expect(program.credentials.map(&:holder)).to match_array(participants)
  end
end
