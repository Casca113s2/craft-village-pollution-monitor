package craftvillage.ai;

import java.util.List;

public class Question {
  private String content;
  private List<Answer> answer;

  public Question(String content, List<Answer> answer) {
    super();
    this.content = content;
    this.answer = answer;
  }

  public String getContent() {
    return content;
  }

  public List<Answer> getAnswer() {
    return answer;
  }
}
