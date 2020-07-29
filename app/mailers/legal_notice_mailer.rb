# remember: methods must have matching /app/views/legal_notice_mailer/**.html.erb templates
class LegalNoticeMailer < ActionMailer::Base
  include Logoable

  SUPPORT_EMAIL = ENV.fetch('SUPPORT_EMAIL', '"Estatesearch" <legalnotice@estatesearch.co.uk>')

  default from: SUPPORT_EMAIL
  layout 'enquiry'

  def confirm_ficm(id)
    @ficm = FinancialInstitutionContactMethod.find(id)
    return if @ficm.contact_method.is_post?
    # note that we pass in delivery_method from each financial_institution_contact_method
    @via = @ficm.contact_method&.via
    @to = Mail::Address.new.tap {|m|
      m.display_name = @ficm.financial_institution.name
      m.address = @ficm.email
    }.to_s
    @subject = 'Email confirmation request from EstateSearch Ltd'
    @attachment = nil
    mail(
      to: @ficm.email,
      subject: @subject,
      delivery_method: @via
    )
  end

  def mailout_legal_notice(id)
    # reget it for very latest status
    @legal_notice = LegalNotice.find(id)
    return unless @legal_notice.file?
    return if @legal_notice.contact_method.is_post?
    return unless [:ready, :queued].include?(@legal_notice.aasm_state.to_sym)
    @via = @legal_notice.contact_method&.via
    to = @legal_notice.fancy_email
    @subject = "ES-#{@legal_notice.report.public_id} - #{@legal_notice.notice_type} to #{@legal_notice.financial_institution&.name}"
    #Tempfile.create() do |f|
    #  f.binmode
    #  f << LegalNoticeCompiler.new(@legal_notice.report, @legal_notice.financial_institution&.name).compile!.render
    #  f.rewind
      attachments.inline["ES-#{@legal_notice.report.public_id}.pdf"] = open(@legal_notice.file.url).read if @legal_notice.file?
      m = mail(
        to: to,
#       bcc: SUPPORT_EMAIL,
        subject: @subject,
        delivery_method: @via
      )
      @legal_notice.report&.commence!
      begin
        @legal_notice.sent_from_queue!
      rescue
        @legal_notice.update!(aasm_state: 'awaiting_response')
      end
      m
    #end
  end
end
