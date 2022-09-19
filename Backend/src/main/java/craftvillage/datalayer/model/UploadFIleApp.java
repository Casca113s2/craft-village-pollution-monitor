package craftvillage.datalayer.model;

import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonPropertyOrder;
@JsonInclude(JsonInclude.Include.NON_NULL)
@JsonPropertyOrder({ "file", "latitude", "longitude" })
public class UploadFIleApp {
	@JsonProperty("file")
	private MultipartFile file ;
	@JsonProperty("latitude")
	private String latitude;
	@JsonProperty("longitude")
	private String longitude;
	public MultipartFile getFile() {
		return file;
	}
	public void setFile(MultipartFile file) {
		this.file = file;
	}
	public String getLatitude() {
		return latitude;
	}
	public void setLatitude(String latitude) {
		this.latitude = latitude;
	}
	public String getLongitude() {
		return longitude;
	}
	public void setLongitude(String longitude) {
		this.longitude = longitude;
	}
	

}
