package craftvillage.datalayer.services;

import java.util.List;
import java.util.Set;
import org.springframework.stereotype.Repository;
import craftvillage.datalayer.dao.CrudDao;
import craftvillage.datalayer.entities.AdCountry;
import craftvillage.datalayer.entities.AdDistrict;
import craftvillage.datalayer.entities.AdProvince;
import craftvillage.datalayer.entities.AdWard;
import craftvillage.datalayer.entities.Village;


@Repository
public class AddressServ {
  public String getInfoCountry(int countryId) {
    CrudDao<AdCountry> countryDao = new CrudDao<>(AdCountry.class);
    String countryname = countryDao.findById(countryId).getCountryName();
    return countryname;
  }

  public String getInfoProvince(int provinceId) {

    CrudDao<AdProvince> countryDao = new CrudDao<>(AdProvince.class);
    String provincename = countryDao.findById(provinceId).getProvinceName();
    return provincename;
  }

  public String getInfoDictrict(int dictrictId) {

    CrudDao<AdDistrict> countryDao = new CrudDao<>(AdDistrict.class);
    String dictrictname = countryDao.findById(dictrictId).getDistrictName();
    return dictrictname;
  }

  public String getInfoWard(int wardId) {

    CrudDao<AdWard> countryDao = new CrudDao<>(AdWard.class);
    String wardname = countryDao.findById(wardId).getWardName();
    return wardname;
  }



  public List<AdCountry> getCountryList() {

    CrudDao<AdCountry> countryDao = new CrudDao<>(AdCountry.class);
    List<AdCountry> lst = countryDao.queyObject("SELECT c FROM AdCountry c");
    return lst;
  }



  public Set<AdProvince> getProvinceList(int countryId) {

    CrudDao<AdCountry> countryDao = new CrudDao<>(AdCountry.class);
    Set<AdProvince> lst = countryDao.findById(countryId).getAdProvinces();
    return lst;
  }

  public Set<AdDistrict> getDistrictList(int provinceId) {

    CrudDao<AdProvince> provinceDao = new CrudDao<>(AdProvince.class);
    Set<AdDistrict> lst = provinceDao.findById(provinceId).getAdDistricts();
    return lst;
  }

  public Set<AdWard> getWardList(int districtId) {
    CrudDao<AdDistrict> districtDao = new CrudDao<>(AdDistrict.class);
    Set<AdWard> lst = districtDao.findById(districtId).getAdWards();
    return lst;
  }

  public AdWard getWard(int adWardId) {
    CrudDao<AdWard> adWardDao = new CrudDao<>(AdWard.class);
    AdWard adWard = adWardDao.findById(adWardId);
    return adWard;
  }

  public Set<Village> getAllVillage(int wardId) {
    CrudDao<AdWard> AdwardDao = new CrudDao<AdWard>(AdWard.class);
    Set<Village> villageLst = AdwardDao.findById(wardId).getVillages();
    return villageLst;
  }

  public Set<Village> getPickVillage(int wardId) {
    CrudDao<AdWard> adwardDao = new CrudDao<AdWard>(AdWard.class);
    Set<Village> lst = adwardDao.findById(wardId).getVillages();
    return lst;
  }


  public Village getVillageInfo(int villageId) {
    CrudDao<Village> villageDao = new CrudDao<>(Village.class);
    return villageDao.findById(villageId);
  }

  public List<Village> getAllVillage() {
    CrudDao<Village> villageDao = new CrudDao<>(Village.class);
    List<Village> villageLst = villageDao.queyObject("SELECT c FROM Village c");
    return villageLst;
  }

}
