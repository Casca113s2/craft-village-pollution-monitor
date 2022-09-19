package craftvillage.bizlayer.support_api.location;
import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.List;


import org.hibernate.Session;  
import org.hibernate.SessionFactory;  
import org.hibernate.Transaction;  
import org.hibernate.boot.Metadata;  
import org.hibernate.boot.MetadataSources;  
import org.hibernate.boot.registry.StandardServiceRegistry;  
import org.hibernate.boot.registry.StandardServiceRegistryBuilder;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

import craftvillage.bizlayer.support_api.location.entities.*;

public class InitDatabase {
	// run once, when start project.
	public static void main(String[] args) throws IOException, ParseException {
		saveWards();
		saveReWards();
	}
	
	// import xa
	public static void saveWards() throws IOException, ParseException {
		StandardServiceRegistry ssr=new StandardServiceRegistryBuilder().configure("hibernate2.cfg.xml").build();  
		   Metadata meta=new MetadataSources(ssr).getMetadataBuilder().build();  
		     
		   SessionFactory factory=meta.getSessionFactoryBuilder().build();  
		   Session session=factory.openSession();  
		     
		   Transaction t=session.beginTransaction();
		   
		   BufferedReader objReader = new BufferedReader(new FileReader("src/main/resources/danh_sach_xa.txt"));
		   String strJsonWard = objReader.readLine();
		   JSONArray jsaWard = new JSONArray();
		   JSONParser parser = new JSONParser();
		   jsaWard = (JSONArray) parser.parse(strJsonWard);
		   
		   
		   // coordinate 
		   objReader = new BufferedReader(new FileReader("src/main/resources/geoserver-all.json"));
		   strJsonWard = objReader.readLine();
		   JSONArray coordinates = new JSONArray();
		   JSONArray jsaCoordinates = (JSONArray)((JSONObject) parser.parse(strJsonWard)).get("features");

		   for(int i = 0, dk = jsaWard.size();i < dk;++i) {
			   JSONObject jsoWard = (JSONObject) jsaWard.get(i);
			   Ward ward = new Ward();
			   
			   String code = (String)jsoWard.get("xa");
			   ward.setCode(code);
			   
			   // coordinates
			   for(int j = 0;j < jsaCoordinates.size();++j) {
				   JSONObject xcdn = (JSONObject) jsaCoordinates.get(j);
				   String cd = (String)((JSONObject)xcdn.get("properties")).get("Ma");

				   if(code.equals(cd)) {
					   xcdn = (JSONObject)xcdn.get("geometry");
					   
					   JSONArray xcdns = (JSONArray) xcdn.get("coordinates");
					   xcdns = (JSONArray)xcdns.get(0);
					   xcdns = (JSONArray)xcdns.get(0);
					   // to x, y 
					   JSONArray coordinatesString = new JSONArray();
					   for(int z = 0;z < xcdns.size();++z) {
						   JSONObject tmp_ = new JSONObject();
						   tmp_.put("x", ((JSONArray)xcdns.get(z)).get(0));
						   tmp_.put("y", ((JSONArray)xcdns.get(z)).get(1));
						   coordinatesString.add(tmp_);
					   }
					   ward.setCoordinates(coordinatesString.toJSONString());
					   break;
				   }
			   }
			   session.persist(ward);
		   }
		   
		   t.commit();
		   session.close();
	}
	
	public static void saveReWards() throws IOException, ParseException {
		StandardServiceRegistry ssr=new StandardServiceRegistryBuilder().configure("hibernate2.cfg.xml").build();  
		   Metadata meta=new MetadataSources(ssr).getMetadataBuilder().build();  
		     
		   SessionFactory factory=meta.getSessionFactoryBuilder().build();  
		   Session session=factory.openSession();  
		     
		   Transaction t=session.beginTransaction();
		   
		   BufferedReader objReader = new BufferedReader(new FileReader("src/main/resources/rectangleCoordinatesWard.json"));
		   String strJsonWard = objReader.readLine();
		   JSONParser parser = new JSONParser();
		   JSONArray jsaWard = (JSONArray) parser.parse(strJsonWard);

		   for(int i = 0, dk = jsaWard.size();i < dk;++i) {
			   JSONObject jsoWard = (JSONObject) jsaWard.get(i);
			   ReWard rew = new ReWard();
			   
			   String code = (String)jsoWard.get("code");
			   JSONArray coordinates = (JSONArray) jsoWard.get("rectangleCoordinates");
			   rew.setCode(code);
			   rew.setCoordinates(coordinates.toJSONString());
			   
			   session.persist(rew);
		   }
		   
		   t.commit();
		   session.close();
	}
}
