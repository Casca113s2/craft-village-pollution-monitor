package craftvillage.ai;

import java.time.LocalDate;

public class TrainingConfig {
  public static int[] trainingMonths = {2, 5, 8, 11};
  public static int endDay = 30;
  public static int duration = 10;

  public static boolean checkValidDate(LocalDate date) {
    for (int month : trainingMonths) {
      if (date.getMonthValue() == month && date.getDayOfMonth() > (endDay - duration)
          && date.getDayOfMonth() < endDay) {
        return true;
      }
    }
    return false;
  }
}
