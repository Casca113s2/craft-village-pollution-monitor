package craftvillage.bizlayer.support_api.location.entities;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

import org.hibernate.annotations.Type;

@Entity
@Table(name="GETCODE_ReWard")
public class ReWard {
	private String code;
	@Column(name = "coordinates")
	@Type(type="text")
	private String coordinates;
	
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
	
	public String getCoordinates() {
		return coordinates;
	}
	public void setCoordinates(String coordinates) {
		this.coordinates = coordinates;
	}
	
	
 	@Id
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "UR_USER_SEQ")
	@Column(name = "ID", unique = true, nullable = false, precision = 22, scale = 0)
 	private long id;
 	public long getId() {  
 	    return id;  
 	}  
 	public void setId(long id) {  
 	    this.id = id;  
 	} 
}
