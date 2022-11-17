package craftvillage.datalayer.entities;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import com.fasterxml.jackson.annotation.JsonBackReference;
import craftvillage.corelayer.utilities.ConstantParameter;

@Entity
@Table(name = "HOUSEHOLD_SURVEY", schema = ConstantParameter._SCHEMA_NAME)
public class HouseholdSurvey {

  private Integer id;
  private String answerContent;
  private UrUser household;
  private SrSurveyQuestion question;

  @Id
  @GeneratedValue(strategy = GenerationType.AUTO)
  @Column(name = "ID", unique = true, nullable = false, precision = 22, scale = 0)
  public Integer getId() {
    return id;
  }

  public void setId(Integer id) {
    this.id = id;
  }

  @Column(name = "ANSWER_CONTENT")
  public String getAnswerContent() {
    return answerContent;
  }

  public void setAnswerContent(String answerContent) {
    this.answerContent = answerContent;
  }

  @JsonBackReference
  @ManyToOne(cascade = CascadeType.ALL, fetch = FetchType.LAZY)
  @JoinColumn(name = "HOUSEHOLD")
  public UrUser getHousehold() {
    return household;
  }

  public void setHousehold(UrUser household) {
    this.household = household;
  }

  @JsonBackReference
  @ManyToOne(cascade = CascadeType.ALL, fetch = FetchType.LAZY)
  @JoinColumn(name = "SR_SQ_ID")
  public SrSurveyQuestion getQuestion() {
    return question;
  }

  public void setQuestion(SrSurveyQuestion question) {
    this.question = question;
  }
}
