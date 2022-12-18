package craftvillage.datalayer.services;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import org.springframework.stereotype.Repository;
import craftvillage.datalayer.dao.CrudDao;
import craftvillage.datalayer.entities.UrRole;
import craftvillage.datalayer.entities.UrUser;
import craftvillage.datalayer.entities.UserSurvey;

@Repository
public class UserServ {

  public UrUser findByAccount(String account) {
    CrudDao<UrUser> userDao = new CrudDao<>(UrUser.class);
    String hql = "SELECT c FROM UrUser c Where c.account = " + "'" + account + "'";
    List<UrUser> lstUser = new ArrayList<UrUser>();
    lstUser = userDao.queyObject(hql);
    if (lstUser.isEmpty() == false) {
      return lstUser.get(0);
    } else {
      return null;
    }
  }

  public boolean emailChecker(String email) {
    CrudDao<UrUser> userDao = new CrudDao<>(UrUser.class);
    String hql = "SELECT c FROM UrUser c Where c.email = " + "'" + email + "'";
    List<UrUser> lstEmail = userDao.queyObject(hql);
    return lstEmail.isEmpty();
  }

  public boolean phoneChecked(String phone) {
    CrudDao<UrUser> userDao = new CrudDao<>(UrUser.class);
    String hql = "SELECT c FROM UrUser c Where c.phone = " + "'" + phone + "'";
    List<UrUser> lstPhone = userDao.queyObject(hql);
    return lstPhone.isEmpty();
  }

  public boolean updateInfo(String account, String urFirstname, String urLastname, String urPhone) {
    CrudDao<UrUser> userDao = new CrudDao<>(UrUser.class);
    if (this.findByAccount(account) != null) {
      UrUser userUpdate = this.findByAccount(account);
      userUpdate.setFirstname(urFirstname);
      userUpdate.setLastname(urLastname);
      userUpdate.setPhone(urPhone);
      boolean check = userDao.addObject(userUpdate);
      return check;
    } else {
      return false;
    }
  }

  public boolean addRole(String account, int roleID) {
    CrudDao<UrRole> roleDao = new CrudDao<UrRole>(UrRole.class);
    CrudDao<UrUser> userDao = new CrudDao<>(UrUser.class);
    UrRole role = roleDao.findById(roleID);
    UrUser user = this.findByAccount(account);
    if (user.getUrRoles().contains(role) || role == null) {
      return false;
    } else {
      user.addRole(role);
      boolean check = userDao.addObject(user);
      return check;
    }
  }

  public boolean removeRole(String account, int roleID) {
    CrudDao<UrRole> roleInfo = new CrudDao<UrRole>(UrRole.class);
    CrudDao<UrUser> userDao = new CrudDao<>(UrUser.class);

    UrRole role = roleInfo.findById(roleID);
    UrUser user = this.findByAccount(account);
    if (user.getUrRoles().contains(role) || role == null) {
      user.removeRole(role);
      boolean check = userDao.addObject(user);
      return check;
    } else {
      return false;
    }
  }

  public UrUser getUser(String account) {
    UrUser user = this.findByAccount(account);
    return user;
  }

  public String getEmailUser(String account) {
    UrUser user = this.findByAccount(account);
    if (user == null)
      return null;
    return user.getEmail();
  }

  public boolean checkEmailUser(String email, String username) {
    String EmailUser = getEmailUser(username);
    if (email.equals(EmailUser))
      return true;
    else
      return false;
  }

  public boolean changeType(String username, String typeUser) {
    CrudDao<UrUser> userDao = new CrudDao<>(UrUser.class);
    UrUser user = this.findByAccount(username);
    user.setType(typeUser);
    return userDao.addObject(user);
  }

  public boolean changePassword(String account, String newPassword) {
    CrudDao<UrUser> userDao = new CrudDao<>(UrUser.class);
    UrUser user = this.findByAccount(account);
    user.setPassword(newPassword);
    boolean check = userDao.addObject(user);
    return check;
  }


  public UrUser getUserData(String account) {
    UrUser user = this.findByAccount(account);
    return user;
  }

  public List<UserSurvey> getSrActiveInfoByStatus(UrUser user, String status) {
    CrudDao<UserSurvey> userSurveyDao = new CrudDao<>(UserSurvey.class);

    String hql = "SELECT c FROM UserSurvey c inner  JOIN c.urUser Where  c.urUser.id = '"
        + user.getId() + "'  and c.isTemporary = '" + status + "' ORDER BY c.dateSubmitSurvey DESC";
    List<UserSurvey> userSurveys = userSurveyDao.queyObject(hql);
    return userSurveys;
  }

  public String getStatus(String account, int activeId) {
    CrudDao<UserSurvey> userSurveyDao = new CrudDao<UserSurvey>(UserSurvey.class);
    String hql = "Select c From UserSurvey c Where c.urUser.account = '" + account
        + "' and c.srActive.id = '" + activeId + "'";
    UserSurvey userSurvey = userSurveyDao.queyObject(hql).get(0);
    return userSurvey.getIsTemporary();
  }

  public boolean AddOrUpdateActiveUser(String ActiveCode, Date ActiveDate, String username) {
    CrudDao<UrUser> userDao = new CrudDao<>(UrUser.class);
    UrUser user = this.findByAccount(username);
    if (user == null)
      return false;
    user.setActiveCode(ActiveCode);
    user.setActiveDate(ActiveDate);
    return userDao.addObject(user);
  }

  public boolean updateType(String username, String type) {
    CrudDao<UrUser> userDao = new CrudDao<>(UrUser.class);
    UrUser user = this.findByAccount(username);
    if (user == null)
      return false;
    user.setType(type);
    return userDao.addObject(user);
  }

  public boolean setDateSubmitSurvey(int userSurveyId, Date dateSubmitSurvey) {
    System.out.println("nghia getSubmitSurvey");
    CrudDao<UserSurvey> userSurveyDao = new CrudDao<>(UserSurvey.class);
    UserSurvey userSurvey = userSurveyDao.findById(userSurveyId);
    userSurvey.setDateSubmitSurvey(dateSubmitSurvey);

    return userSurveyDao.addObject(userSurvey);
  }


  public boolean checkVillage(int villageId, UrUser user, String status) {
    CrudDao<UserSurvey> userSurveyDao = new CrudDao<>(UserSurvey.class);

    String hql = "Select c From UserSurvey c Where c.urUser.account = '" + user.getAccount()
        + "' and c.craftId = '" + villageId + "' and c.srActive.forRole = '" + user.getType()
        + "' and c.isTemporary = '" + status + "'";
    System.out.println(userSurveyDao.queyObject(hql).size());
    if (userSurveyDao.queyObject(hql).size() == 0)
      return true;
    return false;
  }

}
