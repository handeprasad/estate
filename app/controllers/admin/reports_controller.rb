class Admin::ReportsController < Admin::AdminController
  def index
    @reports = filtered_reports
  end

  def show
    @report = Report.find(params[:id])

    kase = @report.case 

    @user_notes  = AuditLog.where(auditable_type: 'Case', auditable_id: kase, user_type: 'User').count

    if @report.any_pending_search?
      @report.disable_compile = true
      @report.save
    end
    
    respond_to do |format|
      format.html
        if params[:format] == 'html'
          # an Ajax call from /reports passes a format param
          render partial: 'report', locals: { report: @report }
        end
        # whereas a straight /reports/7 will render show.html.erb
      format.xml
      format.pdf {         
        document = @report.documents.where(included: true).first
        document = @report.documents.first if document.blank?
        redirect_to document.file.url 
      }
    end
  end

  def update
    @report = Report.find(params[:id])
    
    @report.update! report_params

    respond_to do |format|
      format.js
    end
  end

  def upload_pdf
    @report = Report.find(params[:id])

    unless params[:report][:file].blank?
      document = @report.documents.new
      document.uploader = current_administrator
      document.description = params[:report][:description]
      document.file = params[:report][:file]
      document.save
    end
    
    respond_to do |format|
      format.js
    end
  end

  def recompile
    Report.find(params[:id]).recompile!
    redirect_to controller: :reports, action: :index
  end

  def update_search_result
    @report = Report.find(params[:id])
    if @report.any_pending_search?
      @report.disable_compile = true
    else
      @report.disable_compile = false
    end
    @report.save
  end

  def update_status
    @report = Report.find(params[:id])
    @report.change_status(params[:status])
  end

  private
  def report_params
    params.require(:report).permit(:file)
  end

  def filter_params
    return params.require(:filter).permit( :delivered, :scrapped, :cancelled, :requested, :processing, :processed, :information_required) if params.has_key? :filter
    params[:filter] ||= { delivered: '0', scrapped: '0', cancelled: '0', requested: '1', processing: '0', processed: '0', information_required: 0 }
  end

  def filtered_reports
    scope_chain = Report
    scopes      = filter_params.select { |k,v| v == '1' }.keys.map(&:to_sym)

    return [] if scopes.none?

    scopes.each.with_index do |scope, i|
      scope_chain = (i == 0) ? scope_chain.send(scope) : scope_chain.or(Report.send(scope))
    end

    preload = { order: [case: :names] }
    scope_chain.joins(preload).includes(preload).order('orders.created_at desc')
  end

end
