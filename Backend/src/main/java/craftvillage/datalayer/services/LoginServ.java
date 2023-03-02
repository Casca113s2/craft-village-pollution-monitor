package craftvillage.datalayer.services;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import craftvillage.datalayer.entities.UrSession;
import craftvillage.datalayer.repositories.SessionRepository;
import craftvillage.datalayer.repositories.UserRepository;

@Service
public class LoginServ {
  @Autowired
  UserRepository userRepo;
  @Autowired
  SessionRepository sessionRepo;

  public boolean addSession(String account, String sessionString) {
    UrSession session = new UrSession();
    LocalDateTime localDateTime = LocalDateTime.now();

    Date date = Date.from(localDateTime.atZone(ZoneId.systemDefault()).toInstant());

    if (this.findBySession(sessionString) == null) {
      session.setUrUser(userRepo.findByAccount(account));
      session.setLoginTime(date);
      session.setSessionString(sessionString);
      System.out.println("\n---------------");
      if (sessionRepo.save(session) != null) {
        return true;
      }
    }
    return false;
  }

  public UrSession findBySession(String sessionString) {
    return sessionRepo.findBySessionString(sessionString);
  }
}
