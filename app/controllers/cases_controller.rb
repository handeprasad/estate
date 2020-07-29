class CasesController < ApplicationController
  before_action :authenticate_user!

  before_action :set_authorised_users, only: [:case_types, :new, :create, :edit]

  def index
    @cases = current_company.cases.order("created_at desc") 
  end

  def new
    @case = Case.new(company: current_company) #if params.has_key? :case
  end

  def create
    @case = Case.new(case_params.merge(company: current_company))
    @matter = MatterType.find params[:case][:matter_type_id]
    @case.type = "Cases::#{@matter.matter_type}"

    if @case.save
      if params[:create_and_order].present?
        flash[:notice] = 'Case created. Choose the product to order.'
        redirect_to new_case_order_path @case
      else
        flash[:notice] = 'Case created. To place your order select \'order report\'.'
        redirect_to case_path @case
      end
    else
      @legal_capacity = @case.legal_capacity
      render :new
    end

  end

  def show
    @case = current_company.cases.find(params[:id])
    @document_categories = @case.document_categories.pluck(:name, :id)

    @notes = @case.audit_logs.where(auditable_type: 'Case', auditable_id: @case).order("updated_at desc")
    
    @notes = @notes.where(hide_note: false).order("updated_at desc")

  end

  def edit
    @case = current_company.cases.find(params[:id])
  end

  def update
    @case = current_company.cases.find(params[:id])

    raise 'Attempted to edit locked case' if @case.reports.any?

    if @case.update(case_params)
      flash[:notice] = 'Case updated.'
      redirect_to case_path @case
    else
      render :edit
    end
  end

  def destroy
    @case = current_company.cases.find(params[:id])

    if @case.deletable?
      @case.destroy
      flash[:notice] = 'Your case was deleted.'
    else
      flash[:alert] = 'Your case could not be deleted.'
    end

    redirect_to action: :index
  end

  def upload_documents
    @case = current_company.cases.find(params[:id])
    unless params["#{param_case_type}".to_sym].blank?
      document = @case.documents.new
      document.uploader = current_user
      document.document_category_id = params[:document_category_id]
      document.file = params["#{param_case_type}".to_sym][:file]
      document.save
      redirect_to case_path(@case, :tab_active =>'evidences'), notice: "Evidence has been uploaded."
    else
      redirect_to case_path(@case, :tab_active =>'evidences')

    end

  end
  
  def download_template
    if params[:tp] == 'DOC'
      sample_template = File.open(Rails.root.to_s + '/doc/Financial Profile Letter of Authority.docx')
      send_file sample_template, disposition: "attachment", filename: "Financial Profile Letter of Authority.docx"
    else
      sample_template = File.open(Rails.root.to_s + '/doc/Financial Asset Search (IDL) LOA.pdf')
      send_file sample_template, disposition: "attachment", filename: "Financial Asset Search (IDL) LOA.pdf"
    end
  end


  def download_evidence
    gid         = GlobalID.parse Base64.urlsafe_decode64(params[:id])
    object      = GlobalID::Locator.locate gid
    destination = object.public_send(gid.params[:attribute]).url

    redirect_to destination
  end

  private
  def case_params
    params.require(:case).permit(
      :customer_reference,
      :authorised_user_id,
      :legal_capacity,
      :matter_type_id,
      :title,
      :forename,
      :middle_name,
      :surname,
      :name_suffix,
      :date_of_birth,
      :date_of_applicability,
      :type,
      :firm_is,
      next_to_kin_attributes: [:id, :title, :firstname, :middle_name, :surname, :name_suffix, :source_id, :source_type],
      addresses_attributes: Address::PARAMS,
      names_attributes: Name::PARAMS
    ).tap do |cp|
      cp[:names_attributes]&.each { |a| a[1].merge! source: current_user }
      cp[:addresses_attributes]&.each { |a| a[1].merge! source: current_user }
      cp[:next_to_kin_attributes].merge!(owner: @case, source_type: "Relationship", source_id: (Relationship.find_by_name(params[:custom_source]).id rescue nil)) if cp[:next_to_kin_attributes].present?
    end
  end

  def case_type
    {
      'bereavement' => Cases::Bereavement,
      'Cases::Bereavement' => Cases::Bereavement,
      'mental_capacity' => Cases::MentalCapacity,
      'Cases::MentalCapacity' => Cases::MentalCapacity
    }.fetch(params.dig(:case, :type))
  end

  def param_case_type
    if @case.type == "Cases::Bereavement"
      return "cases_bereavement"
    else
      return "cases_mental_capacity"
    end
  end

  def set_authorised_users
    users = current_user.has_legal_authority ? [current_user] : current_company.users.with_legal_authority
    @authorised_users = users.map { |u| [u.name, u.id] }
  end
  
end
