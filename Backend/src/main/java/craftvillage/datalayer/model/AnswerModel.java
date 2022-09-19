package craftvillage.datalayer.model;


import java.util.Set;

import craftvillage.datalayer.entities.SrSurvey;
import craftvillage.datalayer.entities.UserSurveyAnswer;

public class AnswerModel {
	private Set<UserSurveyAnswer> answers;
	private SrSurvey surveys;
	private int srActiveId;
	public Set<UserSurveyAnswer> getAnswers() {
		return answers;
	}
	public void setAnswers(Set<UserSurveyAnswer> answers) {
		this.answers = answers;
	}
	public SrSurvey getSurveys() {
		return surveys;
	}
	public void setSurveys(SrSurvey surveys) {
		this.surveys = surveys;
	}
	public int getSrActiveId() {
		return srActiveId;
	}
	public void setSrActiveId(int srActiveId) {
		this.srActiveId = srActiveId;
	}
	

}
