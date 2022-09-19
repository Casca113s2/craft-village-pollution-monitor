package craftvillage.bizlayer.services;

import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import craftvillage.datalayer.entities.AdCountry;
import craftvillage.datalayer.entities.AdDistrict;
import craftvillage.datalayer.entities.AdProvince;
import craftvillage.datalayer.entities.AdWard;
import craftvillage.datalayer.entities.UrUser;
import craftvillage.datalayer.entities.UserSurvey;
import craftvillage.datalayer.entities.Village;
import craftvillage.datalayer.services.AddressServ;
import craftvillage.datalayer.services.UserServ;
@Service
public class AddressServices {
	@Autowired
	AddressServ addressServ = new AddressServ();
	UserServ userServ = new UserServ();
	public List<AdCountry> getCountryList() {
		
		return addressServ.getCountryList();
	}
	public Set<AdProvince> getProvinceList(int countryId)
	{
		return addressServ.getProvinceList(countryId);
	}
	public Set<AdDistrict> getDistrictList(int provinceId)
	{
		return addressServ.getDistrictList(provinceId);
	}
	public Set<AdWard> getWardList(int districtId)
	{
		return addressServ.getWardList(districtId);
	}
	public String getInfoCountry(int countryId) {
		return addressServ.getInfoCountry(countryId);
	}
	public String getInfoProvince(int provinceId) {
		return addressServ.getInfoProvince(provinceId);
	}
	public String getInfoDictrict(int dictrictId) {
		return addressServ.getInfoDictrict(dictrictId);
	}
	public String getInfoWard(int wardId) {
		return addressServ.getInfoWard(wardId);
	}
	public AdWard getAdward(int adWardId)
	{
		return addressServ.getWard(adWardId);
	}
	public Set<Village> getPickVillage(int wardId) {
		return addressServ.getPickVillage(wardId);
	}
	public boolean SubmitVillageInfo(String villageName , String coordinate , UserSurvey userSurvey , Village village)
	{
		return addressServ.SubmitVillageInfo(villageName, coordinate, userSurvey, village);
	}
	public Village getVillageInfo(int villageId)
	{
		return addressServ.getVillageInfo(villageId);
	}
	public List<Village> getAllVillage()
	{
		return addressServ.getAllVillage();
	}
	public boolean DeleteTempVillage(UrUser user , String status)
	{
		return addressServ.DeleteTempVillage(user, status);
	}
	public boolean checkVillage(int villageId , UrUser user , String status)
	{
		return userServ.checkVillage(villageId, user, status);
	}
	
	
	
	
	/**
	 * Hàm tính khoảng cách 2 điểm bằng lat , lon
	 * @param lat1
	 * @param lon1
	 * @param lat2
	 * @param lon2
	 * @return
	 */
	 public double distance(double lat1, double lon1, double lat2, double lon2) {
	      double theta = lon1 - lon2;
	      double dist = Math.sin(deg2rad(lat1)) * Math.sin(deg2rad(lat2)) + Math.cos(deg2rad(lat1)) * Math.cos(deg2rad(lat2)) * Math.cos(deg2rad(theta));
	      dist = Math.acos(dist);
	      dist = rad2deg(dist);
	      dist = dist * 60 * 1.1515;
	      return (dist);
	    }

	    /*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
	    /*::  This function converts decimal degrees to radians             :*/
	    /*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
	    private double deg2rad(double deg) {
	      return (deg * Math.PI / 180.0);
	    }

	    /*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
	    /*::  This function converts radians to decimal degrees             :*/
	    /*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
	    private double rad2deg(double rad) {
	      return (rad * 180.0 / Math.PI);
	    }
	
	public double convertCoordinates(double degrees , double minutes, double seconds  )
	{
		
		double decimal = ((minutes * 60)+seconds) / (60*60);
		decimal = decimal + degrees;
		return decimal;
	}
	
	
	
}
