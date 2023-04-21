package craftvillage.ai;

import java.util.List;

public class DataSetDTO {
  private String pollution;
  private List<Question> question;

  public DataSetDTO(String pollution, List<Question> question) {
    super();
    this.pollution = pollution;
    this.question = question;
  }

  public String getPollution() {
    return pollution;
  }

  public List<Question> getQuestion() {
    return question;
  }
}
