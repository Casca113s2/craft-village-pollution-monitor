package craftvillage.datalayer.model;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonPropertyOrder;

@JsonInclude(JsonInclude.Include.NON_NULL)
@JsonPropertyOrder({ "answerContent", "questionID", "otherContent" })
public class AnswerSubmit {

	@JsonProperty("answerContent")
	private String answerContent;
	 @JsonProperty("activeId")
	 private int activeId;
	@JsonProperty("questionID")
	private int questionID;
	@JsonProperty("otherContent")
	private String otherContent;
	@JsonProperty("answerContent")
	
	public String getAnswerContent() {
		return answerContent;
	}

	@JsonProperty("answerContent")
	public void setAnswerContent(String answerContent) {
		this.answerContent = answerContent;
	}

	 @JsonProperty("activeId")
	 public int getactiveId() {
	 return activeId;
	 }

	 @JsonProperty("activeId")
	 public void setactiveId(int activeId) {
	 this.activeId = activeId;
	 }

	@JsonProperty("questionID")
	public int getQuestionID() {
		return questionID;
	}

	@JsonProperty("questionID")
	public void setQuestionID(int questionID) {
		this.questionID = questionID;
	}

	@JsonProperty("otherContent")
	public String getOtherContent() {
		return otherContent;
	}

	@JsonProperty("otherContent")
	public void setOtherContent(String otherContent) {
		this.otherContent = otherContent;
	}

}
