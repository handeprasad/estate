class Admin::EnsReportsController < Admin::AdminController
  def show
    @report = Report.find(params[:report_id])
    pdf = @report.ens_result
    send_data pdf.render, type: 'application/pdf', disposition: 'inline', filename: pdf.filename
  end
end
