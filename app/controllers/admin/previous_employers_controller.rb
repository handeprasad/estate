class Admin::PreviousEmployersController < Admin::AdminController
  def create
    report = Report.find(params[:report_id])
    @previous_employer = report.case.previous_employers.new(previous_employer_params)

    if @previous_employer.save
      head :no_content
    else
      render partial: 'application/form_errors', locals: { object: @previous_employer }, status: :bad_request
    end
  end

  private

  def previous_employer_params
    params.require(:previous_employer).permit(:id, :occupation, :company_name, address_attributes: Address::PARAMS).tap do |pep|
      pep.merge! source: current_administrator
      pep[:address_attributes]&.merge! source: current_administrator
    end
  end
end
