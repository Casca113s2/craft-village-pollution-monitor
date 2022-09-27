package craftvillage.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;

@Controller
@RequestMapping("/web/authority")
public class AuthorityController {
	@GetMapping("/index")
	public String index() {
		return "index";
	}
	
}
