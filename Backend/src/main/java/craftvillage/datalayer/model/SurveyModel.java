package craftvillage.datalayer.model;

import com.fasterxml.jackson.annotation.JsonProperty;

public class SurveyModel {
	@JsonProperty("name")
	private String name;
	@JsonProperty("value")
	private String value;
	@JsonProperty("name")
	public String getName() {
		return name;
	}
	@JsonProperty("name")
	public void setName(String name) {
		this.name = name;
	}
	@JsonProperty("value")
	public String getValue() {
		return value;
	}
	@JsonProperty("value")
	public void setValue(String value) {
		this.value = value;
	}
	
}
