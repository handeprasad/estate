class ReportMailer < ApplicationMailer
  helper :application

  def approval_notification(report)
    @user   = report.user
    @report = report

    @subject = "Ref: "
    @subject << "#{report.case.customer_reference} " if report.case.customer_reference?
    @subject << "- #{report.product.title}" 
    @subject << " - Complete - ES-#{report.public_id}"

    @ref = ""
    @ref << "#{report.case.customer_reference} " if report.case.customer_reference?

    attachments.inline['dmarc-email-signature.jpg'] = Rails.root.join('app', 'assets', 'images', 'dmarc-email-signature.jpg').read
    
    mail(to: "\"#{@user.name}\" <#{@user.email}>", subject: @subject)
  end

  def order_received_notification(order)
    @order  = order
    @user   = order.user

    bcc_email =  @order.user.introducer.present? ? "#{@order.user.introducer.email},#{SUPPORT_EMAIL}" : SUPPORT_EMAIL

    attrs = { to: "\"#{@user.name}\" <#{@user.email}>", bcc: bcc_email, subject: 'Your order has been received' }
    attrs['cc'] = order.case.authorised_user.email unless order.user.has_legal_authority

    mail(attrs)
  end

  def change_notification(legal_notice)
    @legal_notice = legal_notice
    @report = @legal_notice.report
    @user   = @report.user
    @subject = "Estatesearch Notification for Report "
    @subject << "#{@report.case.customer_reference}/" if @report.case.customer_reference?
    @subject << @report.public_id
    @support = SUPPORT_EMAIL
    attrs = {
      to: "\"#{@user.name}\" <#{@user.email}>",
      bcc: @support,
      subject: @subject
    }
    mail(attrs)
  end
end
