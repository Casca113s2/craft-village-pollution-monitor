package craftvillage.bizlayer.services;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import craftvillage.bizlayer.support_api.location.Coordinate;
import craftvillage.datalayer.entities.Village;
import craftvillage.datalayer.repositories.VillageRepository;
import craftvillage.datalayer.services.SurveyServ;
import craftvillage.datalayer.services.VillageServ;

@Service
public class VillageServices {
	@Autowired
	VillageServ villageServ = new VillageServ();
	
	@Autowired
	VillageRepository villageRepo;
	
	public int newVillage(Village village) {
		try {
			if(villageRepo.countByVillageName(village.getVillageName())>0)
				return -1;
			return villageRepo.save(village).getVillageId();
		}
		catch(Exception e) {
			return 0;
		}
	}
	
	public boolean acceptNewVillage(int villageId) {
		try {
			Village village = villageRepo.getOne(villageId);
			village.setHasAdded(1);
			villageRepo.save(village);
			return true;
		}
		catch(Exception e) {
			return false;
		}
	}
	
	public boolean denyNewVillage(int villageId) {
		try {
			villageRepo.deleteById(villageId);
			return true;
		}
		catch(Exception e) {
			return false;
		}
	}
	
	public List<Village> getAll() {
		return villageRepo.findAll();
	}
	
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
