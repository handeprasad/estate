
$(document).on 'turbolinks:load', ->
  initPca = (suffix = '') ->
    pcaFields = [
      { element: "address_search#{suffix}", field: "", mode: pca.fieldMode.SEARCH },
      { element: "flat#{suffix}", field: "SubBuilding", mode: pca.fieldMode.POPULATE },
      { element: "house_name#{suffix}", field: "BuildingName", mode: pca.fieldMode.POPULATE },
      { element: "house_number#{suffix}", field: "BuildingNumber", mode: pca.fieldMode.POPULATE },
      { element: "street#{suffix}", field: "Street", mode: pca.fieldMode.POPULATE },
      { element: "district#{suffix}", field: "District", mode: pca.fieldMode.POPULATE },
      { element: "post_town#{suffix}", field: "City", mode: pca.fieldMode.POPULATE },
      { element: "county#{suffix}", field: "Province", mode: pca.fieldMode.POPULATE },
      { element: "postcode#{suffix}", field: "PostalCode", mode: pca.fieldMode.POPULATE },
    ]

    control = new pca.Address(pcaFields, { key: "RJ89-AM82-TK88-FJ91" });
    control.listen 'populate', -> 
      $("[id$='flat#{suffix}']").trigger('change')
      set_address(suffix)
      if $('#order_report_button').length
        $('#order_report_button').focus()
      else
        $('#case_submit').focus()

  initContainer = (container) ->
    token = Math.random().toString(36).substring(7)
    $(container).find('input').each (i, input) -> $(input).attr('id', $(input).attr('id') + token)
    initPca(token)

  if $('[name="address_search"]').length == 1
    initPca()
  else if $('[name="address_search"]').length > 1
    $('[name="address_search"]').each (i, el) ->
      initContainer $(el).parents('[data-address-search-scope]')

  $('#previous_addresses, #previous_employers').on 'cocoon:after-insert', (e, inserted) ->
    initContainer(inserted)
