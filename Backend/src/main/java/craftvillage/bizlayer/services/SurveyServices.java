package craftvillage.bizlayer.services;

import java.time.ZoneId;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TimeZone;
import java.util.stream.Collectors;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import craftvillage.datalayer.entities.HouseholdSurvey;
import craftvillage.datalayer.entities.UrUser;
import craftvillage.datalayer.entities.UserSurvey;
import craftvillage.datalayer.entities.Village;
import craftvillage.datalayer.entities.dto.HouseholdSurveyDTO;
import craftvillage.datalayer.repositories.HouseholdSurveyRepository;
import craftvillage.datalayer.repositories.SrSurveyQuestionAnswerRepository;
import craftvillage.datalayer.repositories.UserRepository;
import craftvillage.datalayer.repositories.UserSurveyRepository;
import craftvillage.datalayer.repositories.VillageRepository;

@Service
public class SurveyServices {
  @Autowired
  UserSurveyRepository userSurveyRepo;

  @Autowired
  UserSurveyRepository userSurveyRepository;

  @Autowired
  HouseholdSurveyRepository householdSurveyRepo;

  @Autowired
  SrSurveyQuestionAnswerRepository surveyQuestionAnswerRepository;

  @Autowired
  UserRepository userRepository;

  @Autowired
  VillageRepository villageRepository;

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

  public Map<String, String> getImageBySurveyId(int id) {
    UserSurvey userSurvey = userSurveyRepository.getOne(id);
    Map<String, String> result = new HashMap<String, String>();
    result.put("date", userSurvey.getDateSubmitSurvey().toString());
    result.put("pollution", getPollution(userSurvey.getPollution()));
    result.put("coordinate", userSurvey.getCoordinate());
    result.put("note", userSurvey.getNote());
    result.put("image", userSurvey.getImage());
    return result;
  }

  public boolean addUserSurvey(UserSurvey userSurvey) {
    return userSurveyRepo.save(userSurvey) != null ? true : false;
  }

  public String getPollution(String pollution) {
    List<String> result = new ArrayList<String>();
    String[] list = {"Đất", "Không khí", "Nước"};
    for (int i = 0; i < pollution.length(); i++) {
      if (pollution.charAt(i) == '1')
        result.add(list[i]);
    }
    return String.join(" - ", result);
  }

  public boolean addHouseholdSurvey(UrUser user, List<Map<String, String>> answers) {
    for (HouseholdSurvey item : householdSurveyRepo.findByHousehold(user)) {
      householdSurveyRepo.delete(item);
    }

    for (Map<String, String> answer : answers) {
      HouseholdSurvey householdSurvey = new HouseholdSurvey();
      householdSurvey.setSrSurveyQuestionAnswer(
          surveyQuestionAnswerRepository.getOne(Integer.parseInt(answer.get("id"))));
      householdSurvey.setAnswerContent(answer.get("value"));
      householdSurvey.setHousehold(user);
      if (householdSurveyRepo.save(householdSurvey) == null) {
        return false;
      }
    }
    return true;
  }

  public Set<HouseholdSurveyDTO> getHouseholdSurvey(UrUser user) {
    return user.getHouseholdSurvey().stream().map(HouseholdSurveyDTO::from)
        .collect(Collectors.toSet());
  }

  public List<Integer> getListImage(int villageId) {
    return villageRepository.getOne(villageId).getUserSurveys().stream()
        .map(survey -> survey.getId()).collect(Collectors.toList());
  }
}
