package craftvillage.bizlayer.controller;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import craftvillage.ai.TrainingConfig;
import craftvillage.corelayer.utilities.ConstantParameter;

@RestController
@RequestMapping("/" + ConstantParameter._URL_ROOT + "/" + ConstantParameter._URL_API
    + "/notification")
public class NotificationController {
  public List<Map<String, String>> getNotification() {
    List<Map<String, String>> response = new ArrayList<Map<String, String>>();
    LocalDate currentDate = LocalDate.now();
    if (TrainingConfig.checkValidDate(currentDate)) {
      Map<String, String> notification = new HashMap<String, String>();
      notification.put("title", "Cập nhật dữ liệu");
      notification.put("content", "Vui lòng cập nhật trạng thái làng nghề trước ngày "
          + currentDate.getDayOfMonth() + "/" + currentDate.getMonthValue());
    }
    return response;
  }
}
