function getImage(id){
		$.get("/craftvillage/api/survey/getImage?surveyId=" + id, function(data){
			console.log(data['warning'] === true);
			//Remove marker before
			if(map.hasLayer(markerImagePollution)) map.removeLayer(markerImagePollution);
			if(map.hasLayer(markerWarning)) map.removeLayer(markerWarning);
			//Marker icon
			var pollution_icon = L.icon({
				iconUrl: "https://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|0B08DF&chf=a,s,ee00FFFF",
				iconSize: [21, 34],
			})
			var warning_icon = L.icon({
				iconUrl: "https://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|FFD700&chf=a,s,ee00FFFF",
				iconSize: [21, 34],
			})
			//Create new marker
			var coordinate = data['coordinate'].split(', ');
			//marker = L.marker([+coordinate[0], +coordinate[1]], {icon: pollution_icon}).addTo(map);
			markerImagePollution= L.marker([+coordinate[1], +coordinate[0]],{
				icon: (data['warning'] === false) ? pollution_icon :  warning_icon            
			}).addTo(map);
	  		$('#image-container').empty();
	  		$('#image-container').append("<img src='data:image/jpeg;base64,"+ data['image'] +"' alt= Picture style='object-fit:cover' />");

			$('#date').empty();
	  		$('#date').append(data['date'].slice(0,10));

			$('#pollution').empty();
	  		$('#pollution').append(data['pollution']);
			
			$('#note').empty();
	  		$('#note').append(data['note']);

			if(data['warning'] === true) $('#warning').show();
			else $('#warning').hide();
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

let QAUI = []
function getQuestionList(id) {
	fetch("/craftvillage/api/survey/question")
	  .then((res) => res.json())
	  .then((data) => {
		fetch("/craftvillage/api/survey/answerHousehold?householdId="+id)
		.then((res) => res.json())
		.then((data1) => {
		//Khi đã khai báo
		if(data1.length != 0) {
			var question_list = document.querySelector(".question_list");
			questionUI = data.map((item) => {
			var question_label = (item.questionLabel) ? "(" + item.questionLabel + ")" : "";
			if (
			  item.questionType === "TextFieldNumber" ||
			  item.questionType === "TextField"           
			){
			  let answer = data1.find(function(item1) {
				return item1.answerId === item.srSurveyQuestionAnswers[0].id
			  })
			  
			  return `
				<div class="question_item question_text-filed">
				<div class="question_content">${item.questionContent} ${question_label}</div>
				${(() => {
				  return item.srSurveyQuestionAnswers
					.map((item2) => {
					  return `
						<input type = ${(item.questionType === "TextFieldNumber" ? "number" : "text")}
							  name = t${item2.id}
							  placeholder = '${item.questionType === "TextFieldNumber" ? "" : item2.answerContent}' 
							  value = '${typeof answer === "undefined" ? "" : answer.answerContent}' 
							  disabled      
						/>
					  `
					})
					.join("")
				})()}
			  </div>
			  `;
			}   
			else if (item.questionType === "RadioCheckBox"){
			  var answer = data1.find(function(item1) {
				return item.srSurveyQuestionAnswers.find(function(item_temp) {
				  return item_temp.id === item1.answerId
				})
			  })

			  return `
				<div class="question_item question_radio">
					<div class="question_content">${item.questionContent}</div>
					<ul>
						${(() => {
						  return item.srSurveyQuestionAnswers
							.map((item2) => {
							  return `<li>
									<input 
									  type="radio" 
									  name="${item.id}" 
									  id="${item2.id}" 
									  value="${item2.id}" 
									  ${typeof answer !== "undefined" ? (item2.id === answer.answerId ? "checked" : "") : ""}
									  disabled
									/>
									<label for="${item2.id}">${item2.answerContent}</label>
								</li>`;
							})
							.join("");
						})()}
					</ul>
				</div>
				`;
			}
			
			var answer = data1.filter(function(item1) {
			  return item.srSurveyQuestionAnswers.find(function(item_temp) {
				return item_temp.id === item1.answerId
			  })
			})
			return `
			<div class="question_item question_checkbox">
			<div class="question_content">${item.questionContent}</div>
			<ul>
			${(() => {
			  return item.srSurveyQuestionAnswers
				.map((item2) => {
				  return `<li>
						  <input 
							type="checkbox" 
							name="${item2.id}" 
							id="${item2.id}" 
							value="${item2.id}"
							${answer.find(function(item_temp) {
							  return item2.id === item_temp.answerId
							}) ? "checked" : ""}
							disabled
						  />
						  <label for="${item2.id}">${item2.answerContent}</label>
					  </li>`;
				})
				.join("");
			})()}
			</ul>
		  </div>
			`;
		  });       
		}
  
  
		//##### Khi chưa khai báo gì cả #####
		else {
		  var question_list = document.querySelector(".question_list");
			questionUI = data.map((item) => {
			var question_label = (item.questionLabel) ? "(" + item.questionLabel + ")" : "";
			if (
			  item.questionType === "TextFieldNumber" ||
			  item.questionType === "TextField"           
			){
  
			  
			  return `
				<div class="question_item question_text-filed">
				<div class="question_content">${item.questionContent} ${question_label}</div>
				${(() => {
				  return item.srSurveyQuestionAnswers
					.map((item2) => {
					  return `
						<input type = ${(item.questionType === "TextFieldNumber" ? "number" : "text")}
							  name = t${item2.id}
							  placeholder = '${item.questionType === "TextFieldNumber" ? "" : item2.answerContent}'
							  disabled       
						/>
					  `
					})
					.join("")
				})()}
			  </div>
			  `;
			}   
			else if (item.questionType === "RadioCheckBox"){
			  return `
				<div class="question_item question_radio">
					<div class="question_content">${item.questionContent}</div>
					<ul>
						${(() => {
						  return item.srSurveyQuestionAnswers
							.map((item2) => {
							  return `<li>
									<input 
									  type="radio" 
									  name="${item.id}" 
									  id="${item2.id}" 
									  value="${item2.id}" 
									  disabled
									/>
									<label for="${item2.id}">${item2.answerContent}</label>
								</li>`;
							})
							.join("");
						})()}
					</ul>
				</div>
				`;
			}
			
			return `
			<div class="question_item question_checkbox">
			<div class="question_content">${item.questionContent}</div>
			<ul>
			${(() => {
			  return item.srSurveyQuestionAnswers
				.map((item2) => {
				  return `<li>
						  <input 
							type="checkbox" 
							name="${item2.id}" 
							id="${item2.id}" 
							value="${item2.id}"
							disabled
						  />
						  <label for="${item2.id}">${item2.answerContent}</label>
					  </li>`;
				})
				.join("");
			})()}
			</ul>
		  </div>
			`;
		  }); 
		}
		
		question_list.innerHTML = questionUI.join("")
		//render();
	  })  
	  });
  }
