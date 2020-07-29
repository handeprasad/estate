class Admin::CurrentUsersController < Admin::AdminController
  def update
    sign_in :user, User.find(params[:user_id])
    redirect_to cases_path
  end

  def destroy
    sign_out :user
    redirect_to admin_root_path
  end
end
