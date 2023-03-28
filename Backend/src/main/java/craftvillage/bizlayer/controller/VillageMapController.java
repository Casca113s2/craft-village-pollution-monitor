package craftvillage.bizlayer.controller;

import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import craftvillage.bizlayer.services.UserService;
import craftvillage.bizlayer.services.VillageServices;

@RestController("/api/map")
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
}
