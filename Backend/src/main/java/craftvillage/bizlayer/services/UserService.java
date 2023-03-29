package craftvillage.bizlayer.services;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import craftvillage.datalayer.entities.UrRole;
import craftvillage.datalayer.entities.UrUser;
import craftvillage.datalayer.entities.Village;
import craftvillage.datalayer.repositories.RoleRepository;
import craftvillage.datalayer.repositories.UserRepository;
import craftvillage.datalayer.repositories.VillageRepository;

@Service
public class UserService {
  @Autowired
  private UserRepository userRepo;

  @Autowired
  RoleRepository roleRepo;

  @Autowired
  VillageRepository villageRepo;

  public UrUser save(UrUser user) {
    return userRepo.save(user);
  }

  public UrUser findByUsername(String username) {
    return userRepo.findByAccount(username);
  }

  public boolean emailChecker(String email) {
    return userRepo.findByEmail(email) == null ? true : false;
  }

  public boolean phoneChecked(String phone) {
    return userRepo.findByPhone(phone) == null ? true : false;
  }

  public boolean updateInfo(String account, String urFirstname, String urLastname, String urPhone) {
    if (this.findByUsername(account) != null) {
      UrUser userUpdate = this.findByUsername(account);
      userUpdate.setFirstname(urFirstname);
      userUpdate.setLastname(urLastname);
      userUpdate.setPhone(urPhone);
      if (userRepo.save(userUpdate) != null) {
        return true;
      }
    }
    return false;
  }

  public boolean addRole(String account, int roleID) {
    UrRole role = roleRepo.getOne(roleID);
    UrUser user = this.findByUsername(account);
    if (user.getUrRoles().contains(role) || role == null) {
      return false;
    } else {
      user.addRole(role);
      return userRepo.save(user) != null ? true : false;
    }
  }

  public UrUser getUser(String account) {
    UrUser user = this.findByUsername(account);
    return user;
  }

  public String getEmailUser(String account) {
    UrUser user = this.findByUsername(account);
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

  public boolean changePassword(String account, String newPassword) {
    UrUser user = this.findByUsername(account);
    user.setPassword(newPassword);
    return userRepo.save(user) != null ? true : false;
  }


  public UrUser getUserData(String account) {
    UrUser user = this.findByUsername(account);
    return user;
  }

  public boolean AddOrUpdateActiveUser(String ActiveCode, Date ActiveDate, String username) {
    UrUser user = this.findByUsername(username);
    if (user == null)
      return false;
    user.setActiveCode(ActiveCode);
    user.setActiveDate(ActiveDate);
    return userRepo.save(user) != null ? true : false;
  }

  public List<Map<String, Object>> getHouseholdMapInfo(int villageId) {
    List<Map<String, Object>> result = new ArrayList<Map<String, Object>>();
    Village village = villageRepo.getOne(villageId);
    for (UrUser household : village.getHouseholds()) {
      if (household.getHouseholdSurvey() != null) {
        Map<String, Object> householdInfo = new HashMap<String, Object>();
        householdInfo.put("householdId", household.getId());
        householdInfo.put("householdName",
            household.getFirstname() + " " + household.getLastname());
        result.add(householdInfo);
      }
    }
    return result;
  }
}
