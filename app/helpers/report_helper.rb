module ReportHelper

  def report_dates(report)
    return "#{date report.case.date_of_birth } &mdash; #{date report.case.date_of_applicability}".html_safe
  end
  def report_status_badge(status)
    content_tag :span, status, class: 'ml-1 ' + {
      'Complete'         => 'badge badge-success',
      'Cancelled'        => 'badge badge-danger',
      'Scrapped' 	       => 'badge badge-danger',
      'Processing'       => 'badge badge-info',
      'Requested'		     => 'badge badge-warning',
      'Processed'		     => 'badge badge-warning',
    }.fetch(status)
  end

  def status_options(report)
    sts = []
    if report.aasm_state == 'requested' || report.aasm_state == 'processing'
      sts << ['Information Required', 'information_required']
    elsif report.aasm_state == 'information_required' && report.prev_status == 'processing'
      sts << ['Processing', 'processing']
    elsif report.aasm_state == 'information_required' && report.prev_status == 'requested'
      sts << ['Requested', 'requested']
    end
    options_for_select(sts)
  end

  def report_legal_capacity(report)
    if report.case.firm_is.to_s == 'acting'
      return "Your firm is acting on behalf of the: \n #{report.case.legal_capacity}"
    elsif report.case.firm_is.to_s == 'member'
      return "You, your firm or a member of your firm are the: \n #{report.case.legal_capacity}"
    else
      return report.case.legal_capacity
    end
  end
end
