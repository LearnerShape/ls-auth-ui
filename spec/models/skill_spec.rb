require 'rails_helper'

RSpec.describe Skill do
  describe "can_add_logo?" do
    it "third_party always can" do
      skill = Skill.create(name: "third party skill")
      Program.create(skill: skill)
      expect(skill.can_add_logo?).to be true
    end
    it "personal without external authentications can" do
      contact_applicant = Contact.create
      skill = Skill.create(name: "personal skill without external authentications")
      credential = skill.credentials.create(holder: contact_applicant)
      credential.authentications.create(authenticator: contact_applicant)

      expect(skill.can_add_logo?).to be true
    end
    it "personal with external authentications can't" do
      contact_applicant = Contact.create
      contact_authenticator = Contact.create
      skill = Skill.create(name: "personal skill with external authentications")
      credential = skill.credentials.create(holder: contact_applicant)
      credential.authentications.create(authenticator: contact_applicant)
      credential.authentications.create(authenticator: contact_authenticator)

      expect(skill.can_add_logo?).to be false
    end
  end
end
