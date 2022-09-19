package craftvillage.datalayer.model;

import java.util.ArrayList;
import java.util.HashMap;

public class JwtModel {
	private String token;
	private String username;
	//private HashMap<String , String > jwtlist = new HashMap<>();
	public String getToken() {
		return token;
	}
	public void setToken(String token) {
		this.token = token;
	}
	public JwtModel(String token,String username) {
		super();
		this.token = token;
		this.setUsername(username);
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	

	 
}
 