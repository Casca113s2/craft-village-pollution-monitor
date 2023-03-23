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
  fetch("http://localhost:5000/web/household/question")
    .then((res) => res.json())
    .then((data) => {
      console.log(data);
      var question_list = document.querySelector(".question_list");
      questionUI = data.map((item) => {
        var question_label = (item.questionLabel) ? "(" + item.questionLabel + ")" : "";
        if (
          item.questionType === "TextFieldNumber" ||
          item.questionType === "TextField"
        )
          return `
            <div class="question_item question_text-filed">
            <div class="question_content">${item.questionContent} ${question_label}</div>
            ${(() => {
              return item.srSurveyQuestionAnswers
                .map((item2) => {
                  return `
                    <input type = ${item.questionType === "TextFieldNumber" ? "number" : "text"}
                           name = ${item2.id}
                           placeholder = '${item2.answerContent}' />
                  `
                })
                .join("")
            })()}
          </div>
          `;
            
        else if (item.questionType === "RadioCheckBox")
          return `
            <div class="question_item question_radio">
                <div class="question_content">${item.questionContent}</div>
                <ul>
                    ${(() => {
                      return item.srSurveyQuestionAnswers
                        .map((item2) => {
                          return `<li>
                                <input type="radio" name="${item.id}" id="${item2.id}" value="${item2.id}" />
                                <label for="${item2.id}">${item2.answerContent}</label>
                            </li>`;
                        })
                        .join("");
                    })()}
                </ul>
            </div>
            `;

        return `
        <div class="question_item question_checkbox">
        <div class="question_content">${item.questionContent}</div>
        <ul>
        ${(() => {
          return item.srSurveyQuestionAnswers
            .map((item2) => {
              return `<li>
                      <input type="checkbox" name="${item2.id}" id="${item2.id}" value="${item2.id}"/>
                      <label for="${item2.id}">${item2.answerContent}</label>
                  </li>`;
            })
            .join("");
        })()}
        </ul>
      </div>
        `;
      });
      question_list.innerHTML = questionUI.join("");
      render();
    });
}

function submitFormInfo() {
  var form = $("form-new-village").serialize();
  console.log(form)
}