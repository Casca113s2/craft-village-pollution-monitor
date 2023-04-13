package craftvillage.corelayer.utilities;

import java.security.SecureRandom;

public class CommonUtil {
  public static String stringGenerator(int len) {
    SecureRandom random = new SecureRandom();
    StringBuilder password = new StringBuilder(len);
    for (int i = 0; i < len; i++)
      password.append(ConstantParameter.CHARACTER_FOR_CREATE_PASSWORD
          .charAt(random.nextInt(ConstantParameter.CHARACTER_FOR_CREATE_PASSWORD.length())));
    return password.toString();
  }
}
