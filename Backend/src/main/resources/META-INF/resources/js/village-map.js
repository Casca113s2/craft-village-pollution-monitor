function getImage(id){
		$.get("/craftvillage/api/survey/getimage?surveyId=" + id, function(data){
	  		$('#image-container').empty();
	  		$('#image-container').append("<img src='data:image/jpeg;base64,"+ data +"' alt= Picture />");
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