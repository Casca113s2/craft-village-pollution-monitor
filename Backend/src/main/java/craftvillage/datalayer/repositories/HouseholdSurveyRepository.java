package craftvillage.datalayer.repositories;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import craftvillage.datalayer.entities.HouseholdSurvey;
import craftvillage.datalayer.entities.UrUser;

@Repository
public interface HouseholdSurveyRepository extends JpaRepository<HouseholdSurvey, Integer> {
  List<HouseholdSurvey> findByHousehold(UrUser household);
}
