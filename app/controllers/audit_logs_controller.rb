class AuditLogsController < ApplicationController

	before_action :authenticate_user!
	before_action :can_edit_note , only: [:edit, :update]
	before_action :set_case

	def index
		#redirect_to case_path(@case, :tab_active =>'notes')
	end

  def new
    @case_note = @case.audit_logs.new
  end

  def create
=begin
    if administrator_signed_in?
      user = current_administrator
    else
      user = current_user
    end
=end
    @case_note = @case.audit_logs.new(case_note_params.merge(user: current_user))

    if @case_note.save
      flash[:notice] = 'Note created.'
      redirect_to case_path(@case, :tab_active =>'notes')
    else
      render :new
    end
  end

  def edit
  	@case_note = AuditLog.find(params[:id]) 
  end

  def update
  	@case_note = @case.audit_logs.find(params[:id]) 

    #if administrator_signed_in? && @case_note.user_type == 'Administrator'
    #  user = current_administrator
    #else
    #user = current_user
    #end
    @case_note.assign_attributes(case_note_params.merge(user: current_user))

    if @case_note.save
      flash[:notice] = 'Note updated.'
      redirect_to case_path(@case, :tab_active =>'notes')
    else
      render :edit
    end
  end

=begin
  def show_or_hide
    redirect_to case_path(@case, :tab_active =>'notes') if !administrator_signed_in?
    hide = params["checkbox_audit_log_#{params[:id]}"]
    @case = current_company.cases.find(params[:case_id])
    @case_note = AuditLog.find(params[:id]) 
    if hide.present?
      @case_note.hide_note = true
    else
      @case_note.hide_note = false
    end
    @case_note.save

    @notes = AuditLog.where(auditable_type: 'Case', auditable_id: @case).order("updated_at desc")
    if !current_administrator
      @notes = @notes.where(hide_note: false).order("updated_at desc")
    end
    @user_notes = @notes.where(user_type: 'User').count
    @admin = current_administrator ? true : false


  #  head :no_content 
  end
=end

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
