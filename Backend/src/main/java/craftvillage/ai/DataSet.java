package craftvillage.ai;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import craftvillage.corelayer.utilities.ConstantParameter;

@Entity
@Table(name = "data_set", schema = ConstantParameter._SCHEMA_NAME)
public class DataSet {
  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  @Column(name = "ID")
  private int id;
  @Column(name = "VILLAGE_ID")
  private int villageId;
  @Column(name = "QUESTION_ID")
  private int questionId;
  @Column(name = "QUESTION")
  private String question;
  @Column(name = "ANSWER")
  private String answer;
  @Column(name = "COUNT")
  private int count;

  public int getId() {
    return id;
  }

  public void setId(int id) {
    this.id = id;
  }

  public int getVillageId() {
    return villageId;
  }

  public int getQuestionId() {
    return questionId;
  }

  public void setQuestionId(int questionId) {
    this.questionId = questionId;
  }

  public void setVillageId(int villageId) {
    this.villageId = villageId;
  }

  public String getQuestion() {
    return question;
  }

  public void setQuestion(String question) {
    this.question = question;
  }

  public String getAnswer() {
    return answer;
  }

  public void setAnswer(String answer) {
    this.answer = answer;
  }

  public int getCount() {
    return count;
  }

  public void setCount(int count) {
    this.count = count;
  }
}
