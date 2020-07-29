$(document).on("hidden.bs.modal","#add_note", function(event) {
  $(this).find('form').trigger('reset');
  $('#error_div').empty();
});

$(document).on('change', '.custom-file-input', function (event) {
    $(this).next('.custom-file-label').html(event.target.files[0].name);
    $("#upload").focus();
});

$(document).on('shown.bs.modal','#add_note', function () {
	$("#audit_log_note").focus();
})

$(document).on('shown.bs.modal','#edit_note', function () {
	 $(this).find('#audit_log_note').focus();
})

$(document).on("click",".included_in_ins_checkbox", function(e) {
  document_id = $(this).data("document-id");
  url = "/admin/documents/" + document_id + "/toggle_included";
  $.ajax({
    dataType: 'script',
    type: 'get',
    url: url
  });

});
