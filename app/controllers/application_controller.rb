class ApplicationController < ActionController::Base
  include Pundit::Authorization

  before_action :set_current_user
  before_action :authenticate!

  private

  def authenticate!
    return if Current.user.present?

    redirect_to new_sign_up_path
  end

  def sign_in(user)
    session[:user_id] = user.id
    session[:past_user] = nil
  end

  def sign_out
    session[:past_user] = { name: Current.user.name, token: Current.user.token } if Current.user.present?
    session[:user_id] = nil
  end

  def redirect_if_signed_in
    redirect_to root_path if Current.user.present?
  end

  def set_current_user
    return nil if session[:user_id].nil?

    Current.user = User.find_by(id: session[:user_id])
  end

  def pundit_user
    Current.user
  end

  def store_after_sign_in_redirect_to_url
    return nil if session[:user_id].present?

    session[:after_sign_in_redirect_to_url] = request.url
  end

  def use_after_sign_in_redirect_to_url
    return if session[:after_sign_in_redirect_to_url].nil?

    redirect_to session.delete(:after_sign_in_redirect_to_url)
  end
end
