require "rails_helper"

RSpec.describe "Credentials for others", type: :request do
  before do
    sign_in User.create_with_contact(name: "Cristina Tutor",
                                     email: "cristina.tutor@example.com",
                                     password: "calufrax")
  end

  context "create" do
    describe "unhappy path" do
      it "doesn't create a credential without name" do
        post "/credentials_for_others", params: { name: '',
                                                  type: 'EducationCredential',
                                                  description: 'description',
                                                  participants: "Beth Student <beth.student@example.com>\nBodil Student <bodil.student@example.com>" }
        expect(response).to render_template(:new)
        expect(Contact.count).to eq(1)
        expect(Skill.count).to eq(0)
      end
      it "doesn't create a credential with ill-formed participants field" do
        post "/credentials_for_others", params: { name: 'name',
                                                  type: 'EducationCredential',
                                                  description: 'description',
                                                  participants: "Beth Student <beth.student@example.com>\nBodil Student <bodil.student@example.com" }
        expect(response).to render_template(:new)
        expect(Contact.count).to eq(1)
        expect(Skill.count).to eq(0)
      end
    end
    describe "happy path" do
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
  end
  context "add participants" do
    before do
      post "/credentials_for_others", params: { name: 'name',
                                                type: 'EducationCredential',
                                                description: 'description',
                                                participants: "Beth Student <beth.student@example.com>\nBodil Student <bodil.student@example.com>" }
      @program = Program.first
    end
    describe "unhappy path" do
      it "doesn't add participants with ill-formed field" do
        post "/credentials_for_others/#{@program.id}/add_participants", params: { participants: "Iolanthe Ill-formed (no email here)"}
        expect(response).to render_template(:add_participants_form)
        expect(Contact.count).to eq(3)
      end
    end
    describe "happy path" do
      it "adds participants" do
        post "/credentials_for_others/#{@program.id}/add_participants", params: { participants: "Wendy Well-formed <wendy@example.com>"}
        expect(Contact.count).to eq(4)
        expect(Credential.count).to eq(3)
        participants = Contact.where(email: ['beth.student@example.com', 'bodil.student@example.com', 'wendy@example.com'])
        credentials = Credential.all
        skill = Skill.first
        expect(credentials.map(&:holder)).to match_array(participants)
        expect(credentials.map(&:skill).uniq).to eq([skill])
        expect(credentials.map(&:status).uniq).to eq(['authenticated'])

      end
    end
  end
end
