package craftvillage.bizlayer.services;

import java.util.ArrayList;

import org.springframework.stereotype.Service;

import craftvillage.datalayer.model.JwtModel;
@Service
public class JwtService {
	
	static ArrayList<JwtModel> jwtlist = new ArrayList<>();
	
	public void addJwtModel(JwtModel jwtModel)
	{
		jwtlist.add(jwtModel);
	}
	public void removeJwtModel(JwtModel jwtModel)
	{
		jwtlist.remove(jwtModel);
	}
	public JwtModel checkUsername(String username)
	{
		for (JwtModel i:jwtlist){
			if (username.equals(i.getUsername()))
			{
				
				return i;
			}
		}
		return null;
	}
	public boolean removeUsername(String username)
	{
		if(checkUsername(username)!=null)
			{
				jwtlist.remove(checkUsername(username));
				return true;
			}
		return false;
	}
	public int sizeJwtList()
	{
		return jwtlist.size();
	}
	public boolean checkToken(String token)
	{
		for (JwtModel i:jwtlist)
			if(token.equals(i.getToken()))
			{
				return true;
			}
		return false;
	}
	
	
}
