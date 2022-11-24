package craftvillage.datalayer.services;

import java.util.ArrayList;
import java.util.List;
import org.springframework.stereotype.Repository;
import craftvillage.bizlayer.support_api.location.Coordinate;
import craftvillage.datalayer.dao.CrudDao;
import craftvillage.datalayer.entities.Village;

@Repository
public class VillageServ {

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

  public List<Village> findVillageByCoordinate(Coordinate coordinate) {

    CrudDao<Village> crudVillage = new CrudDao<>(Village.class);
    String hql = "SELECT c FROM Village c";
    if (crudVillage.queyObject(hql).size() == 0)
      return null;
    List<Village> listVillage = crudVillage.queyObject(hql);
    List<Village> villages = new ArrayList<Village>();
    for (int i = 0; i < listVillage.size(); i++) {
      Coordinate temp = toCoordinate(listVillage.get(i).getCoordinate());
      if (coordinate.compareTo(temp) == 0)
        villages.add(listVillage.get(i));
    }
    return villages;
  }

  private Coordinate toCoordinate(String coordinate) {
    double x, y;
    String strX = "", strY = "";
    int i = 0;
    while (coordinate.charAt(i) != ',') {
      strX += coordinate.charAt(i);
      i++;
    }
    i += 1;
    while (i < coordinate.length()) {
      strY += coordinate.charAt(i);
      i++;
    }
    x = Double.parseDouble(strX);
    y = Double.parseDouble(strY);
    return new Coordinate(x, y);
  }
}
