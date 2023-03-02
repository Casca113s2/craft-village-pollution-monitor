package craftvillage.bizlayer.services;

import java.util.ArrayList;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import craftvillage.bizlayer.support_api.location.Coordinate;
import craftvillage.datalayer.entities.Village;
import craftvillage.datalayer.repositories.VillageRepository;

@Service
public class VillageServices {
  @Autowired
  VillageRepository villageRepo;

  public int newVillage(Village village) {
    try {
      if (villageRepo.countByVillageName(village.getVillageName()) > 0)
        return -1;
      return villageRepo.save(village).getVillageId();
    } catch (Exception e) {
      return 0;
    }
  }

  public boolean acceptNewVillage(int villageId) {
    try {
      Village village = villageRepo.getOne(villageId);
      village.setHasAdded(1);
      villageRepo.save(village);
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
}
