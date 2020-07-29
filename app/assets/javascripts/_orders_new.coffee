$(document).on 'turbolinks:load', ->
  return unless $('form#new_order').length


  # price total
  updateTotal = ->
    resetUnwantedProducts()
    total = 0
    total += $(el).data('price') for el in $('[data-price]:checked, form[data-price]')
    $('[data-price-total]').html((total / 100).toFixed(2))

  $('[data-price]').on 'change', updateTotal
  $('[data-toggle="tab"]').on 'shown.bs.tab', updateTotal
  updateTotal()


  # toggle form of authority field
  updateFormOfAuthorityFieldVisibiliy = ->
    $container = $('[data-proof-kind="Form of Authority signed by attorney/deputy"]')

    show = $('[name$="[legal_capacity]"]:checked').val() is 'on behalf of the attorney/deputy'
    $container.toggle show


  $('[name$="[legal_capacity]"]').on 'change', updateFormOfAuthorityFieldVisibiliy
  updateFormOfAuthorityFieldVisibiliy()


  # file uploads
  bsCustomFileInput.init()
