import 'dart:io';

import 'package:fl_nynberapp/src/api/api_auth.dart';

class ImageBloc{
  var _apiAuth = ApiAuth();
  
  Future<int> deletePicture(
      String filename, Function onSuccess, Function(String) onError) async {
    return _apiAuth.deletePicture(filename, onSuccess, onError);
  }
  Future<bool> upLoadFileImage(
      File imageFile1, Function onSuccess, Function(String) onError) async {
    return _apiAuth.upLoadFileImage(imageFile1, onSuccess, onError);
  }
  Future<List<String>> getListPicture(List<String> fileName, Function onSuccess,
      Function(String) onError) async {
    return _apiAuth.getListPicture(fileName, onSuccess, onError);
  }
}