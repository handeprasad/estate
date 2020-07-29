class Admin::CasesController < Admin::AdminController

	def index
		@cases = Case.joins("left join orders on orders.case_id = cases.id left join reports on reports.order_id = orders.id").where("orders.id is null").order("created_at desc")
	end

	def show
		@case = Case.find params[:id]
    
    	respond_to do |format|
      		format.js
    	end
	end

	def edit
		@case = Case.find params[:id]
    	respond_to do |format|
      		format.js
    	end
	end

  def upload_evidence
    @case = Case.find(params[:id])
    @report = Report.find params[:report_id]
    unless params[:report][:file].blank?
      document = @case.documents.new
      document.uploader = current_administrator
      document.document_category_id = params[:report][:document_category_id]
      document.file = params[:report][:file]
      document.save
    end
      respond_to do |format|
        format.js 
      end
  end

	def update
		@case = Case.find params[:id]
		if params[:field_type]  == "case_type"
			unless params["#{param_case_type}".to_sym][:matter_type_id].blank?
				matter = MatterType.find params["#{param_case_type}".to_sym][:matter_type_id]
				@case.matter_type_id = params["#{param_case_type}".to_sym][:matter_type_id]
				@case.type = "Cases::#{matter.matter_type}"
				@case.save(validate: false)
			end
		elsif params[:field_type]  == "legal_capacity"
			unless params[:legal_capacity_field].blank?
				value = params[:legal_capacity_field]
				firm_is = params[:legal_capacity_field].split("|").first
				lc_name = params[:legal_capacity_field].split("|").last
				if @case.bereavement?
					lc_key = MatterType.bereavement_legal_capacity_index(lc_name)
				else
					lc_key = MatterType.mental_capacity_legal_capacity_index(lc_name)
				end
				unless lc_key.blank?
					@case.legal_capacity = lc_key
					@case.firm_is = firm_is
					@case.save(validate: false)
				end
			end
		elsif params[:field_type]  == "next_to_kin"	
			@case.attributes = next_to_kin_params
			@case.save(validate: false)
    elsif params[:field_type] == "all"
      @case.update(edit_case_params)
      @report = Report.find params[:report_id]
		else
    		if @case.update(case_params)
		      flash[:notice] = 'Case updated.'
    		else
      			render :edit
    		end
		end
    	respond_to do |format|
      		format.js
    	end
	end

	private

  def case_params
    params.require(:case).permit(
      :customer_reference,
      :title,
      :forename,
      :middle_name,
      :surname,
      :name_suffix,
      :date_of_birth,
      :date_of_applicability,
      :subtype,
      :next_of_kin_first_name,
      :next_of_kin_middle_name,
      :next_of_kin_last_name,
      :ni_number,
      :next_of_kin_relationship,
      addresses_attributes: Address::PARAMS,
      names_attributes: Name::PARAMS
    ).tap do |cp|
      cp[:names_attributes]&.each { |a| a[1].merge! source: current_user }
      cp[:addresses_attributes]&.each { |a| a[1].merge! source: current_user }
    end
  end

  def edit_case_params
    params.require(param_case_type.to_sym).permit(:date_of_birth, :date_of_applicability, :ni_number)
  end

  def next_to_kin_params
    params.require(param_case_type.to_sym).permit(
      next_to_kin_attributes: [:id, :title, :firstname, :middle_name, :surname, :name_suffix, :source_id, :source_type, :custom_source],
    ).tap do |cp|
      cp[:next_to_kin_attributes].merge!(owner: @case, source_type: "Relationship", source_id: (Relationship.find_by_name(params[:custom_source]).id rescue nil)) if cp[:next_to_kin_attributes].present?
    end
  end

	def param_case_type
    	if @case.type == "Cases::Bereavement"
      		return "cases_bereavement"
    	else
      		return "cases_mental_capacity"
    	end
  	end

end
