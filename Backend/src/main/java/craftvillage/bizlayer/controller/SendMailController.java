package craftvillage.bizlayer.controller;

import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;
import craftvillage.datalayer.services.MailService;

@RestController
public class SendMailController {
  @Autowired
  private MailService mailService;

  @PostMapping("/report")
  public boolean sendReport(@RequestBody Map<String, String> request) {
    try {
      SimpleMailMessage mailMessage = new SimpleMailMessage();
      mailMessage.setTo("cvpmsproject@gmail.com");
      mailMessage.setSubject("Report: " + request.get("title"));
      mailMessage.setText(request.get("detail"));
      mailService.sendEmail(mailMessage);
      return true;
    } catch (Exception e) {
      System.out.println("Cannot report");
      return false;
    }
  }
}
