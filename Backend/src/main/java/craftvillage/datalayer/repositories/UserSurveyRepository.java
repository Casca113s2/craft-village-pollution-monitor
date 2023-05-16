package craftvillage.datalayer.repositories;

import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import craftvillage.datalayer.entities.UserSurvey;

@Repository
public interface UserSurveyRepository extends JpaRepository<UserSurvey, Integer> {
  UserSurvey getOne(Integer id);

  @Query(value = "select us.*"
      + " from user_survey us join village v on us.village_id = v.village_id join ad_ward w on v.ward_id = w.ward_id join ad_district d on w.district_id = d.district_id"
      + " where d.district_id = :districtId", nativeQuery = true)
  List<UserSurvey> getUserSurveyByDistrictId(@Param("districtId") Integer districtId);
}
