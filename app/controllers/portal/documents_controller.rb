class Portal::DocumentsController < Portal::BaseController
  before_action :set_legal_notice
  before_action :set_document

  def destroy
    @document.destroy
    render 'portal/legal_notices/update'
  end

  private
    def set_legal_notice
      @legal_notice = current_financial_institiution
        .legal_notices
        .find(params[:legal_notice_id])
    end

    def set_document
      @document = @legal_notice.documents.find params[:id]
    end
end
