class Admin::IntroducersController < Admin::AdminController

	def index
		@introducers = Introducer.all.order(:company_name)
	end

	def new
    @introducer = Introducer.new
  end

  def create
    @introducer = Introducer.new(introducer_params)

    if @introducer.save
      flash[:notice] = 'Introducer created.'
      redirect_to action: :index
    else
      render :new
    end
  end

  def edit
    @introducer = Introducer.find(params[:id])
  end

  def update
    @introducer = Introducer.find(params[:id])
    if @introducer.update(introducer_params)
      flash[:notice] = 'Introducer updated.'
      redirect_to action: :index
    else
      render :edit
    end
  end

  private
  def introducer_params
    params.require(:introducer).permit(:company_name, :address, :contact_name, :email, :telephone, :company_registration_number, :status)
  end

end
