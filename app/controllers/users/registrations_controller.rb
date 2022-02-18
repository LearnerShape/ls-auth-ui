# frozen_string_literal: true

require 'net/http'

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    Rails.logger.info "\n\nCreating user in ls-auth-ui\n"
    super
    create_user_in_api
  end

  def create_user_in_api
    Rails.logger.info "\n\nCalling ls-auth-api to create user in API, before state of user=\n#{current_user.inspect})\n"
    uri = URI('http://host.docker.internal:5000/api/v1/users/')
    res = Net::HTTP.start(uri.host, uri.port) do |http|
      req = Net::HTTP::Post.new(uri)
      req['Content-Type'] = 'application/json'
      req['X-API-Key'] = 'a'
      req['X-Auth-Token'] = 'b'
      req.body = {name: current_user.name, email: current_user.email}.to_json
      http.request(req)
    end

    created_user = JSON.parse(res.body)
    Rails.logger.info "\nResponse from API: #{created_user}\n"
    Rails.logger.info "\nUpdate ls-auth-ui user with api_id #{created_user['id']}:\n"
    current_user.update(api_id: created_user['id'])

    Rails.logger.info "\nAfter calling API, current state of user=\n#{current_user.inspect}\n"
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
