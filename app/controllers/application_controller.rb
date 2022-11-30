class ApplicationController < ActionController::Base
  before_action :set_current_user
  before_action :authenticate!

  private

  def authenticate!
    return if Current.user.present?

    redirect_to new_sign_up_path
  end

  def sign_in(user)
    session[:user_token] = user.token
  end

  def redirect_if_signed_in
    redirect_to root_path if Current.user.present?
  end

  def set_current_user
    Current.user = session[:user_token].present? && User.find_by(token: session[:user_token])
  end
end
