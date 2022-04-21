require "rails_helper"

RSpec.describe "Public views", type: :request do
  before do
    @claimant = Contact.create(email: "claimant@example.com")

    @skill1 = Skill.create(name: "skill1")
    @skill2 = Skill.create(name: "skill2")
    @skill3 = Skill.create(name: "skill3")

    @credential1 = Credential.create(holder: @claimant, skill: @skill1, status: "authenticated")
    @credential2 = Credential.create(holder: @claimant, skill: @skill2, status: "authenticated")
    @credential3 = Credential.create(holder: @claimant, skill: @skill3, status: "authenticated")

    Authentication.create(credential: @credential1, authenticator: @claimant, status: "accepted")
    Authentication.create(credential: @credential2, authenticator: @claimant, status: "accepted")
    Authentication.create(credential: @credential3, authenticator: @claimant, status: "accepted")

    @authenticator1 = Contact.create(email: "authenticator@example.com")

    Authentication.create(credential: @credential3, authenticator: @authenticator1, status: "accepted")
  end

  it "creates a public view" do
    user = User.create_with_contact(name: "Claimant Test",
                                    email: @claimant.email,
                                    password: "calufrax")
    sign_in user

    post "/public_views", params: { credentials_to_add: {
                                      @credential3.id => "1",
                                      @credential2.id => "",
                                      @credential1.id => "2"
                                    }
                                  }

    expect(PublicView.count).to eq(1)
    public_view = PublicView.first

    expect(public_view.credentials).to eq([@credential3.id, @credential1.id])
    expect(public_view.owner).to eq(@claimant)
    expect(public_view.uuid).not_to be_blank
  end

  it "can view a created public view without logging in" do
    public_view = PublicView.create(credentials: [@credential3.id, @credential1.id], owner: @claimant)
    response = get "/public_views/#{public_view.uuid}"
    expect(response).not_to redirect_to(new_user_session_path)
    expect(response).not_to be(404)
  end
  it "cannot view an inactive created public view" do
    public_view = PublicView.create(credentials: [@credential3.id, @credential1.id], owner: @claimant, status: "inactive")
    response = get "/public_views/#{public_view.uuid}"
    expect(response).to be(404)
  end
end
