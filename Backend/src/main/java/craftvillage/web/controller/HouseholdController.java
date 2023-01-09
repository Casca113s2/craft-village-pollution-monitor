package craftvillage.web.controller;

import java.security.Principal;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import craftvillage.bizlayer.services.AddressServices;
import craftvillage.bizlayer.services.SrSurveyQuestionService;
import craftvillage.bizlayer.services.UserService;
import craftvillage.bizlayer.services.VillageServices;
import craftvillage.datalayer.entities.SrSurveyQuestion;
import craftvillage.datalayer.entities.UrUser;
import craftvillage.datalayer.entities.Village;

@Controller
@RequestMapping("/web/household")
public class HouseholdController {

  @Autowired
  private AddressServices addressService;

  @Autowired
  private VillageServices villageService;

  @Autowired
  private UserService userService;

  @Autowired
  private SrSurveyQuestionService srSurveyQuestionService;

  @GetMapping("/declare")
  public String getForm(Model model, Principal principal) {
    UrUser user = userService.findByUsername(principal.getName());
    String villageName = user.getVillage() != null ? user.getVillage().getVillageName() : "";
    model.addAttribute("villageName",
        villageName.length() > 0 ? " : " + villageName : " : (Chưa khai báo)");
    model.addAttribute("provinceList", addressService.getProvinceList(234));
    model.addAttribute("name", principal.getName());
    model.addAttribute("email", user.getEmail());
    model.addAttribute("firstname", user.getFirstname());
    model.addAttribute("lastname", user.getLastname());
    model.addAttribute("phone", user.getPhone());
    model.addAttribute("questions", srSurveyQuestionService.findByActive(1));
    return "household";
  }

  @PostMapping("/newvillage")
  @ResponseBody
  public int newVillage(@RequestParam Map<String, String> form) {
    Village village = new Village();
    village.setVillageName(form.get("villageName"));
    village.setCoordinate(form.get("latitude") + ", " + form.get("longitude"));
    village.setNote(form.get("note"));
    village.setHasAdded(0);
    village.setAdWard(addressService.getAdward(Integer.parseInt(form.get("ward"))));
    int result = villageService.newVillage(village);
    return result;
  }

  @PostMapping("/village")
  @ResponseBody
  public boolean village(@RequestParam Map<String, String> form, Principal principal) {
    UrUser user = userService.findByUsername(principal.getName());
    int villageId = Integer.parseInt(form.get("village"));
    user.setVillage(villageService.findVillageById(villageId));
    return userService.save(user) != null ? true : false;
  }

  @GetMapping("/question")
  @ResponseBody
  public List<SrSurveyQuestion> getQuestion() {
    return srSurveyQuestionService.findByActive(1);
  }
}
