class Admin::AddressesController < Admin::AdminController
  def create
    report = Report.find(params[:report_id])
    @address = report.case.addresses.new(address_params)

    if @address.save
      head :no_content
    else
      render partial: 'application/form_errors', locals: { object: @address }, status: :bad_request
    end
  end

  private

  def address_params
    params.require(:address).permit(Address::PARAMS).tap do |ap|
      ap.merge! source: current_administrator
    end
  end
end
