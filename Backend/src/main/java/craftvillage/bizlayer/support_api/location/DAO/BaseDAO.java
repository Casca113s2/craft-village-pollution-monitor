package craftvillage.bizlayer.support_api.location.DAO;


import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.boot.Metadata;
import org.hibernate.boot.MetadataSources;
import org.hibernate.boot.registry.StandardServiceRegistry;
import org.hibernate.boot.registry.StandardServiceRegistryBuilder;

public class BaseDAO {
	    private Session currentSession;
	     
	    private Transaction currentTransaction;
	 
	    public Session openCurrentSession() {
    		StandardServiceRegistry ssr=new StandardServiceRegistryBuilder().configure("hibernate.cfg.xml").build();  
    		Metadata meta=new MetadataSources(ssr).getMetadataBuilder().build();  
		     
    		SessionFactory factory=meta.getSessionFactoryBuilder().build();  
    		Session session=factory.openSession(); 
    		currentSession = session;
    		return session;
	    }
	    public void closeCurrentSession() {
	        currentSession.close();
	    }
	    public Session getCurrentSession() {
	        return currentSession;
	    }
	    public Transaction getCurrentTransaction() {
	        return currentTransaction;
	    }
}
