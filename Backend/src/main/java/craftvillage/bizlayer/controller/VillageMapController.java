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
import org.springframework.web.bind.annotation.RestController;
import craftvillage.bizlayer.services.UserService;
import craftvillage.bizlayer.services.VillageServices;
import craftvillage.datalayer.entities.AdDistrict;
import craftvillage.datalayer.entities.AdWard;
import craftvillage.datalayer.entities.UrUser;
import craftvillage.datalayer.entities.Village;

@RestController
@RequestMapping("/api/map")
public class VillageMapController {
  @Autowired
  VillageServices villageServices;

  @Autowired
  UserService userService;

  @GetMapping("/getVillage")
  public Map<String, Object> getVillage(@RequestParam("villageId") int villageId) {
    return villageServices.getVillageMapInfo(villageId);
  }

  @GetMapping("/getHousehold")
  public List<Map<String, Object>> getHousehold(@RequestParam("villageId") int villageId) {
    return userService.getHouseholdMapInfo(villageId);
  }

  @GetMapping("/getVillageLocation")
  public List<Map<String, Object>> getVillageLocation(Principal principal) {
    List<Map<String, Object>> villages = new ArrayList<Map<String, Object>>();
    UrUser user = userService.findByUsername(principal.getName());
    AdDistrict district = user.getDistrict();
    for (AdWard ward : district.getAdWards()) {
      for (Village village : ward.getVillages()) {
        if (village.getHasAdded() == 1) {
          Map<String, Object> villageInfo = new HashMap<String, Object>();
          villageInfo.put("villageId", village.getVillageId());
          String[] coordinate = village.getCoordinate().split(", ");
          villageInfo.put("longitude", coordinate[0]);
          villageInfo.put("latitude", coordinate[1]);
          villages.add(villageInfo);
        }
      }
    }
    return villages;
  }
}
