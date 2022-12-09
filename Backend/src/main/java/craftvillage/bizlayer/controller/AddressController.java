package craftvillage.bizlayer.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import craftvillage.bizlayer.services.AddressServices;
import craftvillage.corelayer.utilities.ConstantParameter;
import craftvillage.datalayer.entities.AdCountry;
import craftvillage.datalayer.entities.AdDistrict;
import craftvillage.datalayer.entities.AdProvince;
import craftvillage.datalayer.entities.AdWard;
import craftvillage.datalayer.entities.Village;

@RestController
@RequestMapping("/" + ConstantParameter._URL_ROOT + "/" + ConstantParameter._URL_API + "/"
    + ConstantParameter.ServiceAddress._ADDRESS_SERVICE)
public class AddressController {
  @Autowired
  private AddressServices addressService;

  @RequestMapping(value = "/" + ConstantParameter.ServiceAddress._ADDRESS_GET_COUNTRY,
      method = RequestMethod.GET)
  @ResponseBody
  public List<AdCountry> getCountryList() {

    List<AdCountry> country = addressService.getCountryList();
    return country;
  }

  /**
   * Function getProvinceList : lấy tất cả Province của Country
   * 
   * @param countryId
   * @return Set<AdProvince> chứa tất cả Province của Country
   */
  @RequestMapping(value = "/" + ConstantParameter.ServiceAddress._ADDRESS_GET_PROVINCE,
      method = RequestMethod.GET)
  @ResponseBody
  public Set<AdProvince> getProvinceList(@RequestParam("countryid") int countryId) {
    return addressService.getProvinceList(countryId);
  }

  /**
   * Function getDistrictList : lấy tất cả District của Province
   * 
   * @param provinceId
   * @return Set<AdDistrict> : chứa tất cả district của Province
   */
  @RequestMapping(value = "/" + ConstantParameter.ServiceAddress._ADDRESS_GET_DISTRICT,
      method = RequestMethod.GET)
  @ResponseBody
  public Set<AdDistrict> getDistrictList(@RequestParam("provinceid") int provinceId) {
    return addressService.getDistrictList(provinceId);
  }

  /**
   * Function getWardList : lấy tất cả Ward của District
   * 
   * @param districtId
   * @return Set<AdWard> : chứa tất cả Ward của District
   */
  @RequestMapping(value = "/" + ConstantParameter.ServiceAddress._ADDRESS_GET_WARD,
      method = RequestMethod.GET)
  @ResponseBody
  public Set<AdWard> getWardList(@RequestParam("districtid") int districtId) {
    return addressService.getWardList(districtId);
  }

  /**
   * Function getVillage : lấy tất cả các làng nghề của Ward
   * 
   * @param wardId
   * @return Set<Village>: chứa tất cả làng nghề của Ward
   */
  @RequestMapping(value = "/" + ConstantParameter.ServiceAddress._ADDRESS_GET_VILLAGE,
      method = RequestMethod.GET)
  @ResponseBody
  public Set<Village> getVillages(@RequestParam("wardid") int wardId) {
    return addressService.getVillages(wardId);
  }

  /**
   * Funciton getAddress : từ làng nghề lấy thông tin của district , province , ward và mô tả làng
   * nghề
   * 
   * @param villageId
   * @return Map<String , String> : bao gồm id của disctrict , id của province , id của ward và mô
   *         tả của làng nghề
   */
  @RequestMapping(value = "/" + ConstantParameter.ServiceAddress._ADDRESS_GET_ADDRESS,
      method = RequestMethod.GET, produces = "application/json")
  public Map<String, String> getAddress(@RequestParam("villageid") int villageId) {
    Village village = addressService.getVillageInfo(villageId);
    String wardId = String.valueOf(village.getAdWard().getWardId());
    String districtId = String.valueOf(village.getAdWard().getAdDistrict().getDistrictId());
    String provinceId =
        String.valueOf(village.getAdWard().getAdDistrict().getAdProvince().getProvinceId());
    Map<String, String> addressInfo = new HashMap<>();
    addressInfo.put("wardId", wardId);
    addressInfo.put("districtId", districtId);
    addressInfo.put("provinceId", provinceId);
    addressInfo.put("villageNote", village.getNote());
    return addressInfo;
  }

  public AddressServices getAddressService() {
    return addressService;
  }

  public void setAddressService(AddressServices addressService) {
    this.addressService = addressService;
  }
}
