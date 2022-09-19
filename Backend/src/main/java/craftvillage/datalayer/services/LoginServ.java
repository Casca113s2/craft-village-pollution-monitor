package craftvillage.datalayer.services;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;

import org.springframework.stereotype.Repository;

import craftvillage.datalayer.dao.CrudDao;
import craftvillage.datalayer.entities.UrSession;
import craftvillage.datalayer.entities.UrUser;

@Repository
public class LoginServ {
	
	public boolean addSession(String account, String sessionString) {
		UserServ userServ = new UserServ();
		CrudDao<UrSession> sessionDao = new CrudDao<>(UrSession.class);
		UrSession session = new UrSession();
		LocalDateTime localDateTime = LocalDateTime.now();

		Date date = Date.from(localDateTime.atZone(ZoneId.systemDefault()).toInstant());

		if (this.findBySession(sessionString) == null) {
			session.setUrUser(userServ.findByAccount(account));
			session.setLoginTime(date);
			session.setSessionString(sessionString);
			boolean check = sessionDao.addObject(session);
			return check;
		} else {
			return false;
		}
	}

	public UrUser getLogin(String account) {
		UserServ userServ = new UserServ();
		UrUser user = userServ.findByAccount(account);
		return user;

	}

	public UrSession findBySession(String sessionString) {
		CrudDao<UrSession> sessionDao = new CrudDao<>(UrSession.class);
		String hql = "SELECT c FROM UrSession c Where c.sessionString = " + "'" + sessionString + "'";
		List<UrSession> lstSession = new ArrayList<UrSession>();
		if (sessionDao.queyObject(hql).isEmpty() == false) {
			lstSession = sessionDao.queyObject(hql);
			return lstSession.get(0);
		} else {
			return null;
		}
	}
}
