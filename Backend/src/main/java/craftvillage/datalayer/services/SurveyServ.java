package craftvillage.datalayer.services;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;

import org.springframework.stereotype.Repository;

import craftvillage.datalayer.dao.CrudDao;
import craftvillage.datalayer.entities.SrActive;
import craftvillage.datalayer.entities.SrAnswer;
//import craftvillage.datalayer.entities.SrQuestion;
import craftvillage.datalayer.entities.SrSurvey;
import craftvillage.datalayer.entities.SrSurveyQuestion;
import craftvillage.datalayer.entities.SrSurveyQuestionAnswer;
import craftvillage.datalayer.entities.UrUser;
import craftvillage.datalayer.entities.UserSurvey;
import net.bytebuddy.asm.Advice.This;

@Repository

public class SurveyServ {
	UserServ userSev = new UserServ();
	public List<SrSurvey> getSurveyByStatus(String isTemporary) {
		CrudDao<SrSurvey> surveyDao = new CrudDao<>(SrSurvey.class);
		String hql = "SELECT c FROM SrSurvey c Where c.isTemporary = " + "'" + isTemporary + "'";
		List<SrSurvey> lstSurvey = surveyDao.queyObject(hql);
		return lstSurvey;
	}

	/**
	 * create a template survey
	 * 
	 * @param campainName
	 *            Survey Name
	 * @param campainGoal
	 *            Survey goal
	 * @param userIdCreate
	 *            creator id
	 * @return
	 */
	public boolean addTemplateSurvey(String campainName, String campainGoal, int userIdCreate) {
		CrudDao<SrSurvey> surveyDao = new CrudDao<SrSurvey>(SrSurvey.class);
		LocalDateTime localDateTime = LocalDateTime.now();
		Date date = Date.from(localDateTime.atZone(ZoneId.systemDefault()).toInstant());
		SrSurvey survey = new SrSurvey();
		survey.setCampainName(campainName);
		survey.setCampainGoal(campainGoal);
		survey.setDateCreate(date);
		survey.setUserIdCreate(userIdCreate);
		survey.setSurveyCode("SR" + campainName.charAt(1) + campainGoal.charAt(2) + userIdCreate);
		boolean check = surveyDao.addObject(survey);
		return check;
	}

	public boolean activeSurvey(int surveyId, Date dateEnd, String describe) {
		CrudDao<SrSurvey> surveyDao = new CrudDao<SrSurvey>(SrSurvey.class);
		CrudDao<SrActive> activeSurvey = new CrudDao<SrActive>(SrActive.class);
		SrActive activation = new SrActive();
		LocalDateTime localDateTime = LocalDateTime.now();
		Date date = Date.from(localDateTime.atZone(ZoneId.systemDefault()).toInstant());
		activation.setDateActive(date);
		activation.setDateEnd(dateEnd);
		activation.setDescribe(describe);
		activation.setIsActive("Activated");
		activation.setSrSurvey(surveyDao.findById(surveyId));
		boolean check = activeSurvey.addObject(activation);
		return check;
	}

	public SrSurvey getSurveyByActiveId(int activeId) {
		CrudDao<SrActive> surveyDao = new CrudDao<SrActive>(SrActive.class);
		SrSurvey survey = surveyDao.findById(activeId).getSrSurvey();
		return survey;
	}

	public UserSurvey getSubmitSurvey(String account, int activeId) {
		System.out.println("nghia getSubmitSurvey");
		CrudDao<UserSurvey> userSurveyDao = new CrudDao<>(UserSurvey.class);
		UserServ userSev = new UserServ();
		UrUser user = userSev.findByAccount(account);
		String hql = "Select c From UserSurvey c Where c.urUser.id = '" + user.getId() + "' and c.srActive = '"
				+ activeId + "'";
		UserSurvey userSurvey = userSurveyDao.queyObject(hql).get(0);
		return userSurvey;
	}
	public boolean addUserSurvey(UserSurvey userSurvey)
	{
		System.out.print("addUserSurvey");
		CrudDao<UserSurvey> userSurveyDao = new CrudDao<>(UserSurvey.class);
//		UserSurvey tempUserSurvey = new UserSurvey();
//		String hql = "SELECT c FROM UserSurvey c Where c.UserSurvey.id = '" + userSurvey.getId()
//				+ "'";
//		if (userSurveyDao.queyObject(hql).size() == 0)
//		{
//			userSurveyDao.addObject(userSurvey);
//		}
//		else
//		{
//			tempUserSurvey = userSurveyDao.queyObject(hql).get(0);
//			tempUserSurvey.setTotalQuestion(userSurvey.getTotalQuestion());
//			tempUserSurvey.setTotalAnswer(userSurvey.getTotalAnswer());
//			tempUserSurvey.setTotalImage(userSurvey.getTotalImage());
//		}
		boolean check = userSurveyDao.addObject(userSurvey);
		return check;
	}

	public Set<SrActive> getSurveyActiveInfo(String account, String for_role) {
		CrudDao<UserSurvey> userSurveyDao = new CrudDao<>(UserSurvey.class);
		String hql = "Select c From UserSurvey c Where c.urUser.account = '" + account + "' and c.srActive.forRole ='"+for_role+"'";
		List<UserSurvey> userSurveys = userSurveyDao.queyObject(hql);
		Set<SrActive> actives = new HashSet<>();
		for (UserSurvey x : userSurveys) {
			actives.add(x.getSrActive());
		}
		return actives;
	}

	public boolean changeStatus(int idUserSurvey ,  String newStatus) {
		CrudDao<UserSurvey> userSurveyDao = new CrudDao<>(UserSurvey.class);
		String hql = "Select c From UserSurvey c Where c.id = '" + idUserSurvey + "'";
		UserSurvey userSurvey = userSurveyDao.queyObject(hql).get(0);
		userSurvey.setIsTemporary(newStatus);
		boolean check = userSurveyDao.addObject(userSurvey);
		return check;
	}
	
	public SrSurvey getSurveyByCode(String code){
		CrudDao<SrSurvey> surveyDao = new CrudDao<SrSurvey>(SrSurvey.class);
		String hql = "Select c From SrSurvey c Where c.surveyCode ='"+code+"'";
		SrSurvey survey = surveyDao.queyObject(hql).get(0);
		return survey;
	}
	
	public Set<SrSurveyQuestion> getChildQuestion(String answerId) {
		CrudDao<SrSurveyQuestionAnswer> answerDao = new CrudDao<SrSurveyQuestionAnswer>(SrSurveyQuestionAnswer.class);
		String hql = "Select c From SrSurveyQuestionAnswer c Where c.Id = '"+answerId+"'";
		SrSurveyQuestionAnswer answer = answerDao.queyObject(hql).get(0);
		return answer.getSrSurveyQuestions();
	}
	public boolean setNewSurvey(String account) {

		return true;
	}
	public SrActive getSurveyActive(int activeId)
	{
		CrudDao<SrActive> srActiveDao = new CrudDao<SrActive>(SrActive.class);
		SrActive surveyActive = srActiveDao.findById(activeId);
		return surveyActive;
	}
	
	public UserSurvey getUserSurvey(UrUser user , String status)
	{
		CrudDao<UserSurvey> userSurveyDao = new CrudDao<>(UserSurvey.class);
		String hql1 = "SELECT c FROM UserSurvey c inner  JOIN c.urUser Where  c.urUser.id = '" + user.getId()
		 + "' and c.srActive.forRole = '"  + user.getType() + "'  and c.isTemporary = '"  + status + "'";
		//System.out.println("Size :" + userSurveyDao.queyObject(hql1).size());
		System.out.println("Type :" + user.getType());
		System.out.println("Status :" + status);
		System.out.println("hql1 : " + hql1 );
		if (userSurveyDao.queyObject(hql1).size() == 0)
		{
			return null;
		}
		UserSurvey userSurvey = userSurveyDao.queyObject(hql1).get(0);
		return userSurvey;
	}
	public UserSurvey getUserSurveyById(int userSurveyId)
	{
		CrudDao<UserSurvey> userSurveyDao = new CrudDao<>(UserSurvey.class);
		return userSurveyDao.findById(userSurveyId);
	}
}
