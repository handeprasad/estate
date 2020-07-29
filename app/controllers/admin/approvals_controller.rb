class Admin::ApprovalsController < Admin::AdminController
  def create
    report = Report.find(params[:report_id])
    report.approve!
    ReportMailer.approval_notification(report).deliver_later

    redirect_to controller: :reports, action: :index
  end
end
