
$(document).on("click",".manual_address_button", function(e) {
  var search_text_box = $("[name='address_search']");
  var id = $(search_text_box).attr("id");
  token = id.replace('address_search','');
  
  if($(".address_search_api_div").is(":visible")){


    $(".address_search_api_div").hide();
    $(".add_manual_address_div").show();

    $(".manual_address_button").html('Use Address Search'); 

    var search_input = $("input[class*='addr']");

    clear_form_fields(token);

    $('#type_address').val("Manual");
    $('.building').focus();
  } else {
    
    $(".address_search_api_div").show();
    $(".add_manual_address_div").hide();
    $(".manual_address_button").html('Manually Add Address');

    clear_form_fields(token)
    $('#type_address').val("Auto")
    $('.addr').focus();
  }

})

function clear_form_fields(token){
  $('#error_div').empty();
  $('#address_flat'+token).val("");
  $('#address_house_name'+token).val("");
  $('#address_house_number'+token).val("");
  $('#address_street'+token).val("");
  $('#address_district'+token).val("");
  $('#address_post_town'+token).val("");
  $('#address_county'+token).val("");
  $('#address_postcode'+token).val("");
  $( ".selected_address" ).empty();
}

function set_address(token){
  set_address_div(token);
}

function set_address_div(token){
  $( ".selected_address" ).empty();
  flat          = $("#address_flat"+token).val();
  house_name    = $("#address_house_name"+token).val();
  house_number  = $("#address_house_number"+token).val();
  street        = $("#address_street"+token).val();
  district      = $("#address_district"+token).val();
  post_town     = $("#address_post_town"+token).val();
  county        = $("#address_county"+token).val();
  postcode      = $("#address_postcode"+token).val();

  $('#address_search'+token).val('');

  set_address_text(flat,house_name,house_number,street,district,county,post_town,postcode);

}

function set_address_text(flat,house_name,house_number,street,district,county,post_town,postcode){
  $('<div class=divText>' + flat + '</div>').appendTo('.selected_address');
  $('<div class=divText>' + house_name + '</div>').appendTo('.selected_address');
  $('<div class=divText>' + house_number +' '+ street+ '</div>').appendTo('.selected_address');
  $('<div class=divText>' + district + '</div>').appendTo('.selected_address');
  $('<div class=divText>' + post_town + '</div>').appendTo('.selected_address');
  $('<div class=divText>' + county  + '</div>').appendTo('.selected_address');
  $('<div class=divText>' + postcode + '</div>').appendTo('.selected_address');
}

$(document).on('hidden.bs.modal','#add_address', function () {
  $(this).find('form').trigger('reset');
  $('#error_div').empty();
  $(".selected_address" ).empty();
});

$(document).on('hidden.bs.modal','#add_previous_employer', function () {
  $(this).find('form').trigger('reset');
  $('#error_div').empty();
  $(".selected_address" ).empty();
});

$(document).on('show.bs.modal','#add_address', function () {
  $(".address_search_api_div").show()
  $(".add_manual_address_div").hide()
  $( ".selected_address" ).empty();
  $(".manual_address_button").html('Manually Add Address'); 
})

$(document).on('show.bs.modal','#add_previous_employer', function () {
  $(".address_search_api_div").show()
  $(".add_manual_address_div").hide()
  $( ".selected_address" ).empty();
  $(".manual_address_button").html('Manually Add Address'); 
})

//  $('#add_manual_address').on('shown.bs.collapse', function () {
 //   $('#address_search_api').hide();
//  })

//  $('#add_manual_address').on('hidden.bs.collapse', function () {
//   $('#address_search_api').show();
//  })