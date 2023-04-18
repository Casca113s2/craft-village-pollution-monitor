package craftvillage.bizlayer.support_api.location;

import java.util.ArrayList;
import java.util.List;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

public class Coordinate {
  public static Double epsilon = 0.5;
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
    for (int i = 0; i < coordinatesO.size(); ++i) {
      JSONObject tmp = (JSONObject) coordinatesO.get(i);
      result.add(new Coordinate((double) tmp.get("x"), (double) tmp.get("y")));
    }
    return result;
  }

  public boolean compareTo(Coordinate u) {
    return distance(this.x, u.x, this.y, u.y) <= epsilon;
  }

  private double distance(double lat1, double lat2, double lon1, double lon2) {
    // The math module contains a function
    // named toRadians which converts from
    // degrees to radiant.
    lon1 = Math.toRadians(lon1);
    lon2 = Math.toRadians(lon2);
    lat1 = Math.toRadians(lat1);
    lat2 = Math.toRadians(lat2);

    // Haversine formula
    double dlon = lon2 - lon1;
    double dlat = lat2 - lat1;
    double a = Math.pow(Math.sin(dlat / 2), 2)
        + Math.cos(lat1) * Math.cos(lat2) * Math.pow(Math.sin(dlon / 2), 2);

    double c = 2 * Math.asin(Math.sqrt(a));

    // Radius of earth in kilometers. Use 3956
    // for miles
    double r = 6371;

    // calculate the result
    return (c * r);
  }
}
