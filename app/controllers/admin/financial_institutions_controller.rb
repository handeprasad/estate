class Admin::FinancialInstitutionsController < Admin::AdminController
  def index
    @financial_institutions = FinancialInstitution
      .all
      .includes(:financial_institution_contact_methods)
      .in_name_order
  end 

  def new
    @financial_institution = FinancialInstitution.new
  end

  def create
    @financial_institution = FinancialInstitution.new(safe_params)

    if @financial_institution.save
      flash[:notice] = 'Financial Institution created.'
      redirect_to action: :index
    else
      render :new
    end
  end

  def edit
    @financial_institution = FinancialInstitution.find(params[:id])
  end

  def update
    @financial_institution = FinancialInstitution.find(params[:id])
    if @financial_institution.update(safe_params)
      flash[:notice] = 'Financial Institution updated.'
      redirect_to action: :index
    else
      render :edit
    end
  end

  def import
    require 'csv'
    file = params[:file]
    by_post = ContactMethod.find_by_name('docmail')
    by_email = ContactMethod.find_by_name('microsoft_graph')
    CSV.foreach(file.path, headers: true) {|row|
      name = row[0]
      if name
        fi = FinancialInstitution.find_or_create_by(name: name)
        case_type = file.original_filename.include?('Bereavement') ? 'Cases::Bereavement' : 'Cases::MentalCapacity'
        cm = row['Contact Method'] == 'Post' ? by_post : by_email
        ficm = FinancialInstitutionContactMethod.where(
          financial_institution: fi,
          contact_method: cm,
          case_type: case_type
        )
        if ficm.empty?
          ficm = FinancialInstitutionContactMethod.create!(
            financial_institution: fi,
            contact_method: cm,
            case_type: case_type,
            contact_name: row['Contact Name'],
            postal_address_1: row['Postal Address 1'],
            postal_address_2: row['Postal Address 2'],
            postal_town: row['Postal Town'],
            postcode: row['Postcode'],
            telephone: row['Telephone'],
            fax: row['Fax'],
            email: row['Email']
          ) 
          ficm.go_live!
        else
           ficm.update(
            financial_institution: fi,
            contact_method: cm,
            case_type: case_type,
            contact_name: row['Contact Name'],
            postal_address_1: row['Postal Address 1'],
            postal_address_2: row['Postal Address 2'],
            postal_town: row['Postal Town'],
            postcode: row['Postcode'],
            telephone: row['Telephone'],
            fax: row['Fax'],
            email: row['Email']
            )
        end
      end
    }
    redirect_to action: :index
  end

  def autocomplete
    limit = params[:limit] || 5
    @financial_institutions = FinancialInstitution.select(:id, :name).name_is(params[:contains] || params[:starts_with]).limit(limit)
    @financial_institutions += FinancialInstitution.select(:id, :name).name_starts_with(params[:contains] || params[:starts_with]).alphabetically.limit(limit)
    @financial_institutions += FinancialInstitution.select(:id, :name).name_contains(params[:contains]).alphabetically.limit(limit) if params[:contains]
    @financial_institutions.uniq!
    render json: @financial_institutions.as_json(only: %i[id name])
  end

  private
  def safe_params
    params.require(:financial_institution).permit(
      :contact_name,
      :email,
      :fax,
      :name,
      :notes,
      :postal_address_1,
      :postal_address_2,
      :postal_town,
      :postcode,
      :priority,
      :aasm_state,
      :telephone,
      :version,
      :website,
    )
  end
end
