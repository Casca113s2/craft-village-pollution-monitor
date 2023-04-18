package craftvillage.datalayer.repositories;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import craftvillage.datalayer.entities.AdCountry;

@Repository
public interface CountryRepository extends JpaRepository<AdCountry, Integer> {

}
