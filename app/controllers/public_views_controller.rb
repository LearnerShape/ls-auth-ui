class PublicViewsController < ApplicationController
  def new
    holder = Contact.find_or_create_by(email: current_user.email)
    @my_credentials = Credential.where(holder: holder).is_authenticated
  end

  def create
    holder = Contact.find_or_create_by(email: current_user.email)
    credentials_to_add = Hash[params.permit(credentials_to_add: {})[:credentials_to_add]]
    PublicView.create(credentials: build_credentials_list(credentials_to_add), owner: holder)
    redirect_to action: :index
  end

  def index
    holder = Contact.find_or_create_by(email: current_user.email)
    @public_views = PublicView.where(owner: holder)
  end


  skip_before_action :authenticate_user!, only: [:show]

  def show
    @public_view = PublicView.where(uuid: params[:id]).is_active.first
    render status: 404 if @public_view.blank?
    @credentials = @public_view.try(:credentials_for_display)
  end

  def build_credentials_list(credentials)
    Hash[credentials.map { |k, v| [k.to_i, v.to_i] }].select { |_, v| v.positive? }.sort_by { |_, v| v }.to_h.keys
  end
end
