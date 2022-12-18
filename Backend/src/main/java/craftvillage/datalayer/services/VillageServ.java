package craftvillage.datalayer.services;

import java.util.ArrayList;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import craftvillage.bizlayer.support_api.location.Coordinate;
import craftvillage.datalayer.dao.CrudDao;
import craftvillage.datalayer.entities.Village;
import craftvillage.datalayer.repositories.VillageRepository;

@Repository
public class VillageServ {

  @Autowired
  VillageRepository villageRepo;

  public boolean addVillage(Village village) {
    CrudDao<Village> vil = new CrudDao<>(Village.class);
    boolean check = vil.addObject(village);
    return check;
  }

  public Village findVillageByObject(Village village) {

    CrudDao<Village> crudVillage = new CrudDao<>(Village.class);
    String hql = "SELECT c FROM Village c Where c.villageName = '" + village.getVillageName()
        + "' and c.coordinate = '" + village.getCoordinate() + "' and c.note = '"
        + village.getNote() + "' and c.hasAdded = " + village.getHasAdded() + " ";
    if (crudVillage.queyObject(hql).size() == 0)
      return null;
    Village vill = crudVillage.queyObject(hql).get(0);
    return vill;
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
