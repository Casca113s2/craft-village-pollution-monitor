package craftvillage.bizlayer.controller;

import java.security.Principal;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import craftvillage.bizlayer.services.AddressServices;
import craftvillage.bizlayer.services.MyUserDetailsService;
import craftvillage.bizlayer.services.SurveyServices;
import craftvillage.corelayer.utilities.ConstantParameter;

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

  /**
   * Function : getstatus : Trả về trạng thái của survey
   * 
   * @param activeId
   * @param principal
   * @return String
   */
  @RequestMapping(value = "/" + ConstantParameter.ServiceSurvey._SURVEY_GET_STATUS_SURVEY,
      method = RequestMethod.GET)
  public String getStatus(@RequestParam("id") int activeId, Principal principal) {
    String account = principal.getName();
    return surveyServices.getStatus(account, activeId);
  }

  @GetMapping("/getimage")
  @ResponseBody
  public String getImage(@RequestParam("surveyId") int id) {
    return surveyServices.getImageBySurveyId(id);
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
