class Admin::SearchesController < Admin::AdminController
  def show
    @search = Search.find(params[:id])

    respond_to do |format|
      format.any(:html, :pdf) { redirect_to @search.file.url }
      format.xml
    end
  end

  def create

    @report = Report.find params[:report_id]
    @report.disable_compile = true
    @report.save

    search_name = @report.case.names.where(id: params[:search][:name]).first
    search_address = @report.case.addresses.where(id: params[:search][:address]).first

    params[:search][:title]       = search_name.title
    params[:search][:forename]    = search_name.forename
    params[:search][:middle_name] = search_name.middle_name
    params[:search][:surname]     = search_name.surname
    params[:search][:name_suffix] =  search_name.name_suffix
    params[:search][:flat]        = search_address.flat
    params[:search][:house_name]  =  search_address.house_name
    params[:search][:house_number]= search_address.house_number
    params[:search][:street]      = search_address.street
    params[:search][:district]    = search_address.district
    params[:search][:post_town]   = search_address.post_town
    params[:search][:county]      = search_address.county
    params[:search][:postcode]    = search_address.postcode

    @search = Search.create! search_params.merge(administrator: current_administrator, report: @report)
    @search.execute!


    #head :no_content
  end

  private

  def search_params
    params.require(:search).permit(*Search::CASE_PARAMS)
  end
end
