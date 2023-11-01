require "rails_helper"

RSpec.describe NameAndEmail do
  describe "retrieve_or_build_contacts" do
    it "one contact already exists: don't create it again" do
      Contact.create(name: "name1", email: "email1")
      described_class.retrieve_or_build_contacts("name1 <email1>\nname2 <email2>")
      expect(Contact.count).to eq(2)
      expect(Contact.all.map(&:name)).to match_array(%w[name1 name2])
    end
    it "no contacts already exist: create both" do
      described_class.retrieve_or_build_contacts("name1 <email1>\nname2 <email2>")
      expect(Contact.count).to eq(2)
      expect(Contact.all.map(&:name)).to match_array(%w[name1 name2])
    end
  end

  describe "split" do
    it "handles lines divided by '\\n' (as in add authenticators / participants)" do
      expect(described_class.split("name1 <email1>\nname2 <email2>")).to match_array(
                                                                        ["name1 <email1>",
                                                                         "name2 <email2>"])
    end
    it "handles lines divided by '\\r\\n (as in create credential)" do
      expect(described_class.split("name1 <email1>\r\nname2 <email2>")).to match_array(
                                                                        ["name1 <email1>",
                                                                         "name2 <email2>"])
    end
  end

  describe "parse" do
    it "name <email>" do
      actual = described_class.parse("name <email>")
      expect(actual.name).to eq("name")
      expect(actual.email).to eq ("email")
    end
  end

  describe "invalid?" do
    it "empty is false (it's an optional field)" do
      expect(described_class.invalid?("")).to be false
    end
    it "blank line should resolve to empty" do
      expect(described_class.invalid?("\n")).to be false
    end
    it "one valid line is false" do
      expect(described_class.invalid?("name <email>")).to be false
    end
    it "one invalid line is true" do
      expect(described_class.invalid?("name <email")).to be true
    end
    it "one invalid and and valid line is true" do
      expect(described_class.invalid?("name <email\nname <email>")).to be true
    end
  end
end
