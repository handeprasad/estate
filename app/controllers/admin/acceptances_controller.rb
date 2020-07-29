class Admin::AcceptancesController < Admin::AdminController
  def create
    Report.find(params[:report_id]).accept!
    redirect_to controller: :reports, action: :index
  end
end
