class Admin::CompaniesController < Admin::AdminController
  def index
    @companies = Company.all.order(:name)
  end

  def new
    @company = Company.new
  end

  def create
    @company = Company.new(company_params)

    if @company.save
      flash[:notice] = 'Company created.'
      redirect_to action: :index
    else
      render :new
    end
  end

  def edit
    @company = Company.find(params[:id])
  end

  def update
    @company = Company.find(params[:id])

    if @company.update(company_params)
      flash[:notice] = 'Company updated.'
      redirect_to action: :index
    else
      render :edit
    end
  end

  private
  def company_params
    params.require(:company).permit(:name, :address, :registration_number, :regulatory_authority, :regulatory_authority_id, :ico_number, :website, :telephone, :firm_accreditation_check, :date_registered)
  end
end
