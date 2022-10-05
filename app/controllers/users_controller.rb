class UsersController < ApplicationController
  before_action :set_user, only: %i[show update destroy deposit]

  # GET /users
  def index
    @users = policy_scope(User)

    render json: @users.to_json(only: %i[username role id])
  end

  # GET /users/1
  def show
    authorize @user
    render json: @user
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    authorize @user
    if @user.update(params.require(:user).permit(:deposit))
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    authorize @user
    @user.destroy
  end

  # POST /users/:id/deposit
  def deposit
    authorize @user
    form = DepositForm.new(@user, params[:deposit])
    if form.save
      render json: form.user, status: :ok
    else
      render json: form.errors, status: :unprocessable_entity
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:username, :password, :role, :deposit)
  end
end
