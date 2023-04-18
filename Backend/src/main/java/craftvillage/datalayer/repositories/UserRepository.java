package craftvillage.datalayer.repositories;

import javax.transaction.Transactional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import craftvillage.datalayer.entities.UrUser;

@Repository
@Transactional
public interface UserRepository extends JpaRepository<UrUser, Integer> {
  UrUser findByAccount(String username);

  UrUser findByEmail(String email);

  UrUser findByPhone(String phone);
}
