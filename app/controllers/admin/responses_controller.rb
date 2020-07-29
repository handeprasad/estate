class Admin::ResponsesController < Admin::AdminController
  def index
    @reports = filtered_reports
  end
  
  def show
    if params[:response_id]
      @report = Report.find(params[:response_id])
      @legal_notice = LegalNotice.where(
        report: @report,
        financial_institution_id: params[:id]
      ).first
      if @legal_notice
        if @legal_notice.notes.blank?
          @legal_notice.notes = 'Review letter'
        end
      end
      render partial: 'admin/responses/legal_notice', locals: { legal_notice: @legal_notice }
    else
      @report = Report.find(params[:id])
      render partial: 'admin/responses/report', locals: { report: @report }
    end
  end

  def filter_params
    return params.require(:filter).permit(:cancelled, :delivered, :information_required, :processed, :processing, :requested, :scrapped) if params.has_key? :filter

    params[:filter] ||= { cancelled: '0', delivered: '0', information_required: 0, processed: '0', processing: '1', requested: '1', scrapped: '0' }
  end

  def filtered_reports
    root = Report.ens
    scope_chain = root
    scopes = filter_params.select { |_k, v| v == '1' }.keys.map(&:to_sym)
    return [] if scopes.none?

    scopes.each.with_index do |scope, i|
      scope_chain = (i == 0) ? scope_chain.send(scope) : scope_chain.or(root.send(scope))
    end
    preload = { order: [case: :names] }
    scope_chain.joins(preload).includes(preload).order('orders.created_at desc')
  end
end
