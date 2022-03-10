require "rails_helper"

RSpec.describe "My credentials", type: :request do
  before do
    sign_in User.create(email: "anna@example.com", password: "calufrax")
  end
  it "creates a credential" do
    post "/my_credentials", params: { name: 'name',
                                      type: 'GeneralCredential',
                                      description: 'description',
                                      authenticators: 'beth@example.com\nbodil@example.com'}
    expect(Contact.count).to eq(3)

    expect(Skill.count).to eq(1)
    skill = Skill.first
    expect(skill.name).to eq('name')
    expect(skill.skill_type).to eq('GeneralCredential')
    expect(skill.description).to eq('description')

    expect(Credential.count).to eq(1)
    credential = Credential.first
    holder = Contact.where(email: 'anna@example.com').first
    expect(credential.holder).to eq(holder)
    expect(credential.skill).to eq(skill)
    expect(credential.status).to eq('authenticated')
    expect(Authentication.count).to eq(3)

    holder_authentication = Authentication.where(authenticator: holder).first
    expect(holder_authentication.status).to eq('accepted')

    invited_authenticators = Contact.where(email: ['beth@example.com', 'bodil@example.com'])
    invited_authentications = Authentication.where(authenticator: invited_authenticators)
    expect(invited_authentications.map(&:status).uniq).to eq(['invited'])
  end
end
