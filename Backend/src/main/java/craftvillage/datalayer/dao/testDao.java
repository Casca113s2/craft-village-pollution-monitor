package craftvillage.datalayer.dao;

import craftvillage.datalayer.entities.Village;

public class testDao {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		CrudDao<Village> villageDao = new CrudDao<>(Village.class);
		Village x = villageDao.findById(1);
		//System.out.println(x.getCoordinate()+"///"+ x.getAdWard().getWardName()+"///"+ x.getUrUser().getEmail());
	}

}
