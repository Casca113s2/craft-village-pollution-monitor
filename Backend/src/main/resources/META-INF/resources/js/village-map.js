var marker;

function getImage(id){
		//console.log(id);
		$.get("/craftvillage/api/survey/getImage?surveyId=" + id, function(data){
			//console.log(data)
			//Remove marker before
			if(marker) marker.remove();
			//Marker icon
			var pollution_icon = L.icon({
				iconUrl: "https://chart.apis.google.com/chart?chst=d_map_pin_letter&chld=%E2%80%A2|0B08DF&chf=a,s,ee00FFFF",
				iconSize: [21, 34],
			})
			//console.log(myIcon);
			//Create new marker
			var coordinate = data['coordinate'].split(', ');
			//console.log(coordinate);
			//marker = L.marker([+coordinate[0], +coordinate[1]], {icon: pollution_icon}).addTo(map);
			marker= L.marker([+coordinate[0], +coordinate[1]],{
				icon: pollution_icon,              
			}).addTo(map);
	  		$('#image-container').empty();
	  		$('#image-container').append("<img src='data:image/jpeg;base64,"+ data['image'] +"' alt= Picture />");

			$('#date').empty();
	  		$('#date').append(data['date'].slice(0,10));

			$('#pollution').empty();
			// pollution_str="";
			// if(data['pollution'][0] === '1') pollution_str += "Đất, ";
			// if(data['pollution'][1] === '1') pollution_str += "Nước, "
			// if(data['pollution'][2] === '1') pollution_str += "Không Khí"
			// if(pollution_str[pollution_str.length-2] === ',')
			// 	pollution_str = pollution_str.slice(0, pollution_str.length-2)
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

let QAUI = []
function getQuestionList(id) {
	//console.log(document.getElementById('hsx').textContent)
	fetch("/craftvillage/api/survey/question")
	  .then((res) => res.json())
	  .then((data) => {
		//console.log(data);
		fetch("/craftvillage/api/survey/answerHousehold?householdId="+id)
		.then((res) => res.json())
		.then((data1) => {
		//console.log(data1.length == 0)
		//Khi đã khai báo
		if(data1.length != 0) {
			var question_list = document.querySelector(".question_list");
			questionUI = data.map((item) => {
			var question_label = (item.questionLabel) ? "(" + item.questionLabel + ")" : "";
			if (
			  item.questionType === "TextFieldNumber" ||
			  item.questionType === "TextField"           
			){
			  //console.log(item.srSurveyQuestionAnswers[0].id)
			  var answer = data1.find(function(item1) {
				//console.log(item.srSurveyQuestionAnswers.id)
				//console.log(item1.answerId)
				return item1.answerId === item.srSurveyQuestionAnswers[0].id
			  })
			  //console.log(answer);
			  
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
				  //console.log
				  return item_temp.id === item1.answerId
				})
			  })
			  //console.log(answer);
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
							  //console.log(item2.id === item_temp.answerId)
							  return item2.id === item_temp.answerId
							}) ? "checked" : ""}
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
