package craftvillage.bizlayer.services;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import craftvillage.bizlayer.support_api.location.Coordinate;
import craftvillage.datalayer.entities.Village;
import craftvillage.datalayer.services.SurveyServ;
import craftvillage.datalayer.services.VillageServ;

@Service
public class VillageServices {
	@Autowired
	VillageServ villageServ = new VillageServ();
	public boolean addVillage(Village village) {
		return villageServ.addVillage(village);
	}
	public Village findVillageByObject(Village village) {
		return villageServ.findVillageByObject(village);
	}
//	public Village findVillageByCoordinate(Coordinate coordinate) {
//		return villageServ.findVillageByCoordinate(coordinate);
//	}
	
	public List<Village> findVillageByCoordinate(Coordinate coordinate) {
		return villageServ.findVillageByCoordinate(coordinate);
	}
}
