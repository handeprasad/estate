module CasesHelper
  def cases_filter_key(kase)
    [
      kase.name.to_s.downcase,
      kase.reports.map(&:public_id),
      kase.customer_reference.try(:downcase)
    ].flatten.join(' ')
  end

  def hide_and_show_class(user_case, div_id)
    if div_id == "step1"
      return "hidden" unless user_case.matter_type_id.blank?
    elsif div_id == "step2"
      return "hidden" if user_case.matter_type_id.blank?
    end
  end

  def add_cancel_id_if_new(user_case)
    return "case_cancel" if user_case.new_record?
  end

  def hide_and_show_matter_type(user_case, matter_type)
    return "" if ((user_case.matter_type.name.to_s.downcase.gsub(" ", "_").strip rescue "") == matter_type)
    return "display: none;"

  end

  def expected_delivery(report)
  	return nil if report.requested_at.nil?
    turnaround_days = report.product.turnaround_days

    start_date = report.requested_at

    for ds in 1..turnaround_days do
      end_date = start_date + 1.days
      
      holiday = Holidays.on(end_date, :gb)
      if holiday.length > 0
        end_date = end_date + 1.days
      end
      
      holiday = Holidays.on(end_date, :gb)
      if holiday.length > 0
        end_date = end_date + 1.days
      end

      if end_date.wday == 6
        end_date = end_date + 1.days
      end

      if end_date.wday == 0
        end_date = end_date + 1.days
      end

      start_date = end_date
    end
      holiday = Holidays.on(end_date, :gb)
      if holiday.length > 0
        end_date = end_date + 1.days
      end
      holiday = Holidays.on(end_date, :gb)
      if holiday.length > 0
        end_date = end_date + 1.days
      end
      if end_date.wday == 6
        end_date = end_date + 2.days
      elsif end_date.wday == 0
        end_date = end_date + 1.days
      end
    end_date.strftime("%d/%m/%Y") rescue nil
  end

  def case_turnaround_days(report)
    report.product.turnaround_days
  end

  def my_cases_report_badge(kase)
    all_reports_count = kase.reports.count
    processing  = kase.reports.where(aasm_state: 'processing').count
    requested   = kase.reports.where(aasm_state: 'requested').count
    processed   = kase.reports.where(aasm_state: 'processed').count
    completed   = kase.reports.where(aasm_state: 'delivered').count
    cancelled   = kase.reports.where(aasm_state: 'cancelled').count
    scrapped    = kase.reports.where(aasm_state: 'scrapped').count
    information_required    = kase.reports.where(aasm_state: 'information_required').count
    #multiple_values = kase.reports.reject{|x| x.aasm_state == "requested"}.map(&:aasm_state).uniq 
    if requested == all_reports_count
      badge_name = 'Requested'
    elsif completed == all_reports_count
      badge_name = 'Complete'
    elsif processing == all_reports_count
      badge_name = 'Processing'
    elsif cancelled == all_reports_count || scrapped == all_reports_count
      badge_name = 'Cancelled'
#    elsif scrapped == all_reports_count
#      badge_name = 'Scrapped'
    elsif processed == all_reports_count
      badge_name = 'Processed'
    elsif information_required.to_i > 0
      badge_name = 'Information Required'
    #elsif processing.to_i == 0 && (requested.to_i >0 || cancelled.to_i >0 || scrapped.to_i >0 || completed.to_i >0 )
    #  badge_name = 'Processing'
    elsif completed.to_i > 0 && (scrapped.to_i > 0 || cancelled.to_i > 0) && processing.to_i == 0
      badge_name = 'Complete'
    else
      badge_name = 'Processing'
    end
    content_tag :span, badge_name, class: 'ml-1 ' + {
      'Complete'         => 'badge badge-success',
      'Cancelled'        => 'badge badge-danger',
      'Scrapped'         => 'badge badge-danger',
      'Processing'       => 'badge badge-info',
      'Processed'        => 'badge badge-primary',
      'Requested'        => 'badge badge-warning',
      'Information Required' => 'badge badge-danger'
    }.fetch(badge_name)
  end

  def note_name(case_note)
    case_note.user_type == 'Administrator' ? 'Administrator' : case_note.user.name
  end

  def note_form_heading_text
    if @case_note.new_record?
      "New Note"
    else
      "Edit Note"
    end
  end

  def note_form_button_text
    if @case_note.new_record?
      "Create"
    else
      "Update"
    end
  end

  def can_edit_note(note)
    if (note.user_id == current_user.id && note.user_type == 'User')
      true
    else
      false
    end
  end

  def case_legal_capacity(kase)
    if kase.firm_is.to_s == 'acting'
      return "Your firm is acting on behalf of the: \n #{kase.legal_capacity}"
    elsif kase.firm_is.to_s == 'member'
      return "You, your firm or a member of your firm are the: \n #{kase.legal_capacity}"
    else
      return kase.legal_capacity
    end
  end

  def response_date(ln)
    if ln.documents.live.present?
      date(ln.documents.live.last.created_at)
    else
      date(ln.response_at)
    end
  end

end
