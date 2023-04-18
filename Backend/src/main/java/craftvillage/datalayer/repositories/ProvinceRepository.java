package craftvillage.datalayer.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import craftvillage.datalayer.entities.AdProvince;

@Repository
public interface ProvinceRepository extends JpaRepository<AdProvince, Integer> {

}
