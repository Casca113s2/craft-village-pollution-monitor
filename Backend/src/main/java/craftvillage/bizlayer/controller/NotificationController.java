package craftvillage.bizlayer.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import craftvillage.corelayer.utilities.ConstantParameter;

@RestController
@RequestMapping("/" + ConstantParameter._URL_ROOT + "/" + ConstantParameter._URL_API
    + "/notification")
public class NotificationController {
  @GetMapping
  public List<Map<String, String>> getNotification() {
    List<Map<String, String>> response = new ArrayList<Map<String, String>>();
    return response;
  }
}
