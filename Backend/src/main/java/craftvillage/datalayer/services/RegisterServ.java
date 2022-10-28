package craftvillage.datalayer.services;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;

import org.springframework.stereotype.Repository;

import craftvillage.datalayer.dao.CrudDao;
import craftvillage.datalayer.entities.UrRole;
import craftvillage.datalayer.entities.UrUser;

@Repository

public class RegisterServ {

	/**
	 * Register
	 * @param account
	 * @param passwordEncode
	 * @param roleId
	 * @param urFirstname
	 * @param urLastname
	 * @param urAddress
	 * @param urPhone
	 * @param urBirthdate
	 * @param urEmail
	 * @param urSex
	 * @return Number
	 * - 1: Success
	 * - 2: Fail
	 * - 0: 
	 * @throws ParseException 
	 */	
	public int registeAnUser(String account, String passwordEncode, int roleId, String urFirstname, String urLastname,
			String urPhone, String urEmail, Date activeDate) throws ParseException {
		
		CrudDao<UrUser> userDao = new CrudDao<>(UrUser.class);
		UserServ userServ = new UserServ();
		CrudDao<UrRole> urRoleDao = new CrudDao<>(UrRole.class);
		UrUser newUser = userServ.findByAccount(account);
		boolean emailChecker = userServ.emailChecker(urEmail);
		int returnValue = 0;
		if (newUser == null && emailChecker == true) {
			newUser = new UrUser();
			newUser.setAccount(account);
			newUser.setPassword(passwordEncode);
			UrRole roleUser = urRoleDao.findById(roleId);
			newUser.addRole(roleUser);
			newUser.setEmail(urEmail);
			newUser.setFirstname(urFirstname);
			newUser.setLastname(urLastname);
			newUser.setPhone(urPhone);
			DateFormat dateFormat = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
			String strDate= dateFormat.format(activeDate);
			Date ActiveDate = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss").parse(strDate);
			newUser.setActiveDate(ActiveDate);
			
			if(roleId == 1) 
				newUser.setType("PrivatePerson");
			else if(roleId == 2)
				newUser.setType("LocalAuthority");
			else if(roleId == 3)
				newUser.setType("Household");
			boolean check = userDao.addObject(newUser);
			if(check) returnValue = 1;
		} else if (userServ.findByAccount(account) != null) {
			returnValue = 2;
		} else if (userServ.emailChecker(urEmail) == false) {
			returnValue = 3;
		}
		else if (userServ.phoneChecked(urPhone) == false)
		{
			returnValue = 4;
		}
		return returnValue;
	}

}
