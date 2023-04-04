package craftvillage.web.controller;

import java.security.Principal;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TimeZone;
import java.util.stream.Collectors;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import craftvillage.bizlayer.services.AddressServices;
import craftvillage.bizlayer.services.SurveyServices;
import craftvillage.bizlayer.services.UserService;
import craftvillage.bizlayer.services.VillageServices;
import craftvillage.datalayer.entities.AdDistrict;
import craftvillage.datalayer.entities.AdWard;
import craftvillage.datalayer.entities.UrUser;
import craftvillage.datalayer.entities.Village;
import craftvillage.datalayer.entities.dto.HouseholdSurveyDTO;
import craftvillage.datalayer.entities.dto.MapVillageDTO;


@Controller
@RequestMapping("/web/authority")
public class AuthorityController {

  @Autowired
  VillageServices villageService;

  @Autowired
  AddressServices addressService;

  @Autowired
  UserService userService;

  @Autowired
  SurveyServices surveyService;

  @GetMapping("/index")
  public String index(Model model, Principal principal) {
    int numberOfVillage = 0;
    int numberOfNewVillage = 0;
    int numberOfNewSurvey = 0;
    UrUser user = userService.findByUsername(principal.getName());
    AdDistrict district = user.getDistrict();
    Calendar localCalendar = Calendar.getInstance(TimeZone.getDefault());
    int currentMonth = localCalendar.get(Calendar.MONTH);
    Set<UrUser> newHouseholds = new HashSet<UrUser>();
    for (AdWard ward : district.getAdWards()) {
      for (Village village : ward.getVillages()) {
        newHouseholds.addAll(village.getHouseholds());
        if (village.getHasAdded() == 1) {
          numberOfVillage += 1;
        } else {
          numberOfNewVillage += 1;
        }
        numberOfNewSurvey += surveyService.countMonthlySurvey(village);
      }
    }
    newHouseholds.stream().filter(household -> household.getActiveDate().toInstant()
        .atZone(ZoneId.systemDefault()).toLocalDate().getMonthValue() == currentMonth);
    model.addAttribute("numberOfNewHousehold", newHouseholds.size());
    model.addAttribute("numberOfNewSurvey", numberOfNewSurvey);
    model.addAttribute("numberOfVillage", numberOfVillage);
    model.addAttribute("numberOfNewVillage", numberOfNewVillage);
    model.addAttribute("name", principal.getName());
    model.addAttribute("email", user.getEmail());
    model.addAttribute("firstname", user.getFirstname());
    model.addAttribute("lastname", user.getLastname());
    model.addAttribute("phone", user.getPhone());

    return "index";
  }

  @GetMapping("/newvillage")
  public String newHousehold(Model model, Principal principal) {
    UrUser user = userService.findByUsername(principal.getName());
    AdDistrict district = user.getDistrict();
    Set<AdWard> wards = district.getAdWards();
    Set<Village> villages = new HashSet<Village>();
    for (AdWard ward : wards) {
      for (Village village : ward.getVillages()) {
        if (village.getHasAdded() == 0)
          villages.add(village);
      }
    }
    model.addAttribute("pendingVillages", villages);
    model.addAttribute("wards", wards);
    model.addAttribute("name", principal.getName());
    model.addAttribute("email", user.getEmail());
    model.addAttribute("firstname", user.getFirstname());
    model.addAttribute("lastname", user.getLastname());
    model.addAttribute("phone", user.getPhone());
    return "newvillage";
  }

  @PostMapping("/newvillage")
  @ResponseBody
  public int newVillage(@RequestParam Map<String, String> form) {
    Village village = new Village();
    village.setVillageName(form.get("villageName"));
    village.setCoordinate(form.get("longitude") + ", " + form.get("latitude"));
    village.setNote(form.get("note"));
    village.setHasAdded(1);
    village.setAdWard(addressService.getAdward(Integer.parseInt(form.get("ward"))));
    int result = villageService.newVillage(village);
    return result;
  }

  @GetMapping("/map")
  public String map(Model model, Principal principal) {
    UrUser user = userService.findByUsername(principal.getName());
    AdDistrict district = user.getDistrict();
    Set<AdWard> wards = district.getAdWards();
    List<MapVillageDTO> villages = new ArrayList<MapVillageDTO>();
    for (AdWard adWard : wards) {
      villages.addAll(
          adWard.getVillages().stream().map(MapVillageDTO::from).collect(Collectors.toList()));
    }
    model.addAttribute("name", principal.getName());
    model.addAttribute("email", user.getEmail());
    model.addAttribute("firstname", user.getFirstname());
    model.addAttribute("lastname", user.getLastname());
    model.addAttribute("phone", user.getPhone());

    model.addAttribute("wards", wards);
    model.addAttribute("villages", villages);
    return "map";
  }

  @PostMapping("/makedecision/{action}")
  @ResponseBody
  public boolean acceptNewVillage(@PathVariable String action,
      @RequestParam("villageId") int villageId) {
    if (action.equals("accept"))
      return villageService.acceptNewVillage(villageId);
    return villageService.denyNewVillage(villageId);
  }

  @GetMapping("/householdAnswer")
  @ResponseBody
  public Set<HouseholdSurveyDTO> getAnswer(@RequestParam("householdId") int householdId) {
    UrUser user = userService.findById(householdId);
    return surveyService.getHouseholdSurvey(user);
  }
}
