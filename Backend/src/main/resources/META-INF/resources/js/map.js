$("#switch-all").click(function(){
	let checked = $(this).attr("checked");
	$(".switch-input").each(function() {
		$(this).attr("checked", !checked);
	});
});