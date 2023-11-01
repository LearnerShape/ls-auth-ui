require "rails_helper"

RSpec.describe "My credentials", type: :request do
  before do
    sign_in User.create_with_contact(name: "Anna Example",
                                     email: "anna@example.com",
                                     password: "calufrax")
  end

  # Oddly, the app uses '\r\n' as line break in the create case,
  # but '\n' as the line break in the add authenticators case.
  # Tests modified to reflect this pending further investigation
  context "create" do
    describe "unhappy path" do
      it "doesn't create a credential without name" do
        post "/my_credentials", params: { name: '',
                                          type: 'GeneralCredential',
                                          description: 'description',
                                          authenticators: "Beth Example <beth@example.com>\r\nBodil Example <bodil@example.com>" }
        expect(response).to render_template(:new)
        expect(Contact.count).to eq(1)
        expect(Skill.count).to eq(0)
      end
      it "doesn't create a credential with ill-formed authenticators field" do
        post "/my_credentials", params: { name: 'name',
                                          type: 'GeneralCredential',
                                          description: 'description',
                                          authenticators: "Beth Example <beth@example.com>\r\nBodil Example <bodil@example.com" }
        expect(response).to render_template(:new)
        expect(Contact.count).to eq(1)
        expect(Skill.count).to eq(0)
      end
    end
    describe "happy path" do
      it "creates a credential" do
        post "/my_credentials", params: { name: 'name',
                                          type: 'GeneralCredential',
                                          description: 'description',
                                          authenticators: "Beth Example <beth@example.com>\r\nBodil Example <bodil@example.com>" }
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
  end
  context "add authenticators" do
    before do
      post "/my_credentials", params: { name: 'name',
                                        type: 'GeneralCredential',
                                        description: 'description',
                                        authenticators: "Beth Example <beth@example.com>\r\nBodil Example <bodil@example.com>" }
      @credential = Credential.first
    end
    describe "unhappy path" do
      it "doesn't add authenticators with ill-formed field" do
        post "/my_credentials/#{@credential.id}/add_authenticators", params: { authenticators: "Iolanthe Ill-formed (no email here)"}
        expect(response).to render_template(:add_authenticators_form)
        expect(Contact.count).to eq(3)
      end
    end
    describe "happy path" do
      it "adds authenticators" do
        post "/my_credentials/#{@credential.id}/add_authenticators", params: { authenticators: "Wendy Well-formed <wendy@example.com>\nWanda Well-formed <wanda@example.com>"}
        expect(Contact.count).to eq(5)
        expect(Credential.count).to eq(1)
        invited_authenticators = Contact.where(email: %w[wendy@example.com wanda@example.com])
        invited_authentications = Authentication.where(authenticator: invited_authenticators)
        expect(invited_authentications.map(&:status).uniq).to eq(['invited'])
      end
    end
  end
end
