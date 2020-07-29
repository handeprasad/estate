class Admin::NamesController < Admin::AdminController
  def create
    report = Report.find(params[:report_id])
    @name = report.case.names.new(name_params)

    if @name.save
      head :no_content
    else
      render partial: 'application/form_errors', locals: { object: @name }, status: :bad_request
    end
  end

  def edit
    @name = Name.find params[:id]
  end

  def update
    @name = Name.find params[:id]
    @report = Report.find params[:report_id]
    @name.update(name_params)
  end

  private

  def name_params
    params.require(:name).permit(Name::PARAMS).tap do |np|
      np.merge! source: current_administrator
    end
  end
end
