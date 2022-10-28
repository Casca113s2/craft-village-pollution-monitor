package craftvillage.bizlayer.services;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Set;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.NoResultException;
import javax.persistence.Persistence;

import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import craftvillage.datalayer.entities.SrSurvey;
import craftvillage.datalayer.entities.UrRole;
import craftvillage.datalayer.entities.UrUser;
import craftvillage.datalayer.services.LoginServ;
import craftvillage.datalayer.services.RegisterServ;
import craftvillage.datalayer.services.SurveyServ;
import craftvillage.datalayer.services.UserServ;


@Service
public class MyUserDetailsService implements UserDetailsService {

	// static int id = 5;

	@Autowired
	PasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
	@Autowired
	private RegisterServ registerServ = new RegisterServ();
	@Autowired
	private LoginServ loginServ = new LoginServ();
	@Autowired
	private SurveyServ surveyServ = new SurveyServ();
	@Autowired
	private UserServ userServ = new UserServ();
	
//	@Autowired
//	private UrAnswerServ urAnswerServ = new UrAnswerServ();

	@Override
	public UserDetails loadUserByUsername(String username) {
		
		UrUser urUser = new UrUser();
		User user = null;
		urUser = userServ.findByAccount(username);
		//System.out.println(urUser.getUrRoles());
		if (urUser == null)
			return user;
		
			Set<UrRole> urRoles = new HashSet<>();
			
			urRoles = urUser.getUrRoles();
			//System.out.println(urRoles);
			List<GrantedAuthority> grantList = new ArrayList<GrantedAuthority>();
			for (UrRole role : urRoles)
			{	
				GrantedAuthority authority = new SimpleGrantedAuthority(role.getRoleCode());
				//System.out.println(role.getRoleCode());
				grantList.add(authority);
			}
			 
			user = new User(urUser.getAccount() , urUser.getPassword(),grantList);
			
			System.out.println(user);
			return user;
	}

	public int RegisterUsername(String username, String password, String role, String firstname, String lastname,
			String phone, String email, Date activeDate) throws ClassNotFoundException, SQLException, ParseException
	{
		String pass = passwordEncoder.encode(password);
		int roleID;
		if (role.equals("USER"))
			roleID = 1;
		else if (role.equals("HOUSEHOLD"))
			roleID = 3;
		else
			roleID = 2;
		return (registerServ.registeAnUser(username, pass, roleID, firstname, lastname, phone, email, activeDate));	
	}
	
	public boolean AddSession(String username , String sessionID)
	{
		if (loginServ.addSession(username, sessionID))
			return true;
		return false;
	}
	
	public UrUser GetUserData(String username)
	{
		UrUser user = userServ.findByAccount(username);
		return user;
	}
	
	public boolean changePass( String newPass , String username)
	{
		String pass = passwordEncoder.encode(newPass);
		return userServ.changePassword(username, pass);
	}
	
	public boolean updateUserInfo(String username , String firstname , String lastname , String phone , String email, String type) throws ParseException
	{
		return userServ.updateInfo(username, firstname, lastname, phone,email,type);
	}
	public boolean updateType(String username , String type)
	{
		return userServ.updateType(username, type);
	}
	public UrUser getUrUser(String account)
	{
		return userServ.findByAccount(account);
	}
	public String getEmailUser(String account)
	{
		return userServ.getEmailUser(account);
	}
	public boolean checkEmailUser(String email, String username)
	{
		return userServ.checkEmailUser(email, username);
	}
	public boolean AddOrUpdateActiveCode(String ActiveCode , Date ActiveDate , String username)
	{
		return userServ.AddOrUpdateActiveUser(ActiveCode, ActiveDate, username);
	}
	public int checkActiveCode(String ActiveCode , Date DateNow , String ActiveCodeSubmit , Date ActiveDate)
	{
		if ((DateNow.getTime() - ActiveDate.getTime()) <= 900000   )
		{
			if (ActiveCodeSubmit.equals(ActiveCode))
				//match code
				return 1;
			else
				//wrong code
				return 0;
		}
		//expired code
		return 2;
	}
	public boolean changeType(String username , String typeUser)
	{
		return userServ.changeType(username, typeUser);
	}
}
