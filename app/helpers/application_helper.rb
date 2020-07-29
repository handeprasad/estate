module ApplicationHelper
  def admin_controller?
    controller.class.name.split("::").first == "Admin"
  end

  def portal_controller?
    controller.class.name.split("::").first == "Portal"
  end

  def key_required?(key)
    return true unless ["date_of_applicability", "case.ni_number", "case.document"].include?(key.to_s)
  end

  def anyone_signed_in?
    user_signed_in? || administrator_signed_in? || responder_signed_in?
  end

  def date(date)
    return nil if date.nil?
    date.strftime("%e %B %Y")
  end

  def datetime(datetime)
    return nil if datetime.nil?
    datetime.strftime("%e %B %Y %H:%M")
  end

  def case_datetime(datetime)
    return nil if datetime.nil?
    datetime.strftime("%d/%m/%Y %H:%M")
  end

  def flash_html(key)
    return unless content = flash[key]

    class_suffix = {
      alert:  'danger',
      notice: 'info'
    }.fetch(key)

    html = <<-HTML
      <button type="button" class="close" data-dismiss="alert" aria-label="Close">
        <span aria-hidden="true">&times;</span>
      </button>
      #{content}
    HTML

    content_tag :div, html.html_safe, class: "alert alert-#{class_suffix} alert-dismissable fade show mb-4", role: 'alert'
  end

  def force_turbolinks_reload
    content_for :head do
      '<meta name="turbolinks-visit-control" content="reload">'.html_safe
    end
  end

  def nav_link_to(title, href, options = {})
    klass = 'nav-link ml-2'
    klass << ' active' if request.original_fullpath.start_with? href

    content_tag :li, link_to(title, href, options.merge(class: klass)), class: 'nav-item'
  end

  def value_or_placeholder(object)
    return object unless object.blank?
    content_tag :p, '(Not set)', class: 'text-muted'
  end
end
