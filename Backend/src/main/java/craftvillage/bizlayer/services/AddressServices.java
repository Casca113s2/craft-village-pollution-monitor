package craftvillage.bizlayer.services;

import java.util.List;
import java.util.Set;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import craftvillage.datalayer.entities.AdCountry;
import craftvillage.datalayer.entities.AdDistrict;
import craftvillage.datalayer.entities.AdProvince;
import craftvillage.datalayer.entities.AdWard;
import craftvillage.datalayer.entities.Village;
import craftvillage.datalayer.repositories.CountryRepository;
import craftvillage.datalayer.repositories.DistrictRepository;
import craftvillage.datalayer.repositories.ProvinceRepository;
import craftvillage.datalayer.repositories.VillageRepository;
import craftvillage.datalayer.repositories.WardRepository;

@Service
public class AddressServices {
  @Autowired
  CountryRepository countryRepo;
  @Autowired
  ProvinceRepository provinceRepo;
  @Autowired
  DistrictRepository districtRepo;
  @Autowired
  WardRepository wardRepo;
  @Autowired
  VillageRepository villageRepo;

  public List<AdCountry> getCountryList() {
    return countryRepo.findAll();
  }

  public Set<AdProvince> getProvinceList(int countryId) {
    return countryRepo.getOne(countryId).getAdProvinces();
  }

  public Set<AdDistrict> getDistrictList(int provinceId) {
    return provinceRepo.getOne(provinceId).getAdDistricts();
  }

  public Set<AdWard> getWardList(int districtId) {
    return districtRepo.getOne(districtId).getAdWards();
  }

  public AdDistrict getAdDistrict(int districtId) {
    return districtRepo.getOne(districtId);
  }

  public AdWard getAdward(int adWardId) {
    return wardRepo.getOne(adWardId);
  }

  public Set<Village> getVillages(int wardId) {
    return wardRepo.getOne(wardId).getVillages();
  }

  public Village getVillageInfo(int villageId) {
    return villageRepo.getOne(villageId);
  }
}
