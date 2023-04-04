$("#switch-all").click(function(){
	let checked = $(this).attr("checked");
	$(".switch-input").each(function() {
		$(this).attr("checked", !checked);
	});
});

$( document ).ready(function(){
    for (let i=0; i < villages.length; i++) {
		$("#list-village-body").append(`
			<div class="village-tag" index="${i}">
				<span class="village-field-name">${villages[i].villageName}</span>
				<label class="switch switch-3d switch-primary mr-3" style="margin: auto;">
                  <input type="checkbox" class="switch-input" checked="true">
                  <span class="switch-label"></span>
                  <span class="switch-handle"></span>
                </label>
			</div>
		`);
	}
});

$(".village-tag").each(function(){
     $(this).click(function(){
		
	});
});