package craftvillage.bizlayer.support_api.location.DAO;

import java.util.List;

import craftvillage.bizlayer.support_api.location.entities.ReWard;
 
public class ReWardDAO extends BaseDAO {
	    @SuppressWarnings("unchecked")
	    public List<ReWard> findAll() {
	    	this.openCurrentSession();
	        List<ReWard> rewards = (List<ReWard>) getCurrentSession().createQuery("from ReWard").list();
	        this.closeCurrentSession();
	        return rewards;
	    }
}
