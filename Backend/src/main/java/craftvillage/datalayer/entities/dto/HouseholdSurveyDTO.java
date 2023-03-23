package craftvillage.datalayer.entities.dto;

import craftvillage.datalayer.entities.HouseholdSurvey;

public class HouseholdSurveyDTO {

  private int id;
  private String answerContent;
  private int answerId;

  public HouseholdSurveyDTO(HouseholdSurvey householdSurvey) {
    this.id = householdSurvey.getId();
    this.answerContent = householdSurvey.getAnswerContent();
    this.answerId = householdSurvey.getSrSurveyQuestionAnswer().getId();
  }

  public static HouseholdSurveyDTO from(HouseholdSurvey householdSurvey) {
    return new HouseholdSurveyDTO(householdSurvey);
  }

  public int getId() {
    return id;
  }

  public void setId(int id) {
    this.id = id;
  }

  public String getAnswerContent() {
    return answerContent;
  }

  public void setAnswerContent(String answerContent) {
    this.answerContent = answerContent;
  }

  public int getAnswerId() {
    return answerId;
  }

  public void setAnswerId(int answerId) {
    this.answerId = answerId;
  }
}
