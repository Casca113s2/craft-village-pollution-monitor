package craftvillage.bizlayer.services;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import craftvillage.datalayer.entities.SrSurveyQuestion;
import craftvillage.datalayer.entities.SrSurveyQuestionAnswer;
import craftvillage.datalayer.entities.dto.UpdatedQuestionDTO;
import craftvillage.datalayer.repositories.SrSurveyQuestionAnswerRepository;
import craftvillage.datalayer.repositories.SrSurveyQuestionRepository;

@Service
public class SrSurveyQuestionService {
  @Autowired
  SrSurveyQuestionRepository srSurveyQuestionRepository;
  @Autowired
  SrSurveyQuestionAnswerRepository surveyQuestionAnswerRepository;
  @Autowired
  SrSurveyQuestionRepository surveyQuestionRepo;

  public List<SrSurveyQuestion> findAll() {
    return srSurveyQuestionRepository.findAll();
  }

  public List<SrSurveyQuestion> findByActive(int status) {
    return srSurveyQuestionRepository.findByActiveOrderByRequiredDesc(status);
  }

  public SrSurveyQuestionAnswer findById(int id) {
    return surveyQuestionAnswerRepository.getOne(id);
  }

  public boolean updateQuestion(List<UpdatedQuestionDTO> questions) {
    for (UpdatedQuestionDTO updatedQuestionDTO : questions) {
      SrSurveyQuestion question = surveyQuestionRepo.getOne(updatedQuestionDTO.getQuestionId());
      if (question == null)
        return false;
      question.setRequired(updatedQuestionDTO.getRequired());
      surveyQuestionRepo.save(question);
    }
    return true;
  }
}
