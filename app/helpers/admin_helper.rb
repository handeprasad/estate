module AdminHelper
  def admin_bool(value)
    if value
      content_tag :span, 'Yes', class: 'text-success'
    else
      content_tag :span, 'No', class: 'text-danger'
    end
  end

  def admin_report_match(_match)
    if _match
      content_tag :span, 'Match', class: 'text-success'
    else
      content_tag :span, 'No Match', class: 'text-danger'
    end
  end

  def admin_report_status_badge(report)
    badge = {
      'requested'  => 'warning',
      'processing' => 'info',
      'processed'  => 'primary',
      'delivered'  => 'success',
      'scrapped'   => 'danger',
      'cancelled'  => 'danger',
      'information_required' => 'danger'
    }.fetch(report.aasm_state)

    content_tag :span, report.aasm_state.titleize, class: "ml-1 badge badge-#{badge}"
  end

  def admin_report_tab(report, title, active: false, badge: false)
    content_tag :li, class: 'nav-item' do
      css_class = 'nav-link'
      css_class += ' active' if active

      key = [
        title.downcase.gsub(' ', '_'),
        report.id
      ].join('_')

      _title = title.html_safe
      _title << " ".html_safe + content_tag(:span, '!', class: 'badge badge-warning') if badge.present?

      link_to _title, "##{key}", class: css_class, data: { toggle: 'tab' }
    end
  end

  def admin_reports_filter_key(report)
    [
      report.case.case_individual.to_s.downcase,
      report.public_id,
      report.case.customer_reference.try(:downcase),
      report.case.company.name.downcase
    ].flatten.join(' ')
  end

  def aasm_status_badge(aasm_object)
    current_state = aasm_object.aasm.states.select {|n| n.name == aasm_object.aasm.current_state}.first
    badge = current_state&.options[:level] || 'secondary'
    content_tag :span, aasm_object.aasm_state&.titleize, class: "ml-1 badge badge-#{badge}"
  end

  def ens_progress(report)
    days = 30 - @report.days_remaining
    days = 30 if @report.days_remaining < 0
    pcent = 0
    pcent = 30 / days * 100 if days > 0
    badge = 'success'
    badge = 'warning' if pcent > 50
    badge = 'danger' if pcent > 75
    content_tag :div, class: "progress" do
      content_tag :div, class: "progress-bar bg-#{badge}", role: "progressbar", style: "width: #{pcent}%", "aria-valuenow" => "#{days}", "aria-valuemin" => "0", "aria-valuemax" => "30" do
        if @report.commenced_at.present?
          content_tag :span, "#{@report.days_remaining} days left"
        else
          content_tag :span, "waiting for 1st mailout"
        end
      end
    end
  end

  def bootstrap_text_field(f, key)
    field = f.text_field(key, class: 'form-control')
    bootstrap_field(f, key, field)
  end

  def bootstrap_select_field(f, key, options)
    field = f.select(key, options, {}, class: 'form-control')
    bootstrap_field(f, key, field)
  end

  def bootstrap_readonly_text_field(f, key, field_value=nil)
    field = f.text_field(key, class: 'form-control-plaintext')
    field = content_tag(:span, class: 'form-control-plaintext') { field_value } if field_value
    bootstrap_field(f, key, field)
  end

  def bootstrap_field(f, key, field)
    content_tag(:div, class: 'row mb-3') do
      content_tag(:div, class: 'col-md-6') do
        content_tag(:div, class: 'form-group') do
          f.label(key, class: 'form-control-label') +
          field 
        end
      end
    end
  end

  def company_accreditation_check
    return [[ "Yes", true ], [ "No", false ]]
  end

  def company_default_reg_date(company)
    return company.date_registered.present? ? company.date_registered  : Time.now.strftime('%Y-%m-%d')
  end

  def user_accrediting_body
    return [ [ "Law Society", "Law Society" ], [ "Law Society of Scotland", "Law Society of Scotland" ], [ "STEP", "STEP" ], [ "CiLEX", "CiLEX" ], [ "ICAEW", "ICAEW" ] ]
  end
end
