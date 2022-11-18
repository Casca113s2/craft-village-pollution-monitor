import 'dart:convert';
import 'dart:io';
import 'package:fl_nynberapp/src/model/address/country_model.dart';
import 'package:fl_nynberapp/src/model/address/district_model.dart';
import 'package:fl_nynberapp/src/model/address/province_model.dart';
import 'package:fl_nynberapp/src/model/address/village_model.dart';
import 'package:fl_nynberapp/src/model/address/ward_model.dart';
import 'package:fl_nynberapp/src/resources/custom_widget/constant_parameter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ApiAddress {
  Future<List<Country>> fetchCountry(
      Function onSuccess, Function(String) onError) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    //goi o day
    String token = sharedPreferences.getString("token");
    var response = await http.get(
        Uri.parse(
            ConstantParameter.getAddressUrl() + ServiceAddress.getCountry()),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
          'Content-Type': 'application/json'
        }).catchError((err) {
      onError("Có lỗi trong đường truyền, vui lòng thử lại sau.");
    });
    if (response.statusCode == 200) {
      print("OK 200");
      List<Country> lsCountry;
      Iterable list = json.decode(utf8.decode(response.bodyBytes));
      lsCountry = list.map((model) => Country.fromJson(model)).toList();
      return lsCountry;
    } else {
      throw Exception('Failed to load post');
    }
  }

  //TỈNH
  Future<List<Province>> fetchProvince(
      int countryId, Function onSuccess, Function(String) onError) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    //goi o day
    // String token = sharedPreferences.getString("token");
    var response = await http
        .get(
      Uri.parse(ConstantParameter.getAddressUrl() +
          ServiceAddress.getProvice() +
          "?countryid=$countryId"),
      // headers: {
      //   HttpHeaders.authorizationHeader: "Bearer $token",
      //   'Content-Type': 'application/json'
      // }
    )
        .catchError((err) {
      onError("Có lỗi trong đường truyền, vui lòng thử lại sau.");
    });

    print("Province status code:" + response.statusCode.toString());
    if (response.statusCode == 200) {
      print("OK 200");
      List<Province> lsProvince;
      Iterable list = json.decode(utf8.decode(response.bodyBytes));
      lsProvince = list.map((model) => Province.fromJson(model)).toList();
      return lsProvince;
    } else {
      throw Exception('Failed to load post');
    }
  }

  //HUYỆN
  Future<List<District>> fetchDistrict(
      int provinceId, Function onSuccess, Function(String) onError) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    //goi o day
    // String token = sharedPreferences.getString("token");
    var response = await http
        .get(
      Uri.parse(ConstantParameter.getAddressUrl() +
          ServiceAddress.getDistrict() +
          "?provinceid=$provinceId"),
      // headers: {
      //   HttpHeaders.authorizationHeader: "Bearer $token",
      //   'Content-Type': 'application/json'
      // }
    )
        .catchError((err) {
      onError("Có lỗi trong đường truyền, vui lòng thử lại sau.");
    });

    if (response.statusCode == 200) {
      print("OK 200");
      List<District> lsDistrict;
      Iterable list = json.decode(utf8.decode(response.bodyBytes));
      lsDistrict = list.map((model) => District.fromJson(model)).toList();
      return lsDistrict;
    } else {
      throw Exception('Failed to load post');
    }
  }

  //XÃ
  Future<List<Ward>> fetchWard(
      int districtId, Function onSuccess, Function(String) onError) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    //goi o day
    // String token = sharedPreferences.getString("token");
    var response = await http
        .get(
      Uri.parse(ConstantParameter.getAddressUrl() +
          ServiceAddress.getWard() +
          "?districtid=$districtId"),
      // headers: {
      //   HttpHeaders.authorizationHeader: "Bearer $token",
      //   'Content-Type': 'application/json'
      // }
    )
        .catchError((err) {
      onError("Có lỗi trong đường truyền, vui lòng thử lại sau.");
    });

    if (response.statusCode == 200) {
      print("OK 200");
      List<Ward> lsWard;
      Iterable list = json.decode(utf8.decode(response.bodyBytes));
      lsWard = list.map((model) => Ward.fromJson(model)).toList();
      return lsWard;
    } else {
      throw Exception('Failed to load post');
    }
  }

  //LÀNG NGHỀ
  Future<List<Village>> fetchVillage(
      int wardId, Function onSuccess, Function(String) onError) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    //goi o day
    // String token = sharedPreferences.getString("token");
    var response = await http
        .get(
      Uri.parse(ConstantParameter.getAddressUrl() +
          ServiceAddress.getVillage() +
          "?wardid=$wardId"),
      // headers: {
      //   HttpHeaders.authorizationHeader: "Bearer $token",
      //   'Content-Type': 'application/json'
      // }
    )
        .catchError((err) {
      onError("Có lỗi trong đường truyền, vui lòng thử lại sau.");
    });
    // print(ConstantParameter.getAddressUrl() +
    //     ServiceAddress.getVillage() +
    //     "?wardid=$wardId");
    print("RESPONE BODY VILLAGE: " + response.statusCode.toString());
    if (response.statusCode == 200) {
      // print("OK 200 fetchVillage");
      List<Village> lsVillage;
      print("RESOPNE BODY VILLAGE: " + response.body);
      Iterable list = json.decode(utf8.decode(response.bodyBytes));
      lsVillage = list.map((model) => Village.fromJson(model)).toList();
      return lsVillage;
    } else {
      throw Exception('Failed to load post');
    }
  }
}
