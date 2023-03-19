package craftvillage.bizlayer.services;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import craftvillage.datalayer.entities.SrSurveyQuestion;
import craftvillage.datalayer.entities.SrSurveyQuestionAnswer;
import craftvillage.datalayer.repositories.SrSurveyQuestionAnswerRepository;
import craftvillage.datalayer.repositories.SrSurveyQuestionRepository;

@Service
public class SrSurveyQuestionService {
  @Autowired
  SrSurveyQuestionRepository srSurveyQuestionRepository;

  @Autowired
  SrSurveyQuestionAnswerRepository surveyQuestionAnswerRepository;

  public List<SrSurveyQuestion> findAll() {
    return srSurveyQuestionRepository.findAll();
  }

  public List<SrSurveyQuestion> findByActive(int status) {
    return srSurveyQuestionRepository.findByActive(status);
  }

  public SrSurveyQuestionAnswer findById(int id) {
    return surveyQuestionAnswerRepository.getOne(id);
  }
}
