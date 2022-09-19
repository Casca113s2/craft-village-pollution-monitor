package craftvillage.datalayer.services;

import java.io.File;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

import org.apache.commons.io.FilenameUtils;
import org.springframework.stereotype.Repository;

import craftvillage.datalayer.dao.CrudDao;
//import craftvillage.datalayer.entities.SrAnswer;
import craftvillage.datalayer.entities.SrImg;
//import craftvillage.datalayer.entities.SrQuestion;
import craftvillage.datalayer.entities.UrUser;
import craftvillage.datalayer.entities.UserSurvey;
import craftvillage.datalayer.entities.UserSurveyAnswer;

@Repository
public class AnswerServ {

	public SrImg findbyFileName(String fileName)
	{
		if (fileName == null)
			return null;
		CrudDao<SrImg> srImgDao = new CrudDao<>(SrImg.class);
		String hql = "SELECT c FROM SrImg c Where c.urImgName = '" + fileName + "'";
		if (srImgDao.queyObject(hql).size() == 0)
			return null;
		else
			return srImgDao.queyObject(hql).get(0);
	}
	public String[] findFileNameById(int userSurveyId)
	{
		String[] filenameList = {null,null,null};
		CrudDao<SrImg> srImgDao = new CrudDao<>(SrImg.class);
		String hql = "SELECT c FROM SrImg c Where c.userSurvey.id = '" + userSurveyId + "'" + "ORDER BY c.id";
		if (srImgDao.queyObject(hql).size() == 0)
			return filenameList;
		else
		{
			int i = 0;
			List<SrImg> srImglst = srImgDao.queyObject(hql);
			for (SrImg x : srImglst)
			{
				filenameList[i] = x.getUrImgName();
				i++;
			}
			return filenameList;
		}
	}
//	public boolean addTemplateAnswer(String content, String type, int questionId) {
//		CrudDao<SrAnswer> answerDao = new CrudDao<SrAnswer>(SrAnswer.class);
//		CrudDao<SrQuestion> questionDao = new CrudDao<SrQuestion>(SrQuestion.class);
//
//		SrAnswer answer = new SrAnswer();
//		answer.setAnswerContent(content);
//		answer.setAnswerType(type);
//		answer.setSrQuestion(questionDao.findById(questionId));
//		
//		boolean check = answerDao.addObject(answer);
//		return check ;
//	}

	public boolean addOrUpdateUserAnswer(UserSurvey userSurvey, int questionId, String answerContent, String otherContent,
			String account) {
		CrudDao<UserSurveyAnswer> userAnswerDao = new CrudDao<>(UserSurveyAnswer.class);
		

		String hql = "SELECT c FROM UserSurveyAnswer c Where c.srSqId = '" + questionId
				+ "' and c.userSurvey.id = '" + userSurvey.getId() + "' and c.userSurvey.urUser.account = '" + account
				+ "'";

		
		UserSurveyAnswer userAnswer = new UserSurveyAnswer();
		
		if (userAnswerDao.queyObject(hql).size() == 0) {
			
			userAnswer.setAnswerContent(answerContent);
			userAnswer.setOtherContent(otherContent);
			userAnswer.setSrSqId(questionId);
			userAnswer.setUserSurvey(userSurvey);

		} else {
			
			userAnswer = userAnswerDao.queyObject(hql).get(0);
			
			userAnswer.setAnswerContent(answerContent);
			userAnswer.setOtherContent(otherContent);
		}
		boolean check = userAnswerDao.addObject(userAnswer);
		return check;
	}
	
	public boolean DeletedAnswer(UrUser user , String status)
	{
		CrudDao<UserSurveyAnswer> userAnswerDao = new CrudDao<>(UserSurveyAnswer.class);
		CrudDao<UserSurvey> userSurveyDao = new CrudDao<>(UserSurvey.class);
		
		String hql1 = "SELECT c FROM UserSurvey c Where c.urUser.id = '" + user.getId()
				+ "' and c.srActive.forRole = '" + user.getType() + "' and c.isTemporary ='" + status + "'";
		UserSurvey userSurvey = userSurveyDao.queyObject(hql1).get(0);
		System.out.println("UserSurvey Id : " + userSurvey.getId());
				
		System.out.println("Deleted Answer Service");
		String sqlDelete = "DELETE FROM UserSurveyAnswer c Where c.userSurvey.id = '" + userSurvey.getId() + "'";
		userAnswerDao.deleteAllByQuery(sqlDelete);
		
		return true;
		
	}
	public boolean DeletedImage(UrUser user , String status , String rootPath)
	{
		CrudDao<SrImg> srImgDao = new CrudDao<>(SrImg.class);
		CrudDao<UserSurvey> userSurveyDao = new CrudDao<>(UserSurvey.class);
		
		String hql1 = "SELECT c FROM UserSurvey c Where c.urUser.id = '" + user.getId()
				+ "' and c.srActive.forRole = '" + user.getType() + "' and c.isTemporary ='" + status + "'";
		UserSurvey userSurvey = userSurveyDao.queyObject(hql1).get(0);
		String hql2 = "SELECT c FROM SrImg c Where c.userSurvey.id = '" + userSurvey.getId() + "'";
		List<SrImg> lst = srImgDao.queyObject(hql2);
		for (SrImg srImg : lst)
		{
			String path = srImg.getUrImgPath();
			
			String filename = srImg.getUrImgPath();			
			File file = new File(rootPath + path + filename);
			file.delete();
			
			String filename_small = FilenameUtils.getBaseName(filename) + "_small.jpg";
			File file_small = new File(rootPath + path + filename_small);
			file_small.delete();
		}
		String sqlDelete = "DELETE FROM SrImg c Where c.userSurvey.id = '" + userSurvey.getId() + "'";
		int i = srImgDao.deleteAllByQuery(sqlDelete);
		int totalImage = userSurvey.getTotalImage();
		System.out.println(">>>>DeletedImage - totalImage - before: " + totalImage);
		if (i>0) {			
			if (totalImage >= i) {
				userSurvey.setTotalImage(totalImage - i);
			}
			else {
				userSurvey.setTotalImage(0);
			}
		}
		boolean check = userSurveyDao.addObject(userSurvey);
		System.out.println(">>>>DeletedImage - totalImage - after: " + userSurvey.getTotalImage());
		return check;
	}
	public boolean DeleteImageByFileName(String filename, String pathFile, UrUser user , String status)
	{
		CrudDao<SrImg> srImgDao = new CrudDao<>(SrImg.class);
		String hql = "SELECT c FROM SrImg c Where c.urImgName = '" + filename + "'";
		SrImg srImg = srImgDao.queyObject(hql).get(0);
		File file = new File(pathFile + srImg.getUrImgName());
		file.delete();
		String sqlDelete = "DELETE FROM SrImg c Where c.urImgName = '" + filename + "'";
		int i = srImgDao.deleteAllByQuery(sqlDelete);
		
		String hql1 = "SELECT c FROM UserSurvey c Where c.urUser.id = '" + user.getId()
		+ "' and c.srActive.forRole = '" + user.getType() + "' and c.isTemporary ='" + status + "'";
		CrudDao<UserSurvey> userSurveyDao = new CrudDao<>(UserSurvey.class);
		UserSurvey userSurvey = userSurveyDao.queyObject(hql1).get(0);
		
		int totalImage = userSurvey.getTotalImage();
		System.out.println(">>>>DeleteImageByFileName - totalImage - before: " + totalImage);		
		if (i>0) {			
			if (totalImage >= i) {
				userSurvey.setTotalImage(totalImage - i);
			}
			else {
				userSurvey.setTotalImage(0);
			}
		}
		boolean check = userSurveyDao.addObject(userSurvey);
		System.out.println(">>>>DeleteImageByFileName - totalImage - after: " + userSurvey.getTotalImage());
		return check;
	}
	
	
	public Set<UserSurveyAnswer> getUserAnswer(int userSurveyid) {
		CrudDao<UserSurveyAnswer> userSurveyAnswerDao = new CrudDao<UserSurveyAnswer>(UserSurveyAnswer.class);
		String hql = "SELECT c FROM UserSurveyAnswer c Where c.userSurvey.id = '" + userSurveyid + "'" + " ORDER BY c.id " ;
		
		
		List<UserSurveyAnswer>  xs = userSurveyAnswerDao.queyObject(hql);
		Set<UserSurveyAnswer> userSurveyAnswers = new LinkedHashSet<>(xs);
		
		return userSurveyAnswers;
	}
	
	public int getNumAnswer(String account, int activeId) {
		CrudDao<UserSurvey> userSurveyDao = new CrudDao<UserSurvey>(UserSurvey.class);
		String hql = "SELECT c FROM UserSurvey c Where c.srActive.id = '" + activeId + "' and c.urUser.account = '"+ account+"'";
		int size = userSurveyDao.queyObject(hql).get(0).getUserSurveyAnswers().size();
		return size ;
	}

}
