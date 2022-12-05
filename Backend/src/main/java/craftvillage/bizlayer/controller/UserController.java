package craftvillage.bizlayer.controller;

import java.io.UnsupportedEncodingException;
import java.security.Principal;
import java.security.SecureRandom;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import org.apache.tomcat.util.codec.binary.Base64;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import craftvillage.bizlayer.services.JwtService;
import craftvillage.bizlayer.services.MyUserDetailsService;
import craftvillage.bizlayer.services.SurveyServices;
import craftvillage.corelayer.utilities.ConstantParameter;
import craftvillage.corelayer.utilities.JwtUtil;
import craftvillage.datalayer.entities.UrUser;
import craftvillage.datalayer.model.JwtModel;
import craftvillage.datalayer.services.MailService;

@RestController
@RequestMapping("/" + ConstantParameter._URL_ROOT + "/" + ConstantParameter._URL_API + "/"
    + ConstantParameter.ServiceUser._USER_SERVICE)
public class UserController {

  private static final String CHARACTER_FOR_CREATE_PASSWORD =
      "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";

  @Autowired
  private JwtUtil jwtTokenUtil;
  @Autowired
  private JwtService jwtService;
  @Autowired
  private MyUserDetailsService userDetailsService;
  @Autowired
  private SurveyServices surveyServices;
  @Autowired
  private MailService mailService;
  @Autowired
  private ServletContext sc;

  @RequestMapping(value = "/" + ConstantParameter.ServiceUser._USER_LOGOUT,
      method = RequestMethod.GET)
  public boolean apilogout(Principal principal, HttpServletRequest request) {
    HttpSession session = request.getSession();

    String username = principal.getName();
    if (jwtService.removeUsername(username)) {
      SecurityContextHolder.getContext().setAuthentication(null);
      session.invalidate();
      return true;
    }
    return false;
  }

  /**
   * Funciton : apiloginapp : Truyen api login
   * 
   * @param username
   * @param password
   * @param request
   * @return
   * @throws Exception
   */
  @RequestMapping(value = "/" + ConstantParameter.ServiceUser._USER_LOGIN,
      method = RequestMethod.POST, produces = "application/json")
  @ResponseBody
  public HashMap<String, String> apiloginapp(@RequestBody Map<String, String> formLogin,
      HttpServletRequest request) throws Exception {
    String username = formLogin.get("name");
    String password = formLogin.get("password");
    PasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    HashMap<String, String> console = new HashMap<>();

    String jwt = null;
    HttpSession session = request.getSession();

    String sessionid = session.getId();
    UserDetails user = userDetailsService.loadUserByUsername(username);
    if (user == null) {
      console.put("token", null);
      console.put("error", "ERR_USER_NOT_EXIST");
      return console;
    } else {
      if (passwordEncoder.matches(password, user.getPassword())) {

        if (jwtService.sizeJwtList() == 0) {

          jwt = jwtTokenUtil.generateToken(user, sessionid);
          JwtModel jwtmodel = new JwtModel(jwt, username);

          jwtService.addJwtModel(jwtmodel);
          console.put("token", jwt);
          console.put("error", null);
          userDetailsService.AddSession(username, sessionid);

          return console;
        } else {

          JwtModel jwtmodel = jwtService.checkUsername(username);

          if (jwtmodel != null)
            if (jwtTokenUtil.checktoken(jwtmodel.getToken()) == 0) {

              console.put("token", null);
              console.put("error", "ERROR_LOGIN_DOUBLE");

              return console;
            } else {

              jwt = jwtTokenUtil.generateToken(user, sessionid);
              jwtmodel.setToken(jwt);

              console.put("token", jwt);
              console.put("error", null);
              userDetailsService.AddSession(username, sessionid);

              return console;
            }

        }
        jwt = jwtTokenUtil.generateToken(user, sessionid);

        JwtModel jwtmodel = new JwtModel(jwt, sessionid);
        jwtService.addJwtModel(jwtmodel);
        console.put("token", jwt);
        console.put("error", null);
        userDetailsService.AddSession(username, sessionid);

        return console;

      }

      else {

        console.put("token", null);
        console.put("error", "ERR_USER_WRONG_PASS");
        return console;
      }
    }

  }

  /**
   * Function register : Đăng ký user
   * 
   * @param username
   * @param password
   * @param firstname
   * @param lastname
   * @param birthday
   * @param phone
   * @param address
   * @param email
   * @param sex
   * @return HashMap<String, String> console
   * @throws ParseException
   * @throws SQLException
   * @throws ClassNotFoundException
   * @throws Exception
   */

  @RequestMapping(value = "/" + ConstantParameter.ServiceUser._USER_REGISTER,
      method = RequestMethod.POST, produces = "application/json")
  @ResponseBody
  public HashMap<String, String> register(@RequestBody Map<String, String> formRegister)
      throws ClassNotFoundException, SQLException, ParseException {
    HashMap<String, String> console = new HashMap<>();

    String username = formRegister.get("username");
    String password = formRegister.get("password");
    String Role = formRegister.get("role");
    String firstname = formRegister.get("firstname");
    String lastname = formRegister.get("lastname");
    String phone = formRegister.get("phone");
    String email = formRegister.get("email");

    String activeDate = formRegister.get("activeDate");
    String activeCode = new String(Base64.decodeBase64(formRegister.get("activeCode").getBytes()));
    Date ActiveDate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(activeDate);
    String activeCodeSubmit = formRegister.get("activeCodeSubmit");
    Date DateNow = new Date();
    int i = userDetailsService.checkActiveCode(activeCode, DateNow, activeCodeSubmit, ActiveDate);

    switch (i) {
      // valid code
      case 1: {
        int register = userDetailsService.RegisterUsername(username, password, Role, firstname,
            lastname, phone, email, ActiveDate);
        // success
        if (register == 1) {
          console.put("key", "11");
          console.put("message", "Đăng ký thành công!");
        } else if (register == 2) {
          console.put("key", "12");
          console.put("message", "Người dùng này đã tồn tại!");
        } else if (register == 3) {
          console.put("key", "13");
          console.put("message", "Email này đã được sử dụng!");
        } else if (register == 4) {
          console.put("key", "14");
          console.put("message", "Số điện thoại này đã được sử dụng!");
        } else if (register == 0) {
          console.put("key", "10");
          console.put("message", "Đăng ký thất bại!");
        }
        break;
      }
      // invalid code
      case 0: {
        console.put("key", "0");
        console.put("message", "Sai mã xác nhận!");
        break;
      }
      // expired code
      case 2: {
        console.put("key", "2");
        console.put("message", "Mã xác nhận đã hết hạn!");
        break;
      }
    }

    return console;
  }

  /**
   * Function GetData : Trả về dữ liệu người dùng
   * 
   * @param principal
   * @param request
   * @return HashMap<String,String>
   */
  @RequestMapping(value = "/" + ConstantParameter.ServiceUser._USER_GET_DATA,
      method = RequestMethod.GET)
  @ResponseBody
  public UrUser getdata(Principal principal, HttpServletRequest request) {
    String username = principal.getName();
    UrUser user = userDetailsService.getUrUser(username);
    return user;
  }

  /**
   * Function changePass : Đổi pass User
   * 
   * @param oldpass
   * @param newpass
   * @param request
   * @return true/false
   */
  @RequestMapping(value = "/" + ConstantParameter.ServiceUser._USER_CHANGE_PASS,
      method = RequestMethod.POST)
  public boolean changePass(@RequestBody Map<String, String> ChangePassForm, Principal principal) {
    PasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    String username = principal.getName();
    String oldPass = ChangePassForm.get("oldPass");
    String newPass = ChangePassForm.get("newPass");

    UserDetails user = userDetailsService.loadUserByUsername(username);
    if (!passwordEncoder.matches(oldPass, user.getPassword()))
      return false;
    return userDetailsService.changePass(newPass, username);
  }

  /**
   * Function : forgetPassword
   * 
   * @param username
   * @return : null if username sai email if username dung
   */
  @RequestMapping(value = "/" + ConstantParameter.ServiceUser._USER_FORGOTTEN_PASS,
      method = RequestMethod.POST, produces = "application/json")
  public boolean forgetPassword(@RequestBody Map<String, String> forgetpass) {
    String username = forgetpass.get("username");
    String email = forgetpass.get("email");
    if (userDetailsService.getEmailUser(username).equals(email)) {
      SimpleMailMessage mailMessage = new SimpleMailMessage();
      String password = stringGenerator(6);
      userDetailsService.changePass(password, username);
      mailMessage.setTo(email);
      mailMessage.setSubject("Reset password");
      mailMessage.setText("Mật khẩu: " + password);
      mailService.sendEmail(mailMessage);
      return true;
    }
    return false;
  }

  /**
   * Function UpdateUser : Cập nhật thông tin user
   * 
   * @param username
   * @param firstname
   * @param lastname
   * @param phone
   * @param email
   * @param request
   * @return true/false
   * @throws ParseException
   * @throws UnsupportedEncodingException
   */
  @RequestMapping(value = "/" + ConstantParameter.ServiceUser._USER_UPDATE_INFOR,
      method = RequestMethod.POST, produces = "application/json;charset=UTF-8")
  public boolean updateUser(@RequestBody Map<String, String> updateUserForm, Principal principal)
      throws ParseException, UnsupportedEncodingException {

    String firstname = updateUserForm.get("firstname");
    String lastname = updateUserForm.get("lastname");
    String phone = updateUserForm.get("phone");

    return userDetailsService.updateUserInfo(principal.getName(), firstname, lastname, phone);
  }

  public JwtUtil getJwtTokenUtil() {
    return jwtTokenUtil;
  }

  public void setJwtTokenUtil(JwtUtil jwtTokenUtil) {
    this.jwtTokenUtil = jwtTokenUtil;
  }

  public JwtService getJwtService() {
    return jwtService;
  }

  public void setJwtService(JwtService jwtService) {
    this.jwtService = jwtService;
  }

  public MyUserDetailsService getUserDeailsService() {
    return userDetailsService;
  }

  public void setUserDeailsService(MyUserDetailsService userDeailsService) {
    this.userDetailsService = userDeailsService;
  }

  public SurveyServices getSurveyServices() {
    return surveyServices;
  }

  public void setSurveyServices(SurveyServices surveyServices) {
    this.surveyServices = surveyServices;
  }

  /**
   * Function SendMail : gửi mail để xác minh người dùng
   * 
   * @param principal
   * @param request
   * @return HashMap<String,String> : ActiveCode : code dùng để Active ActiveDate : thời gian gửi
   *         ActiveCode
   */
  @RequestMapping(value = "/" + ConstantParameter.ServiceUser._USER_SEND_EMAIL,
      method = RequestMethod.GET)
  public HashMap<String, String> SendMail(@RequestParam String email, HttpServletRequest request) {
    HashMap<String, String> console = new HashMap<>();
    String Activecode = stringGenerator(6);
    Date dateNow = new Date();

    DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    String strDate = dateFormat.format(dateNow);

    SimpleMailMessage mailMessage = new SimpleMailMessage();

    mailMessage.setTo(email);
    mailMessage.setSubject("Active Mail");
    mailMessage.setText("Xã xác minh : " + Activecode);
    mailService.sendEmail(mailMessage);
    String activeCode = new String(Base64.encodeBase64(Activecode.getBytes()));
    console.put("activeCode", activeCode);
    console.put("activeDate", strDate);
    return console;
  }

  private String stringGenerator(int len) {
    SecureRandom random = new SecureRandom();
    StringBuilder password = new StringBuilder(len);
    for (int i = 0; i < len; i++)
      password.append(CHARACTER_FOR_CREATE_PASSWORD
          .charAt(random.nextInt(CHARACTER_FOR_CREATE_PASSWORD.length())));
    return password.toString();
  }

  public MailService getMailService() {
    return mailService;
  }

  public void setMailService(MailService mailService) {
    this.mailService = mailService;
  }

  public static String getCharacterForCreatePassword() {
    return CHARACTER_FOR_CREATE_PASSWORD;
  }

}
