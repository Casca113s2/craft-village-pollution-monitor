var acc = document.getElementsByClassName("accordion");
var i;

async function handleSlide() {
    for (i = 0; i < acc.length; i++) {
      acc[i].addEventListener("click", function () {
        this.classList.toggle("active-accordion");
        var panel = this.nextElementSibling;
        if (panel.style.display === "block") {
          panel.style.display = "none";
          panel.style.maxHeight = null;
        } else {
            getQuestionList(() => {
                panel.style.display = "block";
                panel.style.maxHeight = panel.scrollHeight + "px";
            });
            // panel.style.display = "block";
            // panel.style.maxHeight = panel.scrollHeight + "px";
        }
      });
    }
  }
handleSlide();

//get api and logic
let questionUI = [];

function getQuestionList(render) {
  //console.log(document.getElementById('hsx').textContent)
  fetch("/craftvillage/api/survey/question")
    .then((res) => res.json())
    .then((data) => {
      //console.log(data);
      fetch("/craftvillage/api/survey/answer")
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
      render();
    })  
    });
}

// function validateQAForm() {
// const khaibao = document.getElementById('hsx').textContent;
//   const firstname = document.getElementById('firstname').value;
//   const lastname = document.getElementById('lastname').value;
//   const phone = document.getElementById('phone').value;
//   if(khaibao.includes("Chưa khai báo") || typeof firstname === "undefined" || typeof lastname === "undefined" || typeof phone === "undefined") {
//       return false;
//   }
//   return true;
// }