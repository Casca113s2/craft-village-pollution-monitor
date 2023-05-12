function downloadDataSet() {
	fetch('/craftvillage/api/dataSet/getAll')
	.then(response => response.json())
	.then(data => {
		const jsonData = JSON.stringify(data);
		const filename = 'dataset.json';
		//console.log(data);

		const blob = new Blob([jsonData], { type: 'application/json' });
		const url = URL.createObjectURL(blob);

		const a = $('<a>', {
			href: url,
			download: filename,
			style: 'display: none'
		}).appendTo('body');

		a[0].click();
		a.remove();

		URL.revokeObjectURL(url);
	})
	.catch(error => {
		console.error('Error:', error);
	});
}

$(document).ready(function() {
	$.get("/craftvillage/api/survey/question", function(data) {
		//console.log(data);
		let QL = ``;
		$('#questionList').empty();
		for(let i=0; i<data.length; i++) {
			QL += `
				<div class="question">
					<label class="question-content">${data[i].questionContent}</label>
					<input class="question-checkbox"
						id="${data[i].id}"
						type="checkbox" 
						name="${data[i].id}" 
						${data[i].required === 1 ? "checked" : ""}
					>
				</div>    
			`
		}
		$('#questionList').append(QL)
	});
});

$('#select-province1').on('change', function() {
  	$.get("/craftvillage/api/address/getdistrictlist?provinceid=" + this.value, function(data){
  		$('#select-district1').empty()
  		for(let i=0;i < data.length; i++){
  			$('#select-district1').append($('<option>',
  					{
	  				    value: data[i].districtId,
	  				    text : data[i].districtName
  					}));
  		}
  	});
});

$('#select-district1').on('change', function() {
  	$.get("/craftvillage/api/address/getwardlist?districtid=" + this.value, function(data){
  		$('#select-ward1').empty()
  		for(let i=0;i < data.length; i++){
  			$('#select-ward1').append($('<option>',
  					{
	  				    value: data[i].wardId,
	  				    text : data[i].wardName
  					}));
  		}
  	});
});

$('#form1').submit(function(e){
	e.preventDefault();
    var form = $(this);
    for (const item of form.serializeArray()){
    	if(item.value == '0' || item.value.length == 0){
    		$('#success-message1').removeClass("display");
    		$('#error-message1').text("Vui lòng điền đầy đủ thông tin!");
    		$('#error-message1').addClass("display");
			return;		    		
    	}
    }
    
    var actionUrl = form.attr('action');
    
    $.ajax({
        type: "POST",
        url: actionUrl,
        data: form.serialize(),
        success: function(data){
        	if(data.key == "1"){
        		$('#success-message1').text(data.message);
        		$('#success-message1').addClass("display");
	    		$('#error-message1').removeClass("display");
        	}
        	else{
	        	$('#success-message1').removeClass("display");
	    		$('#error-message1').text(data.message);
	    		$('#error-message1').addClass("display");
        	}
        }
    });
})

$('#update-question').submit(function(e) {
	e.preventDefault();
	var form = $(this);
	//console.log(form);
	var questions = [];
	form.find('input[type="checkbox"]').each(function() {
		let question_temp = {}
		question_temp.questionId = $(this).attr('name');
		question_temp.required   = ($(this).is(':checked') === true) ? 1 : 0;
		questions.push(question_temp);
	});
	var actionUrl = form.attr('action')
	$.ajax({
        type: "PUT",
        contentType: "application/json; charset=utf-8",
        url: actionUrl,
        data: JSON.stringify(questions),
        success: function(data){
        	if(!data){
                alert("Phát hiện lỗi!")
        	}
        	else{
				location.reload()
                alert("Yêu cầu đã được gửi")
        	}
        }
    });
})

$('#btn-download').on('click', function() {
	downloadDataSet();
});