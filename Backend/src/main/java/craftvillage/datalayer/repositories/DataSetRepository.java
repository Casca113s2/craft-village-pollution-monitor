package craftvillage.datalayer.repositories;

import java.util.List;
import javax.transaction.Transactional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.stereotype.Repository;
import craftvillage.ai.DataSet;

@Repository
@Transactional
public interface DataSetRepository extends JpaRepository<DataSet, Integer> {
  @Procedure(procedureName = "proc_update_all_data_set")
  double updateAllDataSet();

  @Procedure(procedureName = "proc_update_data_set_by_village_id")
  double updateDataSetByVillageId(int villageId);

  List<DataSet> findByVillageId(int villageId);

  @Query(value = "select distinct village_id from data_set", nativeQuery = true)
  List<Integer> getAllVillageId();
}
