package craftvillage.bizlayer.services;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import craftvillage.bizlayer.support_api.location.Coordinate;
import craftvillage.datalayer.entities.Village;
import craftvillage.datalayer.repositories.DataSetRepository;
import craftvillage.datalayer.repositories.VillageRepository;
import craftvillage.datalayer.repositories.WardRepository;

@Service
public class VillageServices {
  @Autowired
  VillageRepository villageRepo;
  @Autowired
  WardRepository wardRepo;
  @Autowired
  DataSetRepository dataSetRepo;

  private static final Logger logger = LoggerFactory.getLogger(VillageServices.class);

  public int newVillage(Village village) {
    try {
      if (villageRepo.countByVillageName(village.getVillageName()) > 0)
        return -1;
      int villageId = villageRepo.save(village).getVillageId();
      this.insertDataSet(villageId);
      return villageId;
    } catch (Exception e) {
      return 0;
    }
  }

  public boolean acceptNewVillage(int villageId) {
    try {
      Village village = villageRepo.getOne(villageId);
      village.setHasAdded(1);
      villageRepo.save(village);
      this.insertDataSet(villageId);
      return true;
    } catch (Exception e) {
      return false;
    }
  }

  public boolean denyNewVillage(int villageId) {
    try {
      villageRepo.deleteById(villageId);
      return true;
    } catch (Exception e) {
      return false;
    }
  }

  public List<Village> getAll() {
    return villageRepo.findAll();
  }

  public Village findVillageById(int id) {
    return villageRepo.getOne(id);
  }

  public List<Village> findVillageByCoordinate(Coordinate currentCoordinate) {
    List<Village> detectedVillages = new ArrayList<Village>();
    List<Village> villages = villageRepo.findAll();
    for (Village village : villages) {
      Coordinate coordinate = toCoordinate(village.getCoordinate());
      if (village.getHasAdded() == 1 && currentCoordinate.compareTo(coordinate)) {
        detectedVillages.add(village);
      }
    }
    return detectedVillages;
  }

  public Map<String, Object> getVillageMapInfo(int villageId) {
    Map<String, Object> result = new HashMap<String, Object>();
    Village village = villageRepo.getOne(villageId);
    result.put("villageName", village.getVillageName());
    result.put("wardName", village.getAdWard().getWardName());
    result.put("numberOfHousehold", village.getHouseholds().size());
    result.put("coordinate", village.getCoordinate());
    result.put("state", village.getState());
    return result;
  }

  public Village updateVillage(Map<String, String> villageInfo) {
    Village village = villageRepo.getOne(Integer.parseInt(villageInfo.get("villageId")));
    village.setAdWard(wardRepo.getOne(Integer.parseInt(villageInfo.get("wardId"))));
    village.setVillageName(villageInfo.get("villageName"));
    village.setCoordinate(villageInfo.get("latitude") + ", " + villageInfo.get("longitude"));
    village.setNote(villageInfo.get("note"));
    return villageRepo.save(village);
  }

  private Coordinate toCoordinate(String coordinate) {
    double x, y;
    String strX = "", strY = "";
    int i = 0;
    while (coordinate.charAt(i) != ',') {
      strX += coordinate.charAt(i);
      i++;
    }
    i += 2;
    while (i < coordinate.length()) {
      strY += coordinate.charAt(i);
      i++;
    }
    x = Double.parseDouble(strX);
    y = Double.parseDouble(strY);
    return new Coordinate(x, y);
  }

  private void insertDataSet(int villageId) {
    if (dataSetRepo.addNewDataSet(villageId) > 0) {
      logger.info("Inserted new data set, village id: " + villageId);
    } else {
      logger.info("Failed to insert new data set, village id: " + villageId);
    }
  }
}
