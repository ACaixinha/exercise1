class ApplicationController < ActionController::API
  include Pundit::Authorization
  def current_user
    return nil if session.blank?
    @current_user ||= User.find(session[:user_id])
  end
end
