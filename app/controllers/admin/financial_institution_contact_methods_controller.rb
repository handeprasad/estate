class Admin::FinancialInstitutionContactMethodsController < Admin::AdminController
  before_action :find

  ##  /admin/financial_institutions/:financial_institution_id/contact_methods/* routes

  def index
    @financial_institution_contact_methods = @financial_institution.financial_institution_contact_methods.order(:id)
  end

  def new
    @financial_institution = FinancialInstitution.find params[:financial_institution_id]
    @financial_institution_contact_method = FinancialInstitutionContactMethod.new(financial_institution: @financial_institution)
    @contact_methods = ContactMethod.all
  end

  def create
    @financial_institution_contact_method = FinancialInstitutionContactMethod.new(safe_params)
    if @financial_institution_contact_method.save
      flash[:notice] = 'Financial Institution Contact Method created.'
      redirect_to edit_admin_financial_institution_path(@financial_institution_contact_method.financial_institution)
    else
      render :new
    end
  end

  ##  /admin/financial_institution_contact_methods/:id/* routes

  def edit
    @contact_methods = ContactMethod.all
  end

  def update
    if @financial_institution_contact_method.update(safe_params)
      flash[:notice] = 'Financial Institution Contact Method updated.'
      redirect_to admin_financial_institution_contact_methods_path(@financial_institution_contact_method.financial_institution)
    else
      render :edit
    end
  end

  ##  method names match aasm actions

  FinancialInstitutionContactMethod.aasm.events.each {|event|
    define_method(event.name) do
      @financial_institution_contact_method.send("#{event.name}!")
      respond_to do |f|
        f.html { redirect_back(fallback_location: root_path) }
        f.js
      end
    end
  }

  private
  def safe_params
    params.require(:financial_institution_contact_method).permit(
      :contact_method_id,
      :contact_name,
      :email,
      :fax,
      :financial_institution_id,
      :postal_address_1,
      :postal_address_2,
      :postal_town,
      :postcode,
      :case_type,
      :telephone,
    )
  end

  def find
    @financial_institution = params[:financial_institution_id] ? FinancialInstitution.find(params[:financial_institution_id]) : nil
    @financial_institution_contact_method = params[:id] ? FinancialInstitutionContactMethod.find(params[:id]) : nil
    @case_types = [Cases::Bereavement, Cases::MentalCapacity]
  end
end
