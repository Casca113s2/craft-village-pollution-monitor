package craftvillage.bizlayer.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import craftvillage.datalayer.entities.UrUser;
import craftvillage.datalayer.repositories.UserRepository;

@Service
public class UserService {
	@Autowired
	private UserRepository userRepo;
	
	public UrUser save(UrUser user) {
		return userRepo.save(user);
	}
	
	public UrUser findByUsername(String username) {
		return userRepo.findByAccount(username);
	}
}
