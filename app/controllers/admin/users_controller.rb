class Admin::UsersController < Admin::AdminController
  before_action :set_company

  def index
    @users = @company.users.order(Arel.sql('CONCAT("first_name", "surname")'))
  end

  def new
    @user = @company.users.build
  end

  def create
    @user = @company.users.build(user_params)
    @user.password = SecureRandom.hex(12)

    if @user.valid?
      User.invite! @user.attributes
      flash[:notice] = 'User invited.'
      redirect_to action: :index
    else
      render :new
    end
  end

  def edit
    @user = @company.users.find(params[:id])
  end

  def update
    @user = @company.users.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = 'User updated.'
      redirect_to action: :index
    else
      render :edit
    end
  end

  def reinvite
    @user = @company.users.find(params[:id])

    if @user.reinvitable?
      @user.invite!
      flash[:notice] = 'Invitation re-sent.'
      redirect_to action: :index
    else
      flash[:alert] = 'This invitation cannot be re-sent.'
      redirect_to [:admin, @user.company, :users]
    end
  end

  private
  def set_company
    @company = Company.find(params[:company_id])
  end

  def user_params
    params.require(:user).permit(:username, :title, :email, :has_legal_authority, :suspended, :first_name, :middlename, :surname, :phone, :introducer_id, :office_address, :job_title, :date_registered, :accrediting_body, :accreditation_number, :professional_accreditation_url, :annual_check_date).tap do |usr|
      usr.merge!(introducer_id: nil) if !usr[:introducer_id].present?
    end
  end
end
