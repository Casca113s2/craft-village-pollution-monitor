package craftvillage.datalayer.entities;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import com.fasterxml.jackson.annotation.JsonBackReference;

import craftvillage.corelayer.utilities.ConstantParameter;
@Entity
@Table(name = "TEMP_VILLAGE", schema = ConstantParameter._SCHEMA_NAME)
public class TempVillage implements java.io.Serializable {

	private int id;
	private String name;
	private String coordinate;
	private Village village;
	private UserSurvey userSurvey;
	public TempVillage() {
	}

	public TempVillage(int id) {
		this.id = id;
	}
	
	public TempVillage(int id, String name, String coordinate, UserSurvey usurvey, Village village) {
		this.id = id;
		this.name = name;
		this.coordinate = coordinate;
		this.village = village;
		this.userSurvey = usurvey;
	}

	
	@Id
	@GeneratedValue(strategy = GenerationType.AUTO, generator="TEMP_VILLAGE_SEQ")
	@Column(name = "ID", unique = true, nullable = false, precision = 22, scale = 0)
	public int getId() {
		return this.id;
	}

	public void setId(int id) {
		this.id = id;
	}
	@Column(name = "NAME", length = 50)
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	@Column(name = "COORDINATE", length = 50)
	public String getCoordinate() {
		return coordinate;
	}

	public void setCoordinate(String coordinate) {
		this.coordinate = coordinate;
	}
	
	
	@JsonBackReference
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "VILLAGE_ID")
	public Village getVillage() {
		return village;
	}

	public void setVillage(Village village) {
		this.village = village;
	}
	
	@JsonBackReference
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "USER_SURVEY_ID")
	public UserSurvey getUserSurvey() {
		return userSurvey;
	}

	public void setUserSurvey(UserSurvey userSurvey) {
		this.userSurvey = userSurvey;
	}




}