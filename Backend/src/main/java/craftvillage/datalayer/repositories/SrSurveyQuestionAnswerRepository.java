package craftvillage.datalayer.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import craftvillage.datalayer.entities.SrSurveyQuestionAnswer;

@Repository
public interface SrSurveyQuestionAnswerRepository
    extends JpaRepository<SrSurveyQuestionAnswer, Integer> {

}
