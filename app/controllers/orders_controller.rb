class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_authorised_users, only: [:new, :create]
  before_action :set_case

  def new
    @order = @case.orders.new(user: current_user)

  end

  def create
    @order = @case.orders.new
    @order.assign_attributes(order_params)

    if @order.has_section27_notice_localnewspaper_and_will_register_combined?
      report = @order.reports.select { |c| c.product_type == "Products::WillRegisterCombined" }.pluck(:will_legal_notice_postcode_1, :will_legal_notice_postcode_2, :will_legal_notice_postcode_2).compact
      @case.section_27_legal_notice_postcode_1 = report[0][0]
      @case.section_27_legal_notice_postcode_2 = report[0][1]
      @case.section_27_legal_notice_postcode_3 = report[0][2]
    end

    if @order.reports.none?
      flash[:notice] = 'Please select at least one report to order'
      render :new and return
    else
      flash[:notice] = nil
    end
    
    if order_params[:confirm] && @case.save_evidences(params[:document], current_user.id) && @order.save      
      ReportMailer.order_received_notification(@order).deliver_now
      flash[:notice] = 'Your order was placed.'
      redirect_to case_path(@case)
    else
      render :create
    end

  end

  private

  def order_params
    params.require(:order).permit(
      :confirm,
      :terms_and_conditions,
      bundles: [],
      products: [],
      case_attributes: [
        :authorised_user_id,
        :document_sharing_consent,
        :home_telephone_number,
        :executor_address,
        :executor_company,
        :executor_first_name,
        :executor_last_name,
        :executor_middle_name,
        :gazette_edition,
        :legal_capacity,
        :letter_to_financial_institutions,
        :letter_to_financial_institutions_idl,
        :letter_to_financial_institutions_cache,
        :maiden_name,
        :mobile_telephone_number,
        :ni_number,
        :section_27_claims_date,
        :section_27_earliest_publication_date,
        :section_27_exists,
        :section_27_published_at,
        :section_27_expires_at,
        :section_27_legal_notice_postcode_1,
        :section_27_legal_notice_postcode_2,
        :section_27_legal_notice_postcode_3,
        :section_27_notice_ref,
        :terms_and_conditions,
        :will_cert_exists,
        :will_registration_town,
        driving_licence_number_segments: [],
        passport_number_segments: [],
        will_register_search_cert_number_segments: [],
        addresses_attributes: Address::PARAMS,
        names_attributes: Name::PARAMS,
        previous_employers_attributes: [:id, :occupation, :company_name, address_attributes: Address::PARAMS],
        proofs_attributes: [:id, :document, :document_cache, :kind, :_destroy]
      ],
      reports_attributes: [
        :product_type,
        :parameter,
        :protection_policy,
        :will_legal_notice_postcode_1,
        :will_legal_notice_postcode_2,
        :will_legal_notice_postcode_3
      ]
    ).tap do |op|
      op[:user] = current_user
      op.dig(:case_attributes, :addresses_attributes)&.each { |a| a[1].merge! source: current_user }
      op.dig(:case_attributes, :names_attributes)&.each { |a| a[1].merge! source: current_user }
      op.dig(:case_attributes, :previous_employers_attributes)&.each do |a|
        a[1].merge! source: current_user
        a[1][:address_attributes]&.merge! source: current_user
      end
      if op.dig(:case_attributes, :driving_licence_number_segments)
        op[:case_attributes][:driving_licence_number] = op[:case_attributes][:driving_licence_number_segments].join
      end
      if op.dig(:case_attributes, :passport_number_segments)
        op[:case_attributes][:passport_number] = op[:case_attributes][:passport_number_segments].join
      end
      if op.dig(:case_attributes, :will_register_search_cert_number_segments)
        op[:case_attributes][:will_register_search_cert_number] = op[:case_attributes][:will_register_search_cert_number_segments].join("-")
      end
    end
  end

  def set_authorised_users
    users = current_user.has_legal_authority ? [current_user] : current_company.users.with_legal_authority
    @authorised_users = users.map { |u| [u.name, u.id] }
  end

  def set_case
    @case = current_company.cases.find(params[:case_id])
  end
end
