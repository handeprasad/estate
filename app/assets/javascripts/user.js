$(document).on("click","#user_has_legal_authority", function(e) {
	if ($("#user_has_legal_authority").is(":checked") == true) {
		$('#user_introducer_id').prop('disabled', false);
	} else {
		$('#user_introducer_id').prop('disabled', true);
		$('#user_introducer_id').val("")
	}
});