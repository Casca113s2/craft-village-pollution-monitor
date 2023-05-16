package craftvillage.datalayer.entities.dto;

import java.util.Date;
import craftvillage.datalayer.entities.UserSurvey;

public class PollutionWarningDTO {
  private int villageId;
  private int surveyId;
  private Date date;
  private String villageName;

  private PollutionWarningDTO(UserSurvey userSurvey) {
    this.villageId = userSurvey.getVillage().getVillageId();
    this.surveyId = userSurvey.getId();
    this.date = userSurvey.getDateSubmitSurvey();
    this.villageName = userSurvey.getVillage().getVillageName();
  }

  public static PollutionWarningDTO from(UserSurvey userSurvey) {
    return new PollutionWarningDTO(userSurvey);
  }

  public int getVillageId() {
    return villageId;
  }

  public void setVillageId(int villageId) {
    this.villageId = villageId;
  }

  public int getSurveyId() {
    return surveyId;
  }

  public void setSurveyId(int surveyId) {
    this.surveyId = surveyId;
  }

  public Date getDate() {
    return date;
  }

  public void setDate(Date date) {
    this.date = date;
  }

  public String getVillageName() {
    return villageName;
  }

  public void setVillageName(String villageName) {
    this.villageName = villageName;
  }
}
