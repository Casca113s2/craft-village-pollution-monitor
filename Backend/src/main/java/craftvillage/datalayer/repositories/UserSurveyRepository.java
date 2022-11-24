package craftvillage.datalayer.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import craftvillage.datalayer.entities.UserSurvey;

@Repository
public interface UserSurveyRepository extends JpaRepository<UserSurvey, Integer> {
  UserSurvey getOne(Integer id);
}
