package craftvillage.bizlayer.services;

import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import craftvillage.datalayer.entities.UrRole;
import craftvillage.datalayer.entities.UrUser;
import craftvillage.datalayer.repositories.RoleRepository;
import craftvillage.datalayer.repositories.UserRepository;
import craftvillage.datalayer.services.LoginServ;


@Service
public class MyUserDetailsService implements UserDetailsService {
  @Autowired
  PasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

  @Autowired
  private LoginServ loginServ = new LoginServ();

  @Autowired
  UserService userService;

  @Autowired
  UserRepository userRepo;

  @Autowired
  RoleRepository roleRepo;

  @Override
  public UserDetails loadUserByUsername(String username) {
    UrUser urUser = new UrUser();
    User user = null;
    urUser = userRepo.findByAccount(username);
    // System.out.println(urUser.getUrRoles());
    if (urUser == null)
      return user;

    Set<UrRole> urRoles = new HashSet<>();

    urRoles = urUser.getUrRoles();
    // System.out.println(urRoles);
    List<GrantedAuthority> grantList = new ArrayList<GrantedAuthority>();
    for (UrRole role : urRoles) {
      GrantedAuthority authority = new SimpleGrantedAuthority(role.getRoleCode());
      // System.out.println(role.getRoleCode());
      grantList.add(authority);
    }

    user = new User(urUser.getAccount(), urUser.getPassword(), grantList);

    System.out.println(user);
    return user;
  }

  /**
   * Register
   * 
   * @return Number - 1: Success - 2: Username exist - 3: Email exist - 4: Phone exist - 0: fail
   */
  public int RegisterUsername(String username, String password, String role, String firstname,
      String lastname, String phone, String email, Date activeDate)
      throws ClassNotFoundException, SQLException, ParseException {
    String pass = passwordEncoder.encode(password);
    System.out.println(role);
    int roleId;
    if (role.equals("USER"))
      roleId = 1;
    else if (role.equals("HOUSEHOLD"))
      roleId = 3;
    else
      roleId = 2;

    UrUser newUser = userRepo.findByAccount(username);
    boolean emailChecker = userService.emailChecker(email);
    int returnValue = 0;
    if (newUser == null && emailChecker) {
      newUser = new UrUser();
      newUser.setAccount(username);
      newUser.setPassword(pass);
      UrRole roleUser = roleRepo.getOne(roleId);
      newUser.addRole(roleUser);
      newUser.setEmail(email);
      newUser.setFirstname(firstname);
      newUser.setLastname(lastname);
      newUser.setPhone(phone);
      DateFormat dateFormat = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
      String strDate = dateFormat.format(activeDate);
      Date ActiveDate = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss").parse(strDate);
      newUser.setActiveDate(ActiveDate);

      if (roleId == 1)
        newUser.setType("PrivatePerson");
      else if (roleId == 2)
        newUser.setType("LocalAuthority");
      else if (roleId == 3)
        newUser.setType("Household");
      if (userRepo.save(newUser) != null)
        returnValue = 1;
    } else if (userService.findByUsername(username) != null) {
      returnValue = 2;
    } else if (userService.emailChecker(email) == false) {
      returnValue = 3;
    } else if (userService.phoneChecked(phone) == false) {
      returnValue = 4;
    }
    return returnValue;
  }

  public boolean AddSession(String username, String sessionID) {
    if (loginServ.addSession(username, sessionID))
      return true;
    return false;
  }

  public UrUser GetUserData(String username) {
    UrUser user = userService.findByUsername(username);
    return user;
  }

  public boolean changePass(String newPass, String username) {
    String pass = passwordEncoder.encode(newPass);
    return userService.changePassword(username, pass);
  }

  public boolean updateUserInfo(String username, String firstname, String lastname, String phone)
      throws ParseException {
    return userService.updateInfo(username, firstname, lastname, phone);
  }

  public UrUser getUrUser(String account) {
    return userService.findByUsername(account);
  }

  public String getEmailUser(String account) {
    return userService.getEmailUser(account);
  }

  public boolean checkEmailUser(String email, String username) {
    return userService.checkEmailUser(email, username);
  }

  public boolean AddOrUpdateActiveCode(String ActiveCode, Date ActiveDate, String username) {
    return userService.AddOrUpdateActiveUser(ActiveCode, ActiveDate, username);
  }

  public int checkActiveCode(String ActiveCode, Date DateNow, String ActiveCodeSubmit,
      Date ActiveDate) {
    if ((DateNow.getTime() - ActiveDate.getTime()) <= 900000) {
      if (ActiveCodeSubmit.equals(ActiveCode))
        // match code
        return 1;
      else
        // wrong code
        return 0;
    }
    // expired code
    return 2;
  }
}
