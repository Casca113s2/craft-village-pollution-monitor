package craftvillage.datalayer.repositories;

import javax.transaction.Transactional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import craftvillage.datalayer.entities.AdWard;

@Repository
@Transactional
public interface WardRepository extends JpaRepository<AdWard, Integer> {

}
