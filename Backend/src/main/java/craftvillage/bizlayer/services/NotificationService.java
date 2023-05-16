package craftvillage.bizlayer.services;

import java.util.List;
import java.util.stream.Collectors;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import craftvillage.datalayer.entities.dto.PollutionWarningDTO;
import craftvillage.datalayer.repositories.UserSurveyRepository;

@Service
public class NotificationService {
  @Autowired
  UserSurveyRepository userSurveyRepo;

  public List<PollutionWarningDTO> getPollutionWarnings(int districtId) {
    return userSurveyRepo.getUserSurveyByDistrictId(districtId).stream()
        .filter(item -> item.getWarning()).map(PollutionWarningDTO::from)
        .collect(Collectors.toList());
  }
}
