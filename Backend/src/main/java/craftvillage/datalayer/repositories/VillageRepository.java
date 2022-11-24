package craftvillage.datalayer.repositories;

import org.springframework.stereotype.Repository;

import craftvillage.datalayer.entities.Village;

import javax.transaction.Transactional;

import org.springframework.data.jpa.repository.JpaRepository;

@Repository
@Transactional
public interface VillageRepository extends JpaRepository<Village, Integer> {
	long countByVillageName(String villageName);
}
