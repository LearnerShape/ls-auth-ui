require 'rails_helper'

RSpec.describe User do
  describe "create_or_join_contact" do
    it "contact didn't already exist" do
      user = User.create(name: "Anna Example",
                         email: "anna@example.com",
                         password: "calufrax")
      expect(Contact.count).to eq(0)
      user.create_or_join_contact
      expect(Contact.count).to eq(1)
      contact = Contact.first
      expect(contact.user_id).to eq(user.id)
    end
    it "contact did already exist" do
      user = User.create(name: "Anna Example",
                         email: "anna@example.com",
                         password: "calufrax")
      contact = Contact.create(name: "Anna Example",
                               email: "anna@example.com")
      expect(Contact.count).to eq(1)
      user.create_or_join_contact
      expect(Contact.count).to eq(1)
      from_db_contact = Contact.first
      expect(from_db_contact.user_id).to eq(user.id)
    end
  end
end
