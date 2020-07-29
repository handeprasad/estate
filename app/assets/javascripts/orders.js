function resetUnwantedProducts(){
  check_or_uncheck_bundle()
  $('.Products').each(function(e) { 
  	bundle_included = $(this).data('bundle-included');
  	current_id = $(this).attr("id");
  	bundle_array = bundle_included.split(",")
    product_visible = true
    
  	$.each(bundle_array, function( index, value ) {
      if($("#"+value).is(':checked')) { 
      	$("#"+current_id).prop("checked", false);
      	//$("#"+current_id).parent().parent().parent().hide();
      	$("#"+current_id).prop("disabled",true);
        product_visible = false;
      }
      else if (product_visible == true){
      	//$("#"+current_id).parent().parent().parent().show();
      	$("#"+current_id).prop("disabled",false);
      }
    });
  });

  resetFinancialAssetSearch();
}

function resetFinancialAssetSearch(){
  if (($("#FinancialProfileServicePremium").is(':checked')) || ($("#FinancialProfileServiceStandard").is(':checked'))){
    $("#AssetSearch").prop("checked", false);
    $("#AssetSearch").parent().parent().parent().hide();
  }
  else{
    $("#AssetSearch").parent().parent().parent().show();
    $("#AssetSearch").prop("disabled",false);
  }
}

function check_or_uncheck_bundle(){
  if ($("#FinancialProfileServicePremium").is(':checked')){
    $('#FinancialProfileServiceStandard').attr('disabled', true);
  }else{
    $('#FinancialProfileServiceStandard').attr('disabled', false);
  }
  if ($("#FinancialProfileServiceStandard").is(':checked')){
    $('#FinancialProfileServicePremium').attr('disabled', true);
  } else {
    $('#FinancialProfileServicePremium').attr('disabled', false);
  }

}


$(document).on("change",".Bundles", function(e) {
  $('input.Bundles').not(this).prop('checked', false); 
  var el, total, _i, _len, _ref;
  total = 0;
  _ref = $('[data-price]:checked, form[data-price]');
  for (_i = 0, _len = _ref.length; _i < _len; _i++) {
    el = _ref[_i];
    total += $(el).data('price');
  }
  $('[data-price-total]').html((total / 100).toFixed(2)); 
});

function clearAllIntervals() {
  for(i=0; i<1000; i++)
    {
        window.clearInterval(i);
    }
}


// Add click event dynamically
$(document).on("click", "#readMoreLink", function() {
  event.stopPropagation();
  event.preventDefault();

  // Check if text is more or less info
  if ($(this).text() == "Click here for more info") {

    // Change link text
    $(this).text("Click here for less info");
    
    $(this).parent().parent().parent().find("div.productDescription").removeClass("hidden");
    $(this).parent().parent().parent().find("div.productDescription").addClass("show");
    
  } else {

    // Change link text
    $(this).text("Click here for more info");
    
    $(this).parent().parent().parent().find("div.productDescription").removeClass("show");
    $(this).parent().parent().parent().find("div.productDescription").addClass("hidden");
    
  }
  
});