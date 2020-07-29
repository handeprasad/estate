class Admin::ProofsController < Admin::AdminController
  before_action :find

  def show
    redirect_to @proof.document.url
  end

  def edit
  end

  def update
    @proof = Proof::Base.find(params[:id])
    if @proof.update!(safe_params)
      flash[:notice] = 'Proof updated.'
      redirect_to controller: :reports, action: :index
    else
      render :edit
    end
  end

  ##  method names match *shared* aasm actions
  Proof::Base.aasm.events.each {|event|
    define_method(event.name) do
      @proof = Proof::Base.find(params[:id])
      @proof.send("#{event.name}!")
      respond_to do |f|
        f.html { redirect_back(fallback_location: root_path) }
        f.js
      end
    end
  }

  private

  def safe_params
    puts(params)
    params.require(:proof).permit(
      :kind,
      :pages,
      proof_mental_capacity: [:id, :document, :document_cache, :kind, :_destroy],
      proof_bereavement: [:id, :document, :document_cache, :kind, :_destroy]
    )
  end

  def find
    @proof = Proof::Base.find(params[:id])
  end
end
