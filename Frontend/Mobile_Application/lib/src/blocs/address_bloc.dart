import 'package:fl_nynberapp/src/api/api_address.dart';
import 'package:fl_nynberapp/src/model/address/country_model.dart';
import 'package:fl_nynberapp/src/model/address/district_model.dart';
import 'package:fl_nynberapp/src/model/address/province_model.dart';
import 'package:fl_nynberapp/src/model/address/village_model.dart';
import 'package:fl_nynberapp/src/model/address/ward_model.dart';
import 'package:fl_nynberapp/src/model/village_user_model.dart';

class AddressBloc {
  var _apiAddress = ApiAddress();
  Future<List<Country>> fetchCountry(
      Function onSuccess, Function(String) onError) async {
    return _apiAddress.fetchCountry(onSuccess, onError);
  }
  Future<List<Province>> fetchProvince(int countryId,
      Function onSuccess, Function(String) onError) async {
    return _apiAddress.fetchProvince(countryId, onSuccess, onError);
  }
  Future<List<District>> fetchDistrict(int provinceId,
      Function onSuccess, Function(String) onError) async {
    return _apiAddress.fetchDistrict(provinceId, onSuccess, onError);
  }
  Future<List<Ward>> fetchWard(int districtId,
      Function onSuccess, Function(String) onError) async {
    return _apiAddress.fetchWard(districtId, onSuccess, onError);
  }
   Future<List<Village>> fetchVillage(int wardId,
      Function onSuccess, Function(String) onError) async{
     return _apiAddress.fetchVillage(wardId, onSuccess, onError);
   }
  
}