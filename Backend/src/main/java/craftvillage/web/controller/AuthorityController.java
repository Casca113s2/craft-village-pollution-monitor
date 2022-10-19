package craftvillage.web.controller;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import craftvillage.bizlayer.services.AddressServices;
import craftvillage.bizlayer.services.VillageServices;
import craftvillage.datalayer.entities.Village;


@Controller
@RequestMapping("/web/authority")
public class AuthorityController {
	
	@Autowired
	VillageServices villageService;
	
	@Autowired
	AddressServices addressService;
	
	@GetMapping("/index")
	public String index() {
		return "index";
	}
	@GetMapping("/newvillage")
	public String newHousehold(Model model) {
		List<Village> list = villageService.getAll();
		model.addAttribute("pendingVillages", list.stream().filter(village -> village.getHasAdded()==0).collect(Collectors.toList()));
		return "newvillage";
	}
	
	@PostMapping("/newvillage")
	@ResponseBody
	public int newVillage(@RequestParam Map<String, String>form) {
		Village village = new Village();
		village.setVillageName(form.get("villageName"));
		village.setCoordinate(form.get("longitude") + ", " + form.get("latitude"));
		village.setNote(form.get("note"));
		village.setHasAdded(1);
		village.setAdWard(addressService.getAdward(Integer.parseInt(form.get("ward"))));
		int result = villageService.newVillage(village);
		return result;
	}
	
	@GetMapping("/villagedata")
	public String villageData(Model model) {
		return "villagedata";
	}
	
	@PostMapping("/newhousehold/accept")
	@ResponseBody
	public boolean acceptNewVillage(@RequestParam("villageId") int villageId) {
		return villageService.acceptNewVillage(villageId);
	}
	
	@PostMapping("/newhousehold/deny")
	@ResponseBody
	public boolean denyNewVillage(@RequestParam("villageId") int villageId) {
		return villageService.denyNewVillage(villageId);
	}
	
}
