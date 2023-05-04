package craftvillage.ai;

import java.util.List;

public class DetectedDataDTO {
  private int villageId;
  private List<Question> question;

  public DetectedDataDTO(int villageId, List<Question> question) {
    super();
    this.villageId = villageId;
    this.question = question;
  }

  public int getPollution() {
    return villageId;
  }

  public List<Question> getQuestion() {
    return question;
  }
}
