$(document).on 'turbolinks:load', ->
  $('.datepicker').each (i, el) ->
    $el = $(el)

    # convert Rails date values to the format we want
    if $el.val().match(/\d{4}\-\d{2}\-\d{2}/)
      date = new Date($(el).val())
      formatted = moment(date).format('DD/MM/YYYY')
      $(el).val(formatted)

    props = {
      field: el,
      format: 'DD/MM/YYYY'
      minDate: new Date('01/01/1850')
    }

    picker = new Pikaday(props)

    # https://github.com/dbushell/Pikaday/pull/610#issuecomment-275396027
    document.removeEventListener 'keydown', picker._onKeyChange
