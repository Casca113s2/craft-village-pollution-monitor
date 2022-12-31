package craftvillage.web.controller;

import java.security.Principal;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import craftvillage.bizlayer.services.UserService;
import craftvillage.datalayer.entities.UrUser;

@Controller
@RequestMapping("/web")
public class PageController {

  @Autowired
  private UserService userService;

  @GetMapping("/login")
  public String loginPage() {
    return "login";
  }

  @GetMapping("/signup")
  public String signupPage() {
    return "register";
  }

  @GetMapping("/forgetpassword")
  public String forgetPassword() {
    return "forget-pass";
  }

  @GetMapping("/home")
  public String home(Principal principal) {
    UrUser user = userService.findByUsername(principal.getName());
    System.out.println(user.getType());
    if (user.getType().equals("Household")) {
      return "redirect:/web/household/declare";
    } else if (user.getType().equals("LocalAuthority")) {
      return "redirect:/web/authority/index";
    } else
      return "redirect:/admin-site/localauthority";
  }

}
