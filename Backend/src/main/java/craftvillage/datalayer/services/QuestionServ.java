package craftvillage.datalayer.services;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;

import org.springframework.stereotype.Repository;

import craftvillage.datalayer.dao.CrudDao;
//import craftvillage.datalayer.entities.SrQuestion;
import craftvillage.datalayer.entities.SrSurvey;
import craftvillage.datalayer.entities.SrSurveyQuestion;

@Repository
public class QuestionServ {
	
//	public boolean addTemplateQuestion(String content, String type) {
//		CrudDao<SrQuestion> questionDao = new CrudDao<SrQuestion>(SrQuestion.class);
//		SrQuestion question = new SrQuestion();
//		question.setContent(content);
//		question.setType(type);
//		boolean check = questionDao.addObject(question);
//		return check;
//	}

//	public boolean insertQuestionToSurvey(int surveyId, int questionId) {
//		CrudDao<SrSurvey> surveyDao = new CrudDao<SrSurvey>(SrSurvey.class);
//		CrudDao<SrQuestion> questionDao = new CrudDao<SrQuestion>(SrQuestion.class);
//		CrudDao<SrSurveyQuestion> surveyQuestionDao = new CrudDao<SrSurveyQuestion>(SrSurveyQuestion.class);
//		SrSurveyQuestion sq = new SrSurveyQuestion();
//		sq.setSrSurvey(surveyDao.findById(surveyId));
//		sq.setSrQuestion(questionDao.findById(questionId));
//		boolean check = surveyQuestionDao.addObject(sq);
//		return check;
//	}

	public boolean insertQuestionToSurvey(SrSurvey survey, String content, String type) {
		CrudDao<SrSurveyQuestion> surveyQuestionDao = new CrudDao<SrSurveyQuestion>(SrSurveyQuestion.class);
		SrSurveyQuestion sq = new SrSurveyQuestion();
		sq.setSrSurvey(survey);
		sq.setQuestionContent(content);
		sq.setQuestionType(type);
		boolean check = surveyQuestionDao.addObject(sq);
		return check;

	}

	public SrSurveyQuestion getQuestion(int questionId) {
		CrudDao<SrSurveyQuestion> questionDao = new CrudDao<SrSurveyQuestion>(SrSurveyQuestion.class);
		SrSurveyQuestion question = questionDao.findById(questionId);
		return question ;
	}
}
