require "rails_helper"

RSpec.describe NameAndEmail do
  describe "parse" do
    it "name <email>" do
      actual = NameAndEmail.parse("name <email>")
      expect(actual.name).to eq("name")
      expect(actual.email).to eq ("email")
    end
  end
end
