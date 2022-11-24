package craftvillage.datalayer.repositories;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import craftvillage.datalayer.entities.SrSurveyQuestion;

public interface SrSurveyQuestionRepository extends JpaRepository<SrSurveyQuestion, Integer> {
  List<SrSurveyQuestion> findByActive(int active);
}
