package craftvillage.web.controller;

import java.security.Principal;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.Date;
import java.util.HashMap;
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
import craftvillage.bizlayer.services.MyUserDetailsService;
import craftvillage.bizlayer.services.UserService;
import craftvillage.datalayer.entities.UrUser;

@Controller
@RequestMapping("/admin-site")
public class AdminController {

  @Autowired
  private AddressServices addressService;

  @Autowired
  private MyUserDetailsService userDetailsService;

  @Autowired
  private UserService userService;

  @GetMapping("/localauthority")
  public String localAuthoirityPage(Model model, Principal principal) {
    model.addAttribute("name", principal.getName());
    model.addAttribute("provinceList", addressService.getProvinceList(234));
    return "AdminAuthority";
  }

  @PostMapping("/createauthority")
  @ResponseBody
  public HashMap<String, String> createAuthority(@RequestParam Map<String, String> form)
      throws ClassNotFoundException, SQLException, ParseException {
    HashMap<String, String> console = new HashMap<>();
    String username = form.get("username");
    String password = form.get("password");
    String name = form.get("name");
    String phone = form.get("phone");
    String email = form.get("email");
    String role = "LOCALAUTHORITY";
    int districtId = Integer.parseInt(form.get("district"));
    Date dateActive = new Date();
    int register = userDetailsService.RegisterUsername(username, password, role, name, "", phone,
        email, dateActive);
    if (register == 1) {
      console.put("key", "1");
      console.put("message", "Đăng ký thành công!");
      UrUser localAuthority = userDetailsService.getUrUser(username);
      localAuthority.setDistrict(addressService.getAdDistrict(districtId));
      userService.save(localAuthority);
    } else if (register == 2) {
      console.put("key", "2");
      console.put("message", "Người dùng này đã tồn tại!");
    } else if (register == 3) {
      console.put("key", "3");
      console.put("message", "Email này đã được sử dụng!");
    } else if (register == 4) {
      console.put("key", "4");
      console.put("message", "Số điện thoại này đã được sử dụng!");
    } else if (register == 0) {
      console.put("key", "0");
      console.put("message", "Tạo thất bại!");
    }

    return console;
  }
}
