package craftvillage.ai;

import java.util.List;

public class Question {
  private int questionId;
  private String content;
  private List<Answer> answer;

  public Question(int questionId, String content, List<Answer> answer) {
    super();
    this.questionId = questionId;
    this.content = content;
    this.answer = answer;
  }

  public int getQuestionId() {
    return questionId;
  }

  public void setQuestionId(int questionId) {
    this.questionId = questionId;
  }

  public String getContent() {
    return content;
  }

  public void setContent(String content) {
    this.content = content;
  }

  public List<Answer> getAnswer() {
    return answer;
  }

  public void setAnswer(List<Answer> answer) {
    this.answer = answer;
  }
}
