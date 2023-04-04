var marker;

function getImage(id){
		//console.log(id);
		$.get("/craftvillage/api/survey/getImage?surveyId=" + id, function(data){
			console.log(data)
	  		$('#image-container').empty();
	  		$('#image-container').append("<img src='data:image/jpeg;base64,"+ data['image'] +"' alt= Picture />");

			$('#date').empty();
	  		$('#date').append(data['date'].slice(0,10));

			$('#pollution').empty();
			pollution_str="";
			if(data['pollution'][0] === '1') pollution_str += "Đất, ";
			if(data['pollution'][1] === '1') pollution_str += "Nước, "
			if(data['pollution'][2] === '1') pollution_str += "Không Khí"
			if(pollution_str[pollution_str.length-2] === ',')
				pollution_str = pollution_str.slice(0, pollution_str.length-2)
	  		$('#pollution').append(pollution_str);
			
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
