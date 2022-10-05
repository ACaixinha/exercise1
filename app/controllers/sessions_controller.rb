class SessionsController < ApplicationController
  def create
    @session_form = SessionForm.new(session_params)
    if @session_form.valid?
      user = User.find_by(username: @session_form.username)
      if user.blank?
        render json: user, status: :unauthorized
      elsif user.authenticate(@session_form.password)
        session[:user_id] = user.id
        session[:username] = user.username
        render json: {}, status: :ok
      else
        render json: {}, status: :unauthorized
      end
    else
      render json: {}, status: :unprocessable_entity
    end
  end

  def destroy
    reset_session
    render json: { status: :ok }
  end

  private

  # Only allow a list of trusted parameters through.
  def session_params
    params.require(:session).permit(:username, :password)
  end
end
