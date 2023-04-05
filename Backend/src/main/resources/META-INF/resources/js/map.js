$("#switch-all").click(function(){
	let checked = $(this).is(":checked");
	$.each($(".switch-input"), function(index, value) {
		value.checked = checked;
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
	
	var index;

	$(".village-tag").click(function(){
		index = $(this).attr("index");
		let coordinate = villages[index].coordinate;
		$("#ward").val(villages[index].wardId);
		$("#villageName").val(villages[index].villageName);
		$("#longitude").val(coordinate[0]);
		$("#latitude").val(coordinate[1]);
		$("#note").val(villages[index].note);
	});
	
	$("#btn-update").click(function(){
		villages[index].wardId = Number($("#ward").val());
		villages[index].villageName = $("#villageName").val();
		villages[index].coordinate = $("#longitude").val() + ", " + $("#latitude").val();
		villages[index].note = $("#note").val();
		console.log(villages[index]);
	});
});