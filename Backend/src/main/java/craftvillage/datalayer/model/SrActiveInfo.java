package craftvillage.datalayer.model;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonPropertyOrder;

@JsonInclude(JsonInclude.Include.NON_NULL)
@JsonPropertyOrder({ "surveyActiveID", "dateActive", "dateEnd","surveyName","surveyId","totalQuestion","totalAnswer","totalImage","villageName","userSurveyId"})
public class SrActiveInfo {
	@JsonProperty("surveyActiveID")
	private int surveyActiveID;
	@JsonProperty("dateActive")
	private Date dateActive;
	@JsonProperty("dateEnd")
	private Date dateEnd;
	
	@JsonProperty("surveyName")
	private String surveyName;
	@JsonProperty("surveyId")
	private int surveyId;
	
	@JsonProperty("totalQuestion")
	private int totalQuestion;
	@JsonProperty("totalAnswer")
	private int totalAnswer;
	@JsonProperty("totalImage")
	private int totalImage;
	@JsonProperty("dateSubmitSurvey")
	private String dateSubmitSurvey;
	@JsonProperty("villageName")
	private String villageName;
	@JsonProperty("userSurveyId")
	private int userSurveyId;
	@JsonProperty("filename")
	private String[] filename;
	@JsonProperty("typeSurvey")
	private String typeSurvey ;
	@JsonProperty("surveyActiveID")
	public int getSurveyActiveID() {
		return surveyActiveID;
	}
	@JsonProperty("surveyActiveID")
	public void setSurveyActiveID(int surveyActiveID) {
		this.surveyActiveID = surveyActiveID;
	}
	@JsonFormat(pattern="dd/MM/yyyy")
	@JsonProperty("dateActive")
	public Date getDateActive() {
		return dateActive;
	}
	@JsonProperty("dateActive")
	public void setDateActive(Date dateActive) {
		this.dateActive = dateActive;
	}
	@JsonFormat(pattern="dd/MM/yyyy")
	@JsonProperty("dateEnd")
	public Date getDateEnd() {
		return dateEnd;
	}
	@JsonProperty("dateEnd")
	public void setDateEnd(Date dateEnd) {
		this.dateEnd = dateEnd;
	}
	
	@JsonProperty("surveyName")
	public String getSurveyName() {
		return surveyName;
	}
	@JsonProperty("surveyName")
	public void setSurveyName(String surveyName) {
		this.surveyName = surveyName;
	}
	@JsonProperty("surveyId")
	public int getSurveyId() {
		return surveyId;
	}
	@JsonProperty("surveyId")
	public void setSurveyId(int surveyId) {
		this.surveyId = surveyId;
	}
	
	@JsonProperty("totalQuestion")
	public int getTotalQuestion() {
		return totalQuestion;
	}
	@JsonProperty("totalQuestion")
	public void setTotalQuestion(int totalQuestion) {
		this.totalQuestion = totalQuestion;
	}
	@JsonProperty("totalAnswer")
	public int getTotalAnswer() {
		return totalAnswer;
	}
	@JsonProperty("totalAnswer")
	public void setTotalAnswer(int totalAnswer) {
		this.totalAnswer = totalAnswer;
	}
	@JsonProperty("totalImage")
	public int getTotalImage() {
		return totalImage;
	}
	@JsonProperty("totalImage")
	public void setTotalImage(int totalImage) {
		this.totalImage = totalImage;
	}
	@JsonProperty("dateSubmitSurvey")
	public String getDateSubmitSurvey() {
		return dateSubmitSurvey;
	}
	@JsonProperty("dateSubmitSurvey")
	public void setDateSubmitSurvey(String dateSubmitSurvey) {
		this.dateSubmitSurvey = dateSubmitSurvey;
	}
	@JsonProperty("villageName")
	public String getVillageName() {
		return villageName;
	}
	@JsonProperty("villageName")
	public void setVillageName(String villageName) {
		this.villageName = villageName;
	}
	@JsonProperty("userSurveyId")
	public int getUserSurveyId() {
		return userSurveyId;
	}
	@JsonProperty("userSurveyId")
	public void setUserSurveyId(int userSurveyId) {
		this.userSurveyId = userSurveyId;
	}
	@JsonProperty("filename")
	public String[] getFilename() {
		return filename;
	}
	@JsonProperty("filename")
	public void setFilename(String[] filename) {
		this.filename = filename;
	}
	@JsonProperty("typeSurvey")
	public String getTypeSurvey() {
		return typeSurvey;
	}
	@JsonProperty("typeSurvey")
	public void setTypeSurvey(String typeSurvey) {
		this.typeSurvey = typeSurvey;
	}
	

}
