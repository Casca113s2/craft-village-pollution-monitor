package craftvillage.bizlayer.services;

import java.time.ZoneId;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.TimeZone;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import craftvillage.datalayer.entities.UserSurvey;
import craftvillage.datalayer.entities.Village;
import craftvillage.datalayer.repositories.UserSurveyRepository;

@Service
public class SurveyServices {
  @Autowired
  UserSurveyRepository userSurveyRepo;

  @Autowired
  UserSurveyRepository userSurveyRepository;

  public int countMonthlySurvey(Village village) {
    int count = 0;
    Calendar localCalendar = Calendar.getInstance(TimeZone.getDefault());
    int currentMonth = localCalendar.get(Calendar.MONTH);
    for (UserSurvey survey : village.getUserSurveys()) {
      int surveyMonth = survey.getDateSubmitSurvey().toInstant().atZone(ZoneId.systemDefault())
          .toLocalDate().getMonthValue();
      if (surveyMonth == currentMonth)
        count++;
    }
    return count;
  }

  public String getImageBySurveyId(int id) {
    UserSurvey userSurvey = userSurveyRepository.getOne(id);
    return userSurvey.getImage();
  }

  public boolean addUserSurvey(UserSurvey userSurvey) {
    return userSurveyRepo.save(userSurvey) != null ? true : false;
  }

  public String getPollution(String pollution) {
    List<String> result = new ArrayList<String>();
    String[] list = {"Đất", "Nước", "Không khí"};
    for (int i = 0; i < pollution.length(); i++) {
      if (pollution.charAt(i) == '1')
        result.add(list[i]);
    }
    return String.join(" - ", list);
  }
}
