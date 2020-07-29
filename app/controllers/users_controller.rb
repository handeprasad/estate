class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def update
    ensure_new_password_is_present

    if @user.update_with_password(user_params)
      bypass_sign_in(@user)
      flash[:notice] = 'Your password was changed.'
      redirect_to action: :edit
    else
      render :edit
    end
  end

  private
  def ensure_new_password_is_present
    return unless user_params[:password].blank? && @user.valid_password?(user_params[:current_password])
    @user.errors.add :password, 'You must enter a new password'
  end

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:current_password, :password, :password_confirmation, :title, :surname, :middlename, :phone)
  end
end
