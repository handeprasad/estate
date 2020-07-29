$(document).on 'turbolinks:load', ->
  loadDetails = (id, tab = null) ->
    $target = $("[data-report-id='#{id}']")
    $.get "/admin/responses/#{id}.html", (data) ->
      $target.html(data)

  $('.responses-table').on 'show.bs.collapse', '.report_details', (event) ->
    loadDetails $(this).data('report-id')

  $('.admin--reports').on 'ajax:error', 'form[data-tab]', (e, data, status, xhr) ->
    $(this).find('.errors').html(data.responseText)

  $('[name^="filter["]').on 'change', (e) ->
    e.preventDefault()
    $this   = $(this)
    $target = $('.responses-table')
    params  = $('#report_filter').serialize() || encodeURIComponent('filter[requested]')

    $target.animate({ opacity: 0.5 })

    $.get '/admin/responses', params, (data, textStatus, jqXHR) ->
      $target.html $(data).find('.responses-table').html()
      $target.finish().css opacity: 1
