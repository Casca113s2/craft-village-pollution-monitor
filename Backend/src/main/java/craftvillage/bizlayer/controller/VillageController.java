package craftvillage.bizlayer.controller;

// import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;

import java.security.Principal;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import craftvillage.bizlayer.services.AddressServices;
import craftvillage.bizlayer.services.MyUserDetailsService;
import craftvillage.bizlayer.services.SurveyServices;
import craftvillage.bizlayer.services.VillageServices;
import craftvillage.bizlayer.support_api.location.Coordinate;
import craftvillage.corelayer.utilities.CommonUtil;
import craftvillage.corelayer.utilities.ConstantParameter;
import craftvillage.datalayer.entities.UrUser;
import craftvillage.datalayer.entities.UserSurvey;
import craftvillage.datalayer.entities.Village;

@RestController
@RequestMapping("/" + ConstantParameter._URL_ROOT + "/" + ConstantParameter._URL_API + "/"
    + ConstantParameter.ServiceVillage._VILLAGE_SERVICE)
public class VillageController {
  private static final Logger logger = LoggerFactory.getLogger(VillageController.class);
  @Autowired
  private MyUserDetailsService userDeailsService;
  @Autowired
  private SurveyServices surveyServices;
  @Autowired
  private AddressServices addressService;
  @Autowired
  private VillageServices villageService;


  /**
   * Function : newVillage : Submit lang nghe moi tu personal user
   * 
   * @param newVillage
   * @param principal
   * @return new village id
   */
  @PostMapping("/newvillage")
  public int newVillage(@RequestBody Map<String, String> newVillage) {
    int wardId = Integer.parseInt(newVillage.get("wardId"));
    int hasAdded = Integer.parseInt(newVillage.get("hasAdded"));
    String coordinate = newVillage.get("latitude") + ", " + newVillage.get("longitude");
    Village village = new Village();
    village.setAdWard(addressService.getAdward(wardId));
    village.setCoordinate(coordinate);
    village.setHasAdded(hasAdded);
    village.setNote(newVillage.get("note"));
    village.setVillageName(newVillage.get("villageName"));
    int id = villageService.newVillage(village);
    return id;
  }


  /**
   * Function : VillageInfoSubmit : Submit thông tin làng nghề
   * 
   * @param VillageInfoForm
   * @param principal
   * @return true : submit thành công false : submit thất bại
   */
  @RequestMapping(value = "/" + ConstantParameter.ServiceVillage._VILLAGE_SUBMIT,
      method = RequestMethod.POST)
  public boolean VillageInfoSubmit(@RequestBody Map<String, String> VillageInfoForm,
      Principal principal) {
    String username = principal.getName();
    String villageId = VillageInfoForm.get("villageId");
    String coordinate = VillageInfoForm.get("latitude") + ", " + VillageInfoForm.get("longitude");
    String image = VillageInfoForm.get("image");
    String pollution = VillageInfoForm.get("result");
    String note = VillageInfoForm.get("note");
    UrUser user = userDeailsService.getUrUser(username);
    UserSurvey userSurvey = new UserSurvey();
    Village village = addressService.getVillageInfo(Integer.parseInt(villageId));
    userSurvey.setWarning(
        village.getHasAdded() == 1 ? CommonUtil.makePollutionWarning(pollution, village.getState())
            : false);
    userSurvey.setDateSubmitSurvey(new Date());
    userSurvey.setVillage(village);
    userSurvey.setCoordinate(coordinate);
    userSurvey.setImage(image);
    userSurvey.setPollution(pollution);
    userSurvey.setNote(note);
    userSurvey.setUrUser(user);
    if (village.getHasAdded() == 0)
      userSurvey.setIsTemporary("Deactived");
    else
      userSurvey.setIsTemporary("Actived");
    return surveyServices.addUserSurvey(userSurvey);

  }

  @PostMapping("/update")
  public Village updateVillage(@RequestBody Map<String, String> villageInfo) {
    return villageService.updateVillage(villageInfo);
  }

  /**
   * Dò làng nghề theo tọa độ
   */
  @RequestMapping(value = "/" + ConstantParameter.ServiceVillage._VILLAGE_DETECT,
      method = RequestMethod.GET, produces = "application/json")
  public List<Map<String, Object>> detectVillage(@RequestParam String latitude,
      @RequestParam String longitude) {

    Coordinate coordinate =
        new Coordinate(Double.parseDouble(latitude), Double.parseDouble(longitude));

    List<Village> villages = villageService.findVillageByCoordinate(coordinate);

    List<Map<String, Object>> res = new ArrayList<Map<String, Object>>();

    for (Village village : villages) {
      Map<String, Object> villageInfo = new HashMap<>();

      villageInfo.put("villageId", village.getVillageId());
      villageInfo.put("hasAdded", village.getHasAdded());
      villageInfo.put("villageName", village.getVillageName());

      villageInfo.put("wardName", village.getAdWard().getWardName());
      villageInfo.put("districtName", village.getAdWard().getAdDistrict().getDistrictName());
      villageInfo.put("provinceName",
          village.getAdWard().getAdDistrict().getAdProvince().getProvinceName());

      villageInfo.put("wardId", village.getAdWard().getWardId());
      villageInfo.put("districtId", village.getAdWard().getAdDistrict().getDistrictId());
      villageInfo.put("provinceId",
          village.getAdWard().getAdDistrict().getAdProvince().getProvinceId());

      villageInfo.put("villageNote", village.getNote());

      String villagecoordinate[] = village.getCoordinate().split(", ");
      villageInfo.put("villageLatitude", villagecoordinate[0]);
      villageInfo.put("villageLongitude", villagecoordinate[1]);

      villageInfo.put("state", village.getState());

      res.add(villageInfo);
    }
    return res;
  }
}
