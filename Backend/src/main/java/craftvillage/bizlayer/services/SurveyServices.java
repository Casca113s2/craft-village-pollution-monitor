package craftvillage.bizlayer.services;

import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.json.JSONException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import craftvillage.datalayer.entities.AdProvince;
import craftvillage.datalayer.entities.SrActive;
//import craftvillage.datalayer.entities.SrQuestion;
import craftvillage.datalayer.entities.SrSurvey;
import craftvillage.datalayer.entities.SrSurveyQuestion;
import craftvillage.datalayer.entities.UrUser;
import craftvillage.datalayer.entities.UserSurvey;
import craftvillage.datalayer.entities.UserSurveyAnswer;
import craftvillage.datalayer.services.AddressServ;
import craftvillage.datalayer.services.AnswerServ;
import craftvillage.datalayer.services.QuestionServ;
import craftvillage.datalayer.services.SurveyServ;
import craftvillage.datalayer.services.UserServ;

@Service
public class SurveyServices {

	@Autowired
	SurveyServ surveyServ = new SurveyServ();
	@Autowired
	UserServ userServ = new UserServ();
	@Autowired
	AnswerServ answerServ = new AnswerServ();
	@Autowired
	QuestionServ questionServ = new QuestionServ();
	
	public boolean AddSurvey(String campainName, String campainGoal, int urUserID) {

		if (surveyServ.addTemplateSurvey(campainName, campainGoal, urUserID))
			return true;
		return false;
	}

	public Set<SrSurvey> getUserSurvey(String account) {
		return userServ.getUserSurvey(account);
	}

	public SrSurvey getSurveyByActiveId(int activeId) {
		return surveyServ.getSurveyByActiveId(activeId);
	}

	public boolean addUrAnswer(UserSurvey userSurvey, int questionId, String answerContent, String otherContent,String account) {
		return answerServ.addOrUpdateUserAnswer(userSurvey, questionId, answerContent, otherContent,account);
	}
	
	public boolean DeletedAnswer(UrUser user , String status)
	{
		return answerServ.DeletedAnswer(user , status);
	}
	
	public UserSurvey getSubmitSurvey(String account , int activeId) {
		return surveyServ.getSubmitSurvey(account, activeId);
	}
	
	public UserSurvey getUserSurvey(UrUser user , String status)
	{
		return surveyServ.getUserSurvey(user, status);
	}
	
	public UserSurvey getUserSurveyById(int userSurveyId)
	{
		return surveyServ.getUserSurveyById(userSurveyId);
	}
	
	public boolean addUserSurvey(UserSurvey userSurvey)
	{
		return surveyServ.addUserSurvey(userSurvey);
	}
	
	public Set<SrActive> getSrActiveInfo(String account, String status , String for_Role) {
		return userServ.getSrActiveInfo(account, status , for_Role);
	}
	
	public List<UserSurvey> getSrActiveInfoByStatus(UrUser user , String status)
	{
		return userServ.getSrActiveInfoByStatus(user, status);
	}
	
	public Set<UserSurveyAnswer> getUserAnswer(int userSurveyId) {
		return answerServ.getUserAnswer(userSurveyId);
	}

	public SrSurveyQuestion getQuestions(int questionID) {
		return questionServ.getQuestion(questionID);
	}

	public boolean changeStatus(int idUserSurvey ,String newStatus) {
		return surveyServ.changeStatus(idUserSurvey ,newStatus);
	}
	
	public int getNumAnswer(String account, int activeId)
	{
		return answerServ.getNumAnswer(account, activeId);
	}
	
	public String  getStatus(String account, int activeId)
	{
		return userServ.getStatus(account, activeId);
	}

	public SrSurvey getSurveyByCode(String code) {
		// TODO Auto-generated method stub
		return surveyServ.getSurveyByCode(code);
	}
	public Set<SrActive> getSurveyByStatus(String isTemporary){
		return userServ.getSrActiveByStatus(isTemporary);
	}
	
	public SrActive getSurveyActive(int activeId)
	{
		return surveyServ.getSurveyActive(activeId);
	}
	
	public boolean addUserSurvey(String username)
	{
		return userServ.addUserSurvey(username);
	}
	
	public boolean addUserSurveyById(String username , int srActiveId)
	{
		return userServ.addUserSurveyById(username, srActiveId);
	}
	
	public boolean setDateSubmitSurvey (int userSurveyId , Date dateSubmitSurvey)
	{
		return userServ.setDateSubmitSurvey(userSurveyId, dateSubmitSurvey);
	}
	
}
