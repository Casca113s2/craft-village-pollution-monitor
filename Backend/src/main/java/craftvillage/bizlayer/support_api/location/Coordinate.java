package craftvillage.bizlayer.support_api.location;

import java.util.ArrayList;
import java.util.List;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

public class Coordinate implements Comparable<Coordinate>{
	public static Double epsilon = 0.01;
	public Double x;
	public Double y;
	public Coordinate() {
		this.x = -1.0;
		this.y = -1.0;
	}
	public Coordinate(Double x, Double y) {
		this.x = x;
		this.y = y;
	}
	public List<Coordinate> stringToListCoordinate(String json) throws ParseException {
		List<Coordinate> result = new ArrayList<Coordinate>();
		JSONArray coordinatesO = new JSONArray();
		JSONParser parser = new JSONParser();
		coordinatesO = (JSONArray) parser.parse(json);
		for(int i = 0;i < coordinatesO.size();++i) {
			JSONObject tmp = (JSONObject) coordinatesO.get(i);
			result.add(new Coordinate((Double)tmp.get("x"),(Double)tmp.get("y")));
		}
		return result;
	}

	public int compareTo(Coordinate u) {
		if(Math.abs(this.x - u.x) < epsilon && Math.abs(this.y - u.y) < epsilon) return 0;
		if(Math.abs(this.x - u.x) < epsilon) return (this.y > u.y ? 1 : -1);
		return (this.x > u.x ? 1 : -1);
    }
}