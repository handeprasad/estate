class Admin::DocumentsController < Admin::AdminController
  def show
    gid         = GlobalID.parse Base64.urlsafe_decode64(params[:id])
    object      = GlobalID::Locator.locate gid
    destination = object.public_send(gid.params[:attribute]).url

    redirect_to destination
  end

  def edit
    @document = Document.find(params[:id])
    @document_categories = @document.document_item.document_categories.pluck(:name, :id)
  end

  def update
    @document = Document.find(params[:id])
    if @document.update!(safe_params[:document])
      flash[:notice] = 'Document updated.'
      redirect_to controller: :reports, action: :index
    else
      render :edit
    end
  end

  def destroy
    @document = Document.find params[:document_id]
    @document.destroy
  end

  def toggle_included
    @document = Document.find params[:id]
    @document.toggle!(:included)
    respond_to do |format|
      format.js {
        render :body => nil
      }
    end
  end

  ##  method names match aasm actions
  Document.aasm.events.each {|event|
    define_method(event.name) do
      @document = Document.find(params[:id])
      @document.send("#{event.name}!")
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path) }
        format.js
      end
    end
  }

  def safe_params
    params.permit(
      document: [:document_category_id, :pages, :included]
    )
  end
end
