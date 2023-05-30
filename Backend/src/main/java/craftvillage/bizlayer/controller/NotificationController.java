package craftvillage.bizlayer.controller;

import java.security.Principal;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import craftvillage.bizlayer.services.NotificationService;
import craftvillage.bizlayer.services.SurveyServices;
import craftvillage.bizlayer.services.UserService;
import craftvillage.corelayer.utilities.ConstantParameter;
import craftvillage.datalayer.entities.dto.PollutionWarningDTO;

@RestController
@RequestMapping("/" + ConstantParameter._URL_ROOT + "/" + ConstantParameter._URL_API
    + "/notification")
public class NotificationController {
  @Autowired
  NotificationService notificationService;
  @Autowired
  UserService userService;
  @Autowired
  SurveyServices surveyServices;

  @GetMapping
  public List<PollutionWarningDTO> getNotification(Principal principal) {
    int districId = userService.findByUsername(principal.getName()).getDistrict().getDistrictId();
    return notificationService.getPollutionWarnings(districId);
  }

  @PutMapping
  public boolean seen(@RequestParam("id") int surveyId) {
    return surveyServices.seenSurvey(surveyId);
  }
}
