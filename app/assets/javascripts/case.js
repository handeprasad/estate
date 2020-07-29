$(document).on("click",".legal-capacity-radio-input", function(e) {
	value = $(this).data("firm")
	data_val = $(this).val()
	$("#case_firm_is").val(value);
	matter_type = $(".matter_type:checked").parent().text().trim();

	if (matter_type == 'Intestate' && value == 'acting'){
		clear_next_kin_attributes()
		$('#intestate_other_details').removeClass("invisible");
		$('#intestate_other_details').show();
		$("#case_next_to_kin_attributes_title").focus();
	} else {
		$('#intestate_other_details').addClass("invisible");
		$('#intestate_other_details').hide();
	}
});

function clear_next_kin_attributes(){
	// clear next to kin details
	$("#case_next_to_kin_attributes_title").val("")  ;
	$("#case_next_to_kin_attributes_firstname").val("") ;
	$("#case_next_to_kin_attributes_middle_name").val("") ;
	$("#case_next_to_kin_attributes_surname").val("");
	$("#case_next_to_kin_attributes_name_suffix").val("");
	$("#custom_source_data").val("");	
}

function resetLegalCapacityValues() {
	if ($(".matter_type").is(":checked") == true){
		$(".matter_type:checked").trigger("click");	
		legal_capacity_value = $("#selected_legal_capacity_id").val();
		$('input.legal-capacity-radio-input').each(function() {
			if ($(this).val() == legal_capacity_value){
				$(this).prop("checked", true);
				$(this).trigger("click");	
 			}
		});
		addCaseName();
		change_date_of_applicability_label();
	}
}

function hideAllLegalCapacityContainers() {
	$(".declarationMemberContainer").addClass("invisible");
	$(".declarationMemberContainer").hide();
	$(".declarationOrContainer").addClass("invisible");
	$(".declarationOrContainer").hide();
	$(".declarationActingContainer").addClass("invisible");
	$(".declarationActingContainer").hide();
	$("#acting_legal_capacity_div_1").addClass("invisible");
	$("acting_legal_capacity_div_1").hide();
	$("#acting_legal_capacity_div_2").addClass("invisible");
	$("#acting_legal_capacity_div_2").hide();
	$('#intestate_other_details').addClass("invisible");
	$('#intestate_other_details').hide();
}

$(document).on("click",".matter_type", function(e) {
	$(".legal-capacity-radio-input").prop("checked", false);

	clear_next_kin_attributes();

	// call a function to clear all container texts
	hideAllLegalCapacityContainers();

	matter_type = $(".matter_type:checked").parent().text().trim();
	member = $(this).data("member");


	if ( typeof(member) != 'undefined' && member != ""){
		$(".declarationMemberContainer").removeClass("invisible");	
		$(".declarationMemberContainer").show()
		$("#member_legal_capacity_label_1").text(member);
		member_id = $(this).data("member-id");
		$("#member_legal_capacity_1").val(member_id);
	}
	acting1 = $(this).data("acting1");
	if ( typeof(acting1) != 'undefined' && acting1 != ""){
		$(".declarationActingContainer").removeClass("invisible");
		$(".declarationActingContainer").show();
		$(".declarationOrContainer").removeClass("invisible");
		$(".declarationOrContainer").show();
		$("#acting_legal_capacity_div_1").removeClass("invisible");
		$("#acting_legal_capacity_div_1").show();

		$("#acting_legal_capacity_label_1").text(acting1)
		acting_id = $(this).data("acting1-id");
		$("#acting_legal_capacity_1").val(acting_id);
	}

	acting2 = $(this).data("acting2");
	if ( typeof(acting2) != 'undefined' && acting2 != ""){
		$(".declarationActingContainer").removeClass("invisible");
		$(".declarationActingContainer").show();
		$(".declarationOrContainer").removeClass("invisible");
		$(".declarationOrContainer").show();
		$("#acting_legal_capacity_div_2").removeClass("invisible");
		$("#acting_legal_capacity_div_2").show();
		$("#acting_legal_capacity_label_2").text(acting2)
		acting_id = $(this).data("acting2-id");
		$("#acting_legal_capacity_2").val(acting_id);

		if (acting2 == "Next of Kin"){
		  $(".declarationOrContainer").addClass("invisible");
		  $(".declarationOrContainer").hide();
		  $(".declarationMemberContainer").addClass("invisible");
		  $(".declarationMemberContainer").hide();
		}

	}


	// Declaration Pre Populate where there is only a single option
	if ( (typeof(member) != 'undefined' && member != "") && (typeof(acting1) == 'undefined' || acting1 == "") && (typeof(acting2) == 'undefined'|| acting2 == "")){
		$("#member_legal_capacity_1").prop("checked", true);
		$("#member_legal_capacity_1").trigger("click");	
	}
});

function addCaseName() {
	matter_type = $(".matter_type:checked").parent().text();
	matter_type_id = $(".matter_type:checked").attr("id").split("_")[0]
	case_type = $("#" + matter_type_id).text();
	case_name = case_type + " - " + matter_type
	$("#case_step2_name").text(case_name);
}

function change_date_of_applicability_label(){
	case_type = $(".matter_type:checked").parent().parent().parent("div").find("h5").attr("id");
	if (case_type == 'bereavement'){
		$("#date_of_applicability").text("Date of Death");
	} else {
		$("#date_of_applicability").text("Date of Appointment");
	}
}

$(document).on("click",".mater_type_submit_button", function(e) {
	e.preventDefault();
  	e.stopPropagation();
	$('tr.text-danger').remove();
	
	valid = validate_case_form_data();
	
	if(valid == true){
		$('tr.text-danger').remove();
		$("#step1").hide();
		$("#step2").removeClass('hidden');
		$("#step2").show();
		$(".text-danger").empty();
		$("#case_customer_reference").focus();
		addCaseName();
		//change the label text for date of applicability
		change_date_of_applicability_label()
	} else {
		$('#error_table').prepend("<tr class='text-danger'><td><h5>Please check and try again:</h5></td></tr>");
		$('#bereavement_testate').focus()
	}

})

function validate_case_form_data(){
	var valid = true

	if ($(".matter_type").is(":checked") == false) {
 		valid = false
 		$('table.error_table').append("<tr class='text-danger'><td><li>Please select one case type</li></td> </tr>");
	}

	if ($(".legal-capacity-radio-input").is(":checked") == false) {
 		valid = false
 		$('table.error_table').append("<tr class='text-danger'><td><li>Legal Capacity must be selected</li></td> </tr>");
	}

	acting_value = $(".matter_type:checked").data('acting2');
	
	next_to_kin_data =  $("#case_firm_is").val();

	if (acting_value == "Next of Kin" && next_to_kin_data == 'acting'){
		if ($("#custom_source_data").val() == ""){
			valid = false
			$('table.error_table').append("<tr class='text-danger'><td><li>Relationship to Deceased must be entered</li></td> </tr>");
		}

		if ( $("#case_next_to_kin_attributes_firstname").val() == ""  ){
			valid = false
			$('table.error_table').append("<tr class='text-danger'><td><li>Next of Kin firstname must be entered</li></td> </tr>");
		}

		if ( $("#case_next_to_kin_attributes_surname").val() == ""  ){
			valid = false
			$('table.error_table').append("<tr class='text-danger'><td><li>Next of Kin surname must be entered</li></td> </tr>");
		}		

		if ( $("#custom_source_data").val() != ""){

    	//var valid_relation = check_relationship_selected_from_drop_down()
    	if (check_relationship_selected_from_drop_down() == false){
    		valid = false
      	$('table.error_table').append("<tr class='text-danger'><td><li>Relationship to Deceased must be selected</li></td> </tr>");
    	}

  	}

	}
	return valid;
}


function check_relationship_selected_from_drop_down(){
  valid = true
  var custom_source_data = $("#custom_source_data").val();
  var is_exist = $('#custom_source [value="' + custom_source_data + '"]').data('relation');
  if (typeof(is_exist) == 'undefined'){
  	valid = false
  }
  return valid
}

$(document).on("click","#case_cancel", function(e) {
	e.preventDefault();
  	e.stopPropagation();
    $("#step1").show();
    $("#step1").removeClass('hidden');
    $('#bereavement_testate').focus();

    $("#step2").hide();
});



$(document).on("click","#order_report_warning_link", function(e) {
	e.preventDefault();
  	e.stopPropagation();
  	$('#order_report_warning_details').modal();
});


