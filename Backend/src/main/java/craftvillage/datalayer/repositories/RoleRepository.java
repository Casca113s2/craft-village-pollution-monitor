package craftvillage.datalayer.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import craftvillage.datalayer.entities.UrRole;

@Repository
public interface RoleRepository extends JpaRepository<UrRole, Integer> {

}
