class Admin::AuditLogsController < Admin::AdminController

  def create
  	@report = Report.find(params[:case_report_id])

    user = current_administrator

    @case_note = @report.case.audit_logs.new(case_note_params.merge(user: user))

    if @case_note.save
    		@case_notes = @report.case.audit_logs.order("updated_at desc")
        kase = @report.case 
    		@user_notes  = AuditLog.where(auditable_type: 'Case', auditable_id: kase, user_type: 'User').count

       respond_to do |format|
        format.js
    	end
    else
      render partial: 'application/form_errors', locals: { object: @case_note }, status: :bad_request
    end
  end

  def edit
  	@report = Report.find(params[:report_id])
  	@case_note = @report.case.audit_logs.find(params[:id]) 
  	
    kase = @report.case 

    @user_notes  = AuditLog.where(auditable_type: 'Case', auditable_id: kase, user_type: 'User').count
  end

  def update
  	@report = Report.find(params[:report_id])
  	@case_note = @report.case.audit_logs.find(params[:id])

    if administrator_signed_in? && @case_note.user_type == 'Administrator'
      user = current_administrator
    else
      user = @case_note.user
    end

    @case_note.assign_attributes(case_note_params.merge(user: user))

    if @case_note.save
    	kase = @report.case 
    	@user_notes  = AuditLog.where(auditable_type: 'Case', auditable_id: kase, user_type: 'User').count
    	@case_notes = @report.case.audit_logs.order("updated_at desc")
      respond_to do |format|
        format.js # show.js.erb
    	end
    else
      render partial: 'application/form_errors', locals: { object: @case_note }, status: :bad_request
    end
  end

  def show_or_hide
    logger.info " = =  = = = = = =  = = = = =  = = = = = =  = = =  = = ="
    logger.info params.inspect
    hide = params["checkbox_audit_log_#{params[:note_id]}"]
    @report = Report.find(params[:report_id])
    @case_note = @report.case.audit_logs.find(params[:note_id]) 
    if hide.present?
      @case_note.hide_note = true
    else
      @case_note.hide_note = false
    end
    @case_note.save

    @notes = AuditLog.where(auditable_type: 'Case', auditable_id: @report.case).order("updated_at desc")
    if !current_administrator
      @notes = @notes.where(hide_note: false).order("updated_at desc")
    end
    @user_notes = @notes.where(user_type: 'User').count
    @admin = current_administrator ? true : false

  end

  private

  def case_note_params
    params.require(:audit_log).permit(:note)
  end

  def set_case
    @case = current_company.cases.find(params[:case_id])
  end

  def can_edit_note
    @case = current_company.cases.find(params[:case_id])
    @case_note = AuditLog.find(params[:id])
    if current_administrator || (@case_note.user_id == current_user.id && @case_note.user_type == 'User')
      true
    else
      redirect_to case_path(@case, :tab_active =>'notes')
    end
  end

end
