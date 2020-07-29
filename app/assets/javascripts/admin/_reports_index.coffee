$(document).on 'turbolinks:load', ->
  loadDetails = (id, tab = null) ->
    $target = $("[data-report-id='#{id}']")

    $.get "/admin/reports/#{id}.html", (data) ->
      $target.html(data)
      $target.find("a[href^='##{tab}']").tab('show') if tab?

  $('.reports-table').on 'show.bs.collapse', '.report_details', (event) ->
    loadDetails $(this).data('report-id')

  $('#add_address, #add_previous_employer, #add_name').on 'show.bs.modal', (event) ->
    $button = $(event.relatedTarget)
    $form   = $(this).find('form')
    action  = $form.attr('action')
    id      = $button.data('report-id')

    $(this).find('.errors').html('')
    $form.find('input[type=text], input[type=search]').val('')
    $form.data('report-id', id)
    $form.attr('action', action.replace(/reports\/\d+/, 'reports/' + id))


  $('.admin--reports').on 'ajax:error', 'form[data-tab]', (e, data, status, xhr) ->
    $(this).find('.errors').html(data.responseText)

  $('.admin--reports').on 'ajax:success', 'form[data-tab]', (e, data, status, xhr) ->
    $this = $(this)
    $('.modal').modal('hide')
    if $this.data('tab') != 'notes'
      loadDetails $this.data('report-id'), $this.data('tab')

  $('.admin--reports').on 'ajax:success', '.report-search-form', (e, data, status, xhr) ->
    id = $(this).parents('[data-report-id]').data('report-id')
    loadDetails id, 'searches'

  $('.admin--reports').on 'ajax:success', '.report-upload-form', (e, data, status, xhr) ->
    id = $(this).parents('[data-report-id]').data('report-id')
    loadDetails id, 'upload_pdf'


  $('[name^="filter["]').on 'change', (e) ->
    e.preventDefault()
    $this   = $(this)
    $target = $('.reports-table')
    params  = $('#report_filter').serialize() || encodeURIComponent('filter[requested]')

    $target.animate({ opacity: 0.5 })

    $.get '/admin/reports', params, (data, textStatus, jqXHR) ->
      $target.html $(data).find('.reports-table').html()
      $target.finish().css opacity: 1