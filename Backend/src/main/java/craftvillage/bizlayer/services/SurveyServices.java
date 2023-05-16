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
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import craftvillage.ai.TrainingService;
import craftvillage.datalayer.entities.HouseholdSurvey;
import craftvillage.datalayer.entities.UrUser;
import craftvillage.datalayer.entities.UserSurvey;
import craftvillage.datalayer.entities.Village;
import craftvillage.datalayer.entities.dto.HouseholdSurveyDTO;
import craftvillage.datalayer.repositories.DataSetRepository;
import craftvillage.datalayer.repositories.DistrictRepository;
import craftvillage.datalayer.repositories.HouseholdSurveyRepository;
import craftvillage.datalayer.repositories.SrSurveyQuestionAnswerRepository;
import craftvillage.datalayer.repositories.UserRepository;
import craftvillage.datalayer.repositories.UserSurveyRepository;
import craftvillage.datalayer.repositories.VillageRepository;

@Service
public class SurveyServices {
  private static Logger logger = LoggerFactory.getLogger(SurveyServices.class);
  @Autowired
  UserSurveyRepository userSurveyRepo;
  @Autowired
  HouseholdSurveyRepository householdSurveyRepo;
  @Autowired
  SrSurveyQuestionAnswerRepository surveyQuestionAnswerRepository;
  @Autowired
  UserRepository userRepository;
  @Autowired
  VillageRepository villageRepository;
  @Autowired
  DataSetRepository dataSetRepo;
  @Autowired
  TrainingService trainingService;
  @Autowired
  DistrictRepository districtRepo;

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
    UserSurvey userSurvey = userSurveyRepo.getOne(id);
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
    int villageId = user.getVillage().getVillageId();
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
    if (dataSetRepo.updateDataSetByVillageId(villageId) == 0) {
      logger.error("Fail to update data set villageId: " + villageId);
    } else {
      String result = trainingService.detectPollution(villageId);
      if (result.length() != 3) {
        logger.error("Fail to detect pollution villageId: " + villageId);
      } else {
        Village village = villageRepository.getOne(villageId);
        village.setState(result);
        villageRepository.save(village);
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

  public boolean seenSurvey(int surveyId) {
    try {
      UserSurvey survey = userSurveyRepo.getOne(surveyId);
      survey.setWarning(false);
      userSurveyRepo.save(survey);
      return true;
    } catch (Exception e) {
      e.printStackTrace();
      return false;
    }
  }
}
