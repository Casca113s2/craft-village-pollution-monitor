package craftvillage.datalayer.entities;
// Generated Mar 10, 2020 9:28:01 AM by Hibernate Tools 4.3.5.Final

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

import craftvillage.corelayer.utilities.ConstantParameter;

/**
 * SrAnswer generated by hbm2java
 */
@Entity
@Table(name = "SR_ANSWER", schema = ConstantParameter._SCHEMA_NAME)
public class SrAnswer implements java.io.Serializable {

	private int answerId;
//	private SrQuestion srQuestion;
	private String answerContent;
	private String answerType;

	public SrAnswer() {
	}

	public SrAnswer(int answerId) {
		this.answerId = answerId;
	}
//
//	public SrAnswer(int answerId, SrQuestion srQuestion, String answerContent, String answerType) {
//		this.answerId = answerId;
//		this.srQuestion = srQuestion;
//		this.answerContent = answerContent;
//		this.answerType = answerType;
//	}

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO, generator="SR_ANSWER_SEQ")
	@Column(name = "ANSWER_ID", unique = true, nullable = false, precision = 22, scale = 0)
	public int getAnswerId() {
		return this.answerId;
	}

	public void setAnswerId(int answerId) {
		this.answerId = answerId;
	}

//	@ManyToOne(cascade = CascadeType.ALL, fetch = FetchType.LAZY)
//	@JoinColumn(name = "QUESTION_ID")
//	public SrQuestion getSrQuestion() {
//		return this.srQuestion;
//	}
//
//	public void setSrQuestion(SrQuestion srQuestion) {
//		this.srQuestion = srQuestion;
//	}

	@Column(name = "ANSWER_CONTENT", length = 100)
	public String getAnswerContent() {
		return this.answerContent;
	}

	public void setAnswerContent(String answerContent) {
		this.answerContent = answerContent;
	}

	@Column(name = "ANSWER_TYPE", length = 40)
	public String getAnswerType() {
		return this.answerType;
	}

	public void setAnswerType(String answerType) {
		this.answerType = answerType;
	}

}