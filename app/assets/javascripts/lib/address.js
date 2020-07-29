$(document).on("click","#manual_address", function(e) {
  if($("#address_search_api").is(":visible")){
    $("#address_search_api").hide()
    $("#manual_address").html('Use Address Search'); 
    var token = 'token'
    clear_fields(token)
    $("#add_manual_address").show()
  } else {
    clear_fields(token)
    $("#manual_address").html('Manually Add Address');
    $("#address_search_api").show()
    $("#add_manual_address").hide()
  }

})

function clear_fields(token){
  $('#address_flat').val("");
  $('#address_house_name').val("");
  $('#address_house_number').val("");
  $('#address_street').val("");
  $('#address_district').val("");
  $('#address_post_town').val("");
  $('#address_county').val("");
  $('#address_postcode').val("");

  $( "#selected_address" ).empty();
}