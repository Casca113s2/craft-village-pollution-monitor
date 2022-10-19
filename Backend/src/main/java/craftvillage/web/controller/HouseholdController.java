package craftvillage.web.controller;

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
import craftvillage.bizlayer.services.VillageServices;
import craftvillage.datalayer.entities.Village;

@Controller
@RequestMapping("/web/household")
public class HouseholdController {

	@Autowired
	private AddressServices addressService;
	
	@Autowired
	private VillageServices villageService;
	
	@GetMapping("/declare")
	public String getForm(Model model) {
		model.addAttribute("provinceList", addressService.getProvinceList(234));
		return "household";
	}
	
	@PostMapping("/newvillage")
	@ResponseBody
	public int newVillage(@RequestParam Map<String, String>form) {
		Village village = new Village();
		village.setVillageName(form.get("villageName"));
		village.setCoordinate(form.get("longitude") + ", " + form.get("latitude"));
		village.setNote(form.get("note"));
		village.setHasAdded(0);
		village.setAdWard(addressService.getAdward(Integer.parseInt(form.get("ward"))));
		int result = villageService.newVillage(village);
		return result;
	}
}
