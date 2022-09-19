package craftvillage.datalayer.model;

import java.util.Date;

public class ActiveUserModel {

	private String Username;
	private String ActiveNumber;
	private Date DateCreate;
	public String getUsername() {
		return Username;
	}
	public void setUsername(String username) {
		Username = username;
	}
	public String getActiveNumber() {
		return ActiveNumber;
	}
	public void setActiveNumber(String activeNumber) {
		ActiveNumber = activeNumber;
	}
	public Date getDateCreate() {
		return DateCreate;
	}
	public void setDateCreate(Date dateCreate) {
		DateCreate = dateCreate;
	}
	public ActiveUserModel(String username, String activeNumber, Date dateCreate) {
		super();
		Username = username;
		ActiveNumber = activeNumber;
		DateCreate = dateCreate;
	}
	
}
