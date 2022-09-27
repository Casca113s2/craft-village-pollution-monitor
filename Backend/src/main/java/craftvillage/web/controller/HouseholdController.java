package craftvillage.web.controller;

import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import craftvillage.bizlayer.services.AddressServices;

@Controller
@RequestMapping("/web/household")
public class HouseholdController {

	@Autowired
	private AddressServices addressService;
	
	@GetMapping("/khai-bao")
	public String getForm(Model model) {
		model.addAttribute("provinceList", addressService.getProvinceList(234));
		return "household";
	}
	
}
