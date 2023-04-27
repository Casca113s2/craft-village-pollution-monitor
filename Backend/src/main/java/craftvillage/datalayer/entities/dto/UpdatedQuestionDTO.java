package craftvillage.datalayer.entities.dto;

public class UpdatedQuestionDTO {
  private int questionId;
  private int required;

  public UpdatedQuestionDTO(int questionId, int required) {
    super();
    this.questionId = questionId;
    this.required = required;
  }

  public int getQuestionId() {
    return questionId;
  }

  public void setQuestionId(int questionId) {
    this.questionId = questionId;
  }

  public int getRequired() {
    return required;
  }

  public void setRequired(int required) {
    this.required = required;
  }
}
