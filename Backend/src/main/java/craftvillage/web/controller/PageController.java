package craftvillage.web.controller;

import java.security.Principal;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/web")
public class PageController {
	
	@GetMapping("/login")
	public String loginPage() {
		return "login";
	}
	
	@GetMapping("/signup")
	public String signupPage() {
		return "register";
	}
	
//	@GetMapping("/home")
//	public String home(Principal principal) {
//		if(principal.)
//	}
	
}
