require "rails_helper"

RSpec.describe NameAndEmail do
  describe "parse" do
    it "name <email>" do
      actual = NameAndEmail.parse("name <email>")
      expect(actual.name).to eq("name")
      expect(actual.email).to eq ("email")
    end
  end
  describe "invalid?" do
    it "empty is false (it's an optional field)" do
      expect(NameAndEmail.invalid?("")).to be false
    end
    it "blank line should resolve to empty" do
      expect(NameAndEmail.invalid?("\n")).to be false
    end
    it "one valid line is false" do
      expect(NameAndEmail.invalid?("name <email>")).to be false
    end
    it "one invalid line is true" do
      expect(NameAndEmail.invalid?("name <email")).to be true
    end
    it "one invalid and and valid line is true" do
      expect(NameAndEmail.invalid?("name <email\nname <email>")).to be true
    end
  end
end
