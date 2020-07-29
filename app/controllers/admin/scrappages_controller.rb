class Admin::ScrappagesController < Admin::AdminController
  def create
    Report.find(params[:report_id]).scrap!
    redirect_to controller: :reports, action: :index
  end
end
