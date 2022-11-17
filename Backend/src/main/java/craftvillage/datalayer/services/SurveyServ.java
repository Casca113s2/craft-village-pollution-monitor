package craftvillage.datalayer.services;

import org.springframework.stereotype.Repository;
import craftvillage.datalayer.dao.CrudDao;
import craftvillage.datalayer.entities.UrUser;
import craftvillage.datalayer.entities.UserSurvey;

@Repository
public class SurveyServ {
  UserServ userSev = new UserServ();

  public UserSurvey getSubmitSurvey(String account, int activeId) {
    System.out.println("nghia getSubmitSurvey");
    CrudDao<UserSurvey> userSurveyDao = new CrudDao<>(UserSurvey.class);
    UserServ userSev = new UserServ();
    UrUser user = userSev.findByAccount(account);
    String hql = "Select c From UserSurvey c Where c.urUser.id = '" + user.getId()
        + "' and c.srActive = '" + activeId + "'";
    UserSurvey userSurvey = userSurveyDao.queyObject(hql).get(0);
    return userSurvey;
  }

  public boolean addUserSurvey(UserSurvey userSurvey) {
    CrudDao<UserSurvey> userSurveyDao = new CrudDao<>(UserSurvey.class);
    boolean check = userSurveyDao.addObject(userSurvey);
    return check;
  }

  public boolean changeStatus(int idUserSurvey, String newStatus) {
    CrudDao<UserSurvey> userSurveyDao = new CrudDao<>(UserSurvey.class);
    String hql = "Select c From UserSurvey c Where c.id = '" + idUserSurvey + "'";
    UserSurvey userSurvey = userSurveyDao.queyObject(hql).get(0);
    userSurvey.setIsTemporary(newStatus);
    boolean check = userSurveyDao.addObject(userSurvey);
    return check;
  }

  public boolean setNewSurvey(String account) {

    return true;
  }

  public UserSurvey getUserSurvey(UrUser user, String status) {
    CrudDao<UserSurvey> userSurveyDao = new CrudDao<>(UserSurvey.class);
    String hql1 = "SELECT c FROM UserSurvey c inner  JOIN c.urUser Where  c.urUser.id = '"
        + user.getId() + "' and c.srActive.forRole = '" + user.getType()
        + "'  and c.isTemporary = '" + status + "'";
    if (userSurveyDao.queyObject(hql1).size() == 0) {
      return null;
    }
    UserSurvey userSurvey = userSurveyDao.queyObject(hql1).get(0);
    return userSurvey;
  }

  public UserSurvey getUserSurveyById(int userSurveyId) {
    CrudDao<UserSurvey> userSurveyDao = new CrudDao<>(UserSurvey.class);
    return userSurveyDao.findById(userSurveyId);
  }
}
