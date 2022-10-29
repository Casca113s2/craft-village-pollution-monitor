package craftvillage.datalayer.repositories;

import javax.transaction.Transactional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import craftvillage.datalayer.entities.AdDistrict;

@Repository
@Transactional
public interface DistrictRepository extends JpaRepository<AdDistrict, Integer> {
	
}
