class ProcessLegalNoticeJob < ApplicationJob
  queue_as :default

  def perform(legal_notice)
    legal_notice = LegalNotice.find legal_notice.id
    report = legal_notice.report
    filename = Rails.root.join('tmp', 'legalnotices', "ES-#{report.public_id}-#{SecureRandom.hex(3)}.pdf")
    ensure_tmp_dir_exists_for filename
    legal_notice_file = LegalNoticeCompiler.new(report, legal_notice.financial_institution&.name, filename).compile!
    legal_notice.file = File.open(legal_notice_file.filename)
    legal_notice.save(validate: false)

    File.unlink filename
    LegalNoticeMailer.mailout_legal_notice(legal_notice.id)&.deliver_later()
  end

  def ensure_tmp_dir_exists_for(filename)
    Dir.mkdir File.dirname(filename)
  rescue Errno::EEXIST
  end
end
