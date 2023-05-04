package craftvillage.ai;

import java.time.LocalDate;
import java.util.List;
import org.springframework.beans.factory.annotation.Value;

public class TrainingUtil {
  @Value("${task.training.months}")
  private static List<Integer> months;
  @Value("${task.training.startDay}")
  private static int startDay;
  @Value("${task.training.alertDay}")
  private static int alertDay;

  public static boolean checkValidDate(LocalDate date) {
    for (int month : months) {
      if (date.getMonthValue() == month && date.getDayOfMonth() >= alertDay
          && date.getDayOfMonth() < startDay) {
        return true;
      }
    }
    return false;
  }
}
