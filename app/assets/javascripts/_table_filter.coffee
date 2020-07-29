$(document).on 'turbolinks:load', ->
  $('.filter_input').on 'keyup', ->
    filter = $(this).val().toLowerCase()

    $('table tbody tr').each (i, r) ->
      $r = $(r)
      if $r.data('filter-key').indexOf(filter) > -1
        $r.show()
      else
        $r.hide()
