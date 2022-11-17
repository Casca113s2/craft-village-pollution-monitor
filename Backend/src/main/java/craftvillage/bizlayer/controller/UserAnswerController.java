package craftvillage.bizlayer.controller;

import javax.servlet.ServletContext;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import craftvillage.bizlayer.services.AddressServices;
import craftvillage.bizlayer.services.FileService;
import craftvillage.bizlayer.services.MyUserDetailsService;
import craftvillage.bizlayer.services.SurveyServices;
import craftvillage.corelayer.utilities.ConstantParameter;

@RestController
@RequestMapping("/" + ConstantParameter._URL_ROOT + "/" + ConstantParameter._URL_API + "/"
    + ConstantParameter.ServiceAnswer._ANSWER_SERVICE)
public class UserAnswerController {

  @Autowired
  private MyUserDetailsService userDetailsService;
  @Autowired
  private SurveyServices surveyServices;
  @Autowired
  private AddressServices addressService;
  @Autowired
  private FileService fileService;
  @Autowired
  private ServletContext sc;

  /**
   * Function UploadFile : upload file
   * 
   * @param file
   * @return Village : trả về thông tin làng nghề được gợi ý
   * @throws Exception
   */
  public MyUserDetailsService getUserDetailsService() {
    return userDetailsService;
  }

  public void setUserDetailsService(MyUserDetailsService userDetailsService) {
    this.userDetailsService = userDetailsService;
  }

  public SurveyServices getSurveyServices() {
    return surveyServices;
  }

  public void setSurveyServices(SurveyServices surveyServices) {
    this.surveyServices = surveyServices;
  }

  public AddressServices getAddressService() {
    return addressService;
  }

  public void setAddressService(AddressServices addressService) {
    this.addressService = addressService;
  }

  public FileService getFileService() {
    return fileService;
  }

  public void setFileService(FileService fileService) {
    this.fileService = fileService;
  }

}
