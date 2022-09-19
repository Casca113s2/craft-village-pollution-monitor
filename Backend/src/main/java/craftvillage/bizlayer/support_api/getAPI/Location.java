package craftvillage.bizlayer.support_api.getAPI;



import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import org.json.simple.parser.ParseException;

import craftvillage.bizlayer.support_api.location.Coordinate;
import craftvillage.bizlayer.support_api.location.DAO.ReWardDAO;
import craftvillage.bizlayer.support_api.location.DAO.WardDAO;
import craftvillage.bizlayer.support_api.location.entities.ReWard;
import craftvillage.bizlayer.support_api.location.entities.Ward;

public class Location {
	public static Double epsilon = 0.000000001;
	public static Coordinate coordinateIntersection(Coordinate A, Coordinate B, Coordinate C) { // Tia Cy và đoạn thẳng AB.
		Coordinate result = null;
		if(Math.abs(A.x - B.x) < epsilon) {
			result = new Coordinate(A.x, C.y);
		} else if (Math.abs(A.y - B.y) < epsilon) {
			if(Math.abs(C.y - A.y) < epsilon)
				result = C;
		} else {
			Double xx = B.x - A.x;
			Double yy = B.y - A.y;
			result = new Coordinate((C.y - A.y) * xx / yy + A.x,C.y);
		}
		if(result == null || (result.x > Math.max(A.x, B.x) || result.x < Math.min(A.x, B.x) || C.x > result.x) || 
		           (result.y > Math.max(A.y, B.y) || result.y < Math.min(A.y, B.y))) {
			return null;
		}
		return result;
	}
	
	public static Boolean checkPointInMultipolygon(List<Coordinate> coordinates, Coordinate A) {
		 
		ArrayList<Coordinate> intersections = new ArrayList<Coordinate>();
		int lenCoordinate = coordinates.size();
	    for(int i = 1;i < lenCoordinate;++i) {
	        Coordinate intersection = coordinateIntersection(coordinates.get(i - 1), coordinates.get(i), A);
	        if(intersection != (null)) {
	        	intersections.add(intersection);
	        }
	    }
	    if(intersections.size() < 1)
        	return false;
        
        Collections.sort(intersections);
        
        int cnt = intersections.size();
        int lenInters = cnt;
        
        if(Math.abs(A.x - intersections.get(0).x) < epsilon && Math.abs(A.y - intersections.get(0).y) < epsilon)
        	++cnt;
        
        if(Math.abs(A.x - intersections.get(lenInters - 1).x) < epsilon && Math.abs(A.y - intersections.get(lenInters - 1).y) < epsilon)
        	++cnt;
        
        if(Math.abs(intersections.get(0).x - intersections.get(lenInters - 1).x) < epsilon 
        		&& Math.abs(intersections.get(0).y - intersections.get(lenInters - 1).y) < epsilon &&  lenInters > 1)
        	++cnt;	
        
        return ((cnt % 2 > 0));
	}
	
	public static String getLocationCodeWard(Double lat, Double lng) throws ParseException {
		Coordinate needCheck = new Coordinate(lat,lng);
		
		List<String> wardTargets = new ArrayList<String>();
		List<ReWard> rewards = Location.getReWards();
		for(int i = 0;i < rewards.size();++i) {
			ReWard rw = rewards.get(i);
			String jsCoordinates = rw.getCoordinates();
			
			if(jsCoordinates == "" || jsCoordinates == null) continue;
			
			List<Coordinate> coordinates = needCheck.stringToListCoordinate(jsCoordinates);
			if(checkPointInMultipolygon(coordinates, needCheck)) {
				wardTargets.add(rw.getCode());
			}
		}
		
		List<Ward> wards = Location.getWardsByListCodes(wardTargets);
		for(int i = 0;i < wards.size();++i) {
			Ward rw = wards.get(i);
			String jsCoordinates = rw.getCoordinates();
			
			if(jsCoordinates == "" || jsCoordinates == null) continue;
			
			List<Coordinate> coordinates = needCheck.stringToListCoordinate(jsCoordinates);
			if(checkPointInMultipolygon(coordinates, needCheck)) {
				return rw.getCode();
			}
		}
		return null;
	}
	public static List<ReWard> getReWards() {
		ReWardDAO rewardDAO = new ReWardDAO();
        List<ReWard> rewards = rewardDAO.findAll();
        return rewards;
	}
	
	public static List<Ward> getWardsByListCodes(List<String> codes) {
		WardDAO wardDAO = new WardDAO();
        List<Ward> wards = wardDAO.findByListCode(codes);
        return wards;
	}
}