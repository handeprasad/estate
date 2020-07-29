class Admin::RespondersController < Admin::AdminController
  before_action :set_financial_institution
  before_action :set_responder, only: [:edit, :update, :reinvite]

  def index
    @responders = @financial_institution
      .responders
      .order(:name)
  end

  def new
    @responder = @financial_institution
      .responders
      .build
  end

  def create
    @responder = @financial_institution
      .responders
      .build(responder_params)

    @responder.password = SecureRandom.hex(8)

    if @responder.valid?
      Responder.invite! @responder.attributes
      flash[:notice] = 'Responder invited.'
      redirect_to action: :index
    else
      render :new
    end
  end

  def update
    if @responder.update(responder_params)
      flash[:notice] = 'Responder updated.'
      redirect_to action: :index
    else
      render :edit
    end
  end

  def reinvite
    if @responder.reinvitable?
      @responder.invite!
      flash[:notice] = 'Invitation re-sent.'
      redirect_to action: :index
    else
      flash[:alert] = 'This invitation could not be re-sent.'
      redirect_to [:admin, @responder.financial_institution, :responders]
    end
  end

  private
    def set_financial_institution
      @financial_institution = FinancialInstitution
        .find(params[:financial_institution_id])
    end

    def set_responder
      @responder = @financial_institution
        .responders
        .find(params[:id])
    end

    def responder_params
      params
        .require(:responder)
        .permit(:name, :email, :suspended)
    end
end
