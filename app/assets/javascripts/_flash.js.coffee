$(document).on 'turbolinks:load', ->
  $('.flash .container').append "<span class=\"flash-closer\">&times;</span>"
  $('.flash-closer').click ->
    $(@).parents('.flash').slideUp()
