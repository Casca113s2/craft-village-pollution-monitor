package craftvillage.bizlayer.controller;

import java.security.Principal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import craftvillage.bizlayer.services.AddressServices;
import craftvillage.bizlayer.services.MyUserDetailsService;
import craftvillage.bizlayer.services.SurveyServices;
import craftvillage.bizlayer.services.UserService;
import craftvillage.corelayer.utilities.ConstantParameter;
import craftvillage.datalayer.entities.UrUser;
import craftvillage.datalayer.entities.UserSurvey;

@RestController
@RequestMapping("/" + ConstantParameter._URL_ROOT + "/" + ConstantParameter._URL_API + "/"
    + ConstantParameter.ServiceSurvey._SURVEY_SERVICE)
public class SurveyController {
  @Autowired
  private SurveyServices surveyServices;
  @Autowired
  private MyUserDetailsService userDetailsService;
  @Autowired
  private AddressServices addressService;
  @Autowired
  private UserService userService;

  @GetMapping("/getimage")
  @ResponseBody
  public String getImage(@RequestParam("surveyId") int id) {
    return surveyServices.getImageBySurveyId(id);
  }

  @GetMapping(value = "/" + ConstantParameter.ServiceSurvey._SURVEY_GET_ALL_SURVEY)
  public Map<String, List<Map<String, Object>>> getAllSurvey(Principal principal) {
    UrUser user = userService.findByUsername(principal.getName());
    Map<String, List<Map<String, Object>>> response =
        new HashMap<String, List<Map<String, Object>>>();
    List<Map<String, Object>> completedSurvey = new ArrayList<Map<String, Object>>();
    List<Map<String, Object>> inprogressSurvey = new ArrayList<Map<String, Object>>();
    for (UserSurvey survey : user.getUserSurveys()) {
      Map<String, Object> data = new HashMap<String, Object>();
      data.put("villageId", survey.getVillage().getVillageId());
      data.put("villageName", survey.getVillage().getVillageName());
      data.put("date", survey.getDateSubmitSurvey().toString());
      if (survey.getVillage().getHasAdded() == 1) {
        completedSurvey.add(data);
      } else {
        inprogressSurvey.add(data);
      }
    }
    response.put("completedSurvey", completedSurvey);
    response.put("inprogressSurvey", inprogressSurvey);
    return response;
  }

  public SurveyServices getSurveyServices() {
    return surveyServices;
  }

  public void setSurveyServices(SurveyServices surveyServices) {
    this.surveyServices = surveyServices;
  }

  public MyUserDetailsService getUserDetailsService() {
    return userDetailsService;
  }

  public void setUserDetailsService(MyUserDetailsService _userDetailsService) {
    this.userDetailsService = _userDetailsService;
  }

  public AddressServices getAddressService() {
    return addressService;
  }

  public void setAddressService(AddressServices addressService) {
    this.addressService = addressService;
  }
}
