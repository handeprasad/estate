require 'csv'

class Admin::LegalNoticesController < Admin::AdminController
  before_action :find, except: :send_postals

  ##  /admin/reports/:report_id/legal_notices/* routes

  def process_queue
    @report.legal_notices.queued.each { |ln|
      ProcessLegalNoticeJob.perform_later(ln)
    }
    redirect_to admin_report_legal_notices_path(@report), notice: 'Legal notices queue is now processing.'
  end

  def index
    @legal_notices = @report.legal_notices.in_name_order
    @emails = FinancialInstitutionContactMethod.where(case_type: @report.case&.model_name.name).emailable.non_live.in_name_order
    @available_emails = FinancialInstitutionContactMethod.available(@report, 'email')
    @postals = FinancialInstitutionContactMethod.where(case_type: @report.case&.model_name.name).postable.non_live.in_name_order
    @available_postals = FinancialInstitutionContactMethod.available(@report, 'post')
    @uar_legal_notice = nil
    if @report.order.bundle_classes.include?("FinancialProfileServicePremium")
      # ensure that an Experian UAR record exists
      experian_uar = FinancialInstitution.find_or_create_by(name: 'Experian UAR')
      ms_graph = ContactMethod.find_by(name: 'microsoft_graph')
      FinancialInstitutionContactMethod.find_or_create_by(financial_institution: experian_uar, contact_method: ms_graph, case_type: 'Cases::Bereavement')
      FinancialInstitutionContactMethod.find_or_create_by(financial_institution: experian_uar, contact_method: ms_graph, case_type: 'Cases::MentalCapacity')
      experian_uar_ficm = FinancialInstitutionContactMethod.find_or_create_by(financial_institution: experian_uar, contact_method: ms_graph, case_type: @report.case.type)
      @uar_legal_notice = LegalNotice.find_or_create_from(@report, experian_uar_ficm)
    end
    
    # Heroku queue is short-lived. Requeue anything not sent yet. A LegalNotice will not send twice.
    if @report.scrapped?
      @report.legal_notices.queued.each {|ln| ln.scrap!}
    end

    respond_to do |format|
      format.html
      format.csv {
        c = CSV.generate {|csv|
          csv << [
            'Title', 'First name', 'Surname', 'Full name', 'Address name prefix',
            'Company name',
            'Job title',
            'Address 1',
            'Address 2',
            'Address 3',
            'Address 4', 'Address 5',
            'Address 6',
            'Telephone', 'Direct line', 'Mobile', 'Facsimile', 'Email address',
            'Extra info', 'Notes',
            'Customer Address ID',
            'Customer Import ID',
            'Custom 1', 'Custom 2', 'Custom 3', 'Custom 4', 'Custom 5', 'Custom 6', 'Custom 7', 'Custom 8', 'Custom 9', 'Custom 10',
            'Use For Proof'
          ]
          @available_postals.each {|ficm|
            csv << [
              '', '', '', '', '',
              ficm.financial_institution.name,
              ficm.contact_name || '',
              ficm.postal_address_1 || '',
              ficm.postal_address_2 || '',
              ficm.postal_town || '',
              '', '',
              ficm.postcode || '',
              '', '', '', '', '',
              '', '',
              '',
              '',
              '', '', '', '', '', '', '', '', '', '',
              '',
            ]
          }
        }
        send_data c, :filename => "ES-#{@report.public_id}_DocMail_Post.csv"
      }
    end
  end

  def show
    if @report
      pdf = @report.ens
      send_data pdf.render, type: 'application/pdf', disposition: 'inline', filename: pdf.filename
    end
  end

  def new
    @emails = FinancialInstitutionContactMethod.where(case_type: @report.case&.model_name.name).emailable.non_live
    @available_emails = FinancialInstitutionContactMethod.available(@report, 'email')
    @postals = FinancialInstitutionContactMethod.where(case_type: @report.case&.model_name.name).postable.non_live
    @available_postals = FinancialInstitutionContactMethod.available(@report, 'post')
  end

  def create
    @available_emails = FinancialInstitutionContactMethod.available(@report, 'email')
    @available_emails.each do |ficm|
      ln = LegalNotice.find_or_create_from(@report, ficm)
      ln.queue!
    end
    @available_emails = FinancialInstitutionContactMethod.available(@report, 'email')
    redirect_to action: :index
  end

  def edit
    if  @legal_notice
      if @legal_notice.notes.blank?
        @legal_notice.notes = 'Review Letter'
      end
    end
  end

  def update
    if @legal_notice.update(safe_params)
      respond_to do |format|
        format.html {
          flash[:notice] = 'Legal notice updated.'
          redirect_to admin_report_legal_notices_path(@legal_notice.report)
        }
        format.js {
          render layout: false
        }
      end


    else
      render :edit
    end
  end

  def upload_documents
    unless safe_params[:file].blank?
      category = DocumentCategory.find_or_create_by(name: 'Correspondence', document_type: 'LegalNotice')
      @document = @legal_notice.documents.new(
                    uploader: current_administrator,
                    document_category: category,
                    file: safe_params[:file]
                  )
      respond_to do |format|
        if @document.save
          @legal_notice.notes = 'Review Letter' if  @legal_notice
          @legal_notice.save if  @legal_notice
          format.html { redirect_to edit_admin_legal_notice_path(@legal_notice), notice: 'Evidence has been uploaded.' }
          format.js {
            puts "format.js"
            render layout: false
          }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to edit_admin_edit_legal_notice_path(@legal_notice) }
      end
    end
  end
  ##  /admin/legal_notices/:legal_notice_id/* routes

  ##  method names match aasm actions
  LegalNotice.aasm.events.each {|event|
    define_method(event.name) do
      @legal_notice.send("#{event.name}!")
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path) }
        format.js
      end
    end
  }

  def send_postals
    @report = Report.find(params[:id])
    @report.commence!
    @available_postals = FinancialInstitutionContactMethod.available(@report, 'post')
    @available_postals.each do |ficm|
      ln = LegalNotice.find_or_create_from(@report, ficm)
      ln.queue!
      ln.sent_from_queue!
    end
  end

  private
  def find
    @report = params[:report_id] ? Report.find(params[:report_id]) : nil
    @legal_notice = params[:id] ? LegalNotice.find(params[:id]) : nil
  end

  def safe_params
    params.require(:legal_notice).permit(
      :file,
      :notes
    )
  end
end
