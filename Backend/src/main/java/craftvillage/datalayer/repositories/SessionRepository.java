package craftvillage.datalayer.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import craftvillage.datalayer.entities.UrSession;

@Repository
public interface SessionRepository extends JpaRepository<UrSession, Integer> {
  UrSession findBySessionString(String sessionString);
}
