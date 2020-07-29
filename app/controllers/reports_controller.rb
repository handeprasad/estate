class ReportsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_case

  def show
    @report = @case.reports.find(params[:id])
    document = @report.documents.where(included: true).first
    document = @report.documents.first if document.blank?
    redirect_to document.file.url
  end

  def destroy
    @report = @case.reports.find(params[:id])

    if @report.may_cancel?
      @report.cancel!
      flash[:notice] = 'Order cancelled. Your account will not be charged.'
    else
      flash[:alert] = "Order #{@report.public_id} could not be cancelled."
    end

    redirect_to case_path(@case)
  end

  private

  def send_notifications
    ReportMailer.order_received_notification(@report).deliver_later
  end

  def set_case
    @case = current_company.cases.find(params[:case_id])
  end
end
