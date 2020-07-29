class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_params, if: :devise_controller?

  private

  def after_accept_path_for(resource)
    return portal_legal_notices_path if resource.is_a? Responder
    super
  end

  def after_sign_in_path_for(resource)
    return admin_reports_path if resource.is_a? Administrator
    super
  end

  def after_sign_out_path_for(scope)
    return portal_legal_notices_path if scope == :responder
    super
  end

  def authenticate_user!
    super
    redirect_to suspension_path and return if current_user.suspended?
  end

  def configure_permitted_params
    devise_parameter_sanitizer.permit :account_update, keys: [:username, :email, :password, :password_confirmation, :remember_me]
    devise_parameter_sanitizer.permit :accept_invitation, keys: [:username, :password, :password_confirmation]
  end

  def current_company
    current_user.company
  end
end
