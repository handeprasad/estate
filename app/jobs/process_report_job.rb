require "json/add/exception"

class ProcessReportJob < ApplicationJob
  queue_as :default

  attr_reader :report

  def perform(report)
    @report = report
    @report.update! error: ''

    execute_delphi_query
    compile_report unless report.delphi.error?
  rescue Exception => e
    @report.update! error: e.to_json
    Rails.logger.error { [ e.class, e.message, e.backtrace ].join("; ") }
  end

  private
  def compile_report
    filename = Rails.root.join('tmp', 'reports', "#{report.public_id}-#{SecureRandom.hex(3)}.pdf")
    #compiler = ReportCompiler.new(report, filename)
    compiler = ReportCompilerWithoutEstateAdminProtection.new(report, filename)

    ensure_tmp_dir_exists_for filename
    compiler.compile!

    File.open compiler.filename do |f|
      if report.class.name == "Search"
        report.update! file: f
      else
        if report.documents.any?
          document = report.documents.first
        else
          document = report.documents.new          
        end
        document.file = f
        document.save
      end


    end

    File.unlink filename
  end

  def ensure_tmp_dir_exists_for(filename)
    Dir.mkdir File.dirname(filename)
  rescue Errno::EEXIST
  end

  def execute_delphi_query
    return if report.delphi_response.present?

    env      = ENV.fetch('DELPHI_ENV').to_sym
    params   = Delphi::Params.new(report).to_h
    response = Delphi::Query.new(env, params).execute!
    report.update! delphi_response: response
  end
end
