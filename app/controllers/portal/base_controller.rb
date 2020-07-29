class Portal::BaseController < ActionController::Base
  before_action :authenticate_responder!
  layout 'application'

  private

  def after_sign_in_path_for(resource)
    portal_legal_notices_path
  end

  def authenticate_responder!
    super
    redirect_to suspension_path and return if current_responder.suspended?
  end

  def current_financial_institiution
    current_responder.financial_institution
  end
end
