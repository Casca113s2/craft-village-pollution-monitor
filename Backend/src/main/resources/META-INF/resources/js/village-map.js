function getImage(id){
		console.log(id);
		$.get("/craftvillage/api/survey/getImage?surveyId=" + id, function(data){
			console.log(data)
	  		$('#image-container').empty();
	  		$('#image-container').append("<img src='data:image/jpeg;base64,"+ data['image'] +"' alt= Picture />");

			$('#date').empty();
	  		$('#date').append(data['date'].slice(0,10));

			$('#pollution').empty();
	  		$('#pollution').append(data['pollution']);
			
			$('#note').empty();
	  		$('#note').append(data['note']);
	  	});
}

$("#btn-previous-image").click(function(){
	let imageIndex = parseInt($("#current-image").text(), 10);
	if(imageIndex > 1) {
		$("#current-image").text(imageIndex - 1);
	}
});

$("#btn-next-image").click(function(){
	let imageIndex = parseInt($("#current-image").text(), 10);
	let totalImage = parseInt($("#total-image").text(), 10);
	if(imageIndex < totalImage) {
		$("#current-image").text(imageIndex + 1);
	}
});

// $('.leaflet-marker-icon').on('click', function(e) {
// 	// Use the event to find the clicked element
// 	var el = $(e.srcElement || e.target),
// 	id = el.attr('id');
// 	console.log(id);
// 	alert('Here is the markers ID: ' + id + '. Use it as you wish.')
// });