package craftvillage.datalayer.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import craftvillage.datalayer.entities.HouseholdSurvey;

@Repository
public interface HouseholdSurveyRepository extends JpaRepository<HouseholdSurvey, Integer> {

}
