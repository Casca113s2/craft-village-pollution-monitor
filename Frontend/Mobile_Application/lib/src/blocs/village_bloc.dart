import 'package:fl_nynberapp/src/api/api_auth.dart';
import 'package:fl_nynberapp/src/model/address/village_model.dart';
import 'package:fl_nynberapp/src/model/village_user_model.dart';

class VillageBloc {
  var _apiAuth = ApiAuth();
  Future<bool> checkExistVillage(
      int villageId, Function onSuccess, Function(String) onError) async {
    return _apiAuth.checkExistVillage(villageId, onSuccess, onError);
  }

  Future<VillageUser> fetchVillageUserByWardId(
      int id, Function onSuccess, Function(String) onError) async {
    return _apiAuth.fetchVillageUserByWardId(id, onSuccess, onError);
  }

  Future<VillageUser> fetchVillageUserByID(
      int id, Function onSuccess, Function(String) onError) async {
    return _apiAuth.fetchVillageUserByID(id, onSuccess, onError);
  }

  Future<int> createNewVillage(
    String adWardId, Village village) async{
    return _apiAuth.createNewVillage(adWardId, village);
  }

  // submitVillage(
  //     Village vil,
  //     String activeId,
  //     String totalQuestion,
  //     String totalAnswer,
  //     String totalImage,
  //     String hasAdded,
  //     String adWardId,
  //     Function onSuccess,
  //     Function(String) onError) async {
  //   _apiAuth.submitVillage(vil, activeId, totalQuestion, totalAnswer,
  //       totalImage, hasAdded, adWardId, onSuccess, onError);
  // }

  submitVillage(
      String villageId,
      String longitude,
      String latitude,
      String image,
      String result,
      String note,
      Function onSuccess,
      Function(String) onError) async {
    _apiAuth.submitVillage(villageId, longitude, latitude, image, result, note, onSuccess, onError);
  }
}
