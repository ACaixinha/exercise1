class ApplicationController < ActionController::API
  include Pundit::Authorization
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def current_user
    return nil if session.blank?

    @current_user ||= User.find(session[:user_id])
  end

  private
  def user_not_authorized(exception)
    render json: {}, status: :forbidden
  end
end
