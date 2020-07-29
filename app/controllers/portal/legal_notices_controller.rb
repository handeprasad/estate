class Portal::LegalNoticesController < Portal::BaseController
  before_action :set_legal_notice, only: [
    :show,
    :update,
    :respond,
    :finalise
  ]

  def index
    set_legal_notices
  end

  def show_tab
    set_legal_notices
  end

  def show
    @legal_notice = current_responder
      .financial_institution
      .legal_notices
      .after_july_2020
      .find(params[:id])
    @report = @legal_notice.report
  end

  def update
    @legal_notice.update legal_notice_params
    respond_to do |format|
      format.html do
        flash[:notice] = 'Successfully updated case, please click finalise when you are happy with the details.'
        redirect_to [:portal, @legal_notice]
      end
      format.js
    end
  end

  def respond
    case params[:match]
      when '1'
        @legal_notice.no_match!
      when '2'
        @legal_notice.match_pending_detail!
      when '3'
        @legal_notice.match!
    end
    respond_to do |format|
      format.html do
        flash[:notice] = 'Successfully responded, thank you.'
        redirect_to [:portal, :legal_notices]
      end
      format.js { render :update }
    end
  end

  def finalise
    @legal_notice.inform_lawyer_of_match!
    flash[:notice] = 'Successfully finalised case, thank you for your response.'
    redirect_to action: :index
  end

  private
    def set_legal_notice
      @legal_notice = current_financial_institiution
        .legal_notices
        .find(params[:id])
    end

    def set_legal_notices
      aasm_states = [:awaiting_response, :match_pending_detail]
      aasm_states = [:no_match, :match, :match_informed] if params[:tab] == 'responded'

      @q = current_financial_institiution
        .legal_notices
        .after_july_2020
        .where(aasm_state: aasm_states)
        .ransack params[:q]
      @q.sorts = 'sent_at' if @q.sorts.empty?
      @legal_notices = @q.result.page(params[:page]).per(25)
    end

    def legal_notice_params
      params
        .require(:legal_notice)
        .permit(
          :responder_notes,
          documents_attributes: [:id, :file, :_destroy]
        )
    end
end
