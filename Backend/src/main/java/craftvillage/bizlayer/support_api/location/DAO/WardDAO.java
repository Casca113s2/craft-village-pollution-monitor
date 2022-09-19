package craftvillage.bizlayer.support_api.location.DAO;

import java.util.List;

import org.hibernate.Query;
import org.hibernate.Session;

import craftvillage.bizlayer.support_api.location.entities.Ward;
 
public class WardDAO extends BaseDAO {
	   public List<Ward> findByListCode(List<String> codes) {
		    this.openCurrentSession();
	    	Session session = getCurrentSession();
	    	Query<Ward> query = session.createQuery("from Ward as w where w.code in :codes ", Ward.class);
	    
	    	query.setParameterList("codes", codes);
	    	List<Ward> wards = query.getResultList();
	        this.closeCurrentSession();
	    	return wards; 
	    }
}
