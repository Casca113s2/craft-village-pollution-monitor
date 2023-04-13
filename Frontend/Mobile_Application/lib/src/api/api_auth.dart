import 'dart:convert';
import 'dart:io';
import 'package:fl_nynberapp/src/model/active_model.dart';
import 'package:fl_nynberapp/src/model/address/village_model.dart';
import 'package:fl_nynberapp/src/model/answer_user_model.dart';
import 'package:fl_nynberapp/src/model/answer_user_village_model.dart';
import 'package:fl_nynberapp/src/model/completed_model.dart';
import 'package:fl_nynberapp/src/model/inprogress_model.dart';
import 'package:fl_nynberapp/src/model/survey_answer_user_by_id.dart';
import 'package:fl_nynberapp/src/model/survey_status_model.dart';
import 'package:fl_nynberapp/src/model/user_model.dart';
import 'package:fl_nynberapp/src/model/village_user_model.dart';
import 'package:fl_nynberapp/src/resources/custom_widget/constant_parameter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:flutter/services.dart' show rootBundle;

class ApiAuth {
  String apiUrl = "http://192.168.1.10:5050/craftvillage/api";

  signOut(Function onSuccess, Function(String) onSignOutError) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var jsonResponse;
    //var response = await http.get("http://192.168.3.110:8080/register?name=$email&pass=$pass");
    String token = sharedPreferences.getString("token");
    try {
      var response = await http.get(
          Uri.parse(
              ConstantParameter.getAddressUrl() + ServiceUser.logoutApp()),
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $token"
          }).catchError((err) {
        onSignOutError("Có lỗi trong đường truyền, vui lòng thử lại sau.");
      });
      if (response.statusCode == 200) {
        jsonResponse = response.body;
        if (jsonResponse != null) {
          sharedPreferences.clear();
          onSuccess();
        }
      } else {
        return;
      }
    } catch (e) {
      return;
    }
  }

  //Image Detection
  imageDetect(String base64Img) async {
    var jsonResponse = null;
    var response = await http
        .post(
      // ConstantParameter.getAIAddressUrl(),
      // Uri.parse('http://10.0.2.2:8000/detect'), //Emulator
      Uri.parse('http://150.95.113.16:8000/detect'), //Server
      // headers: <String, String>{
      //   'Content-Type': 'application/x-www-form-urlencoded',
      // },
      body: json.encode({'image': base64Img}),
    )
        .catchError((err) {
      print("Loi: " + err.toString());
      print("Có lỗi trong đường truyền, vui lòng thử lại sau.");
    });

    // var response = await http
    //     .get(
    //   Uri.parse('http://10.0.2.2:8000/detect' + "?image=$base64Img"),
    // )
    //     .catchError((err) {
    //   print("Có lỗi trong đường truyền, vui lòng thử lại sau.");
    // });

    print("TEST HERE: ");
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print("Code image detection: 200! " + response.body);
      // print("Code image detection: 200! " + jsonResponse['air_pollution'].toString());
      return jsonResponse;
    } else {
      print("Xử lý thất bại, vui lòng kiểm tra lại đường truyền");
      return null;
    }
  }

  //Location Detection
  locationDetect(String latitude, String longitude) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var jsonResponse = null;
    String token = sharedPreferences.getString("token");

    // print("LOCATION DETECTION URL: " +
    //     ConstantParameter.getAddressUrl() +
    //       ServiceVillage.detectVillage() +
    //       "?latitude=$latitude" +
    //       "&longitude=$longitude");

    var response = await http.get(
      Uri.parse(ConstantParameter.getAddressUrl() +
          ServiceVillage.detectVillage() +
          "?latitude=$latitude" +
          "&longitude=$longitude"),
      headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
        'Content-Type': 'application/json'
      },
    ).catchError((err) {
      print("Có lỗi trong đường truyền, vui lòng thử lại sau.");
    });

    // print("IM HERE RIGHT NOW!");
    print("LOCATION RESPONE BODY: " + utf8.decode(response.bodyBytes));
    if (response.statusCode == 200) {
      // print("Code: 200!-LOCATION");
      jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      return jsonResponse;
    } else {
      print("Xử lý thất bại, vui lòng kiểm tra lại đường truyền");
      return null;
    }
  }

  //Get sign up active code
  getActiveCode(
      String email, Function onSuccess, Function(String) onError) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var jsonResponse = null;

    var response = await http
        .get(
      Uri.parse(ConstantParameter.getAddressUrl() +
          ServiceUser.sendMail() +
          "?email=$email"),
    )
        .catchError((err) {
      print("Có lỗi trong đường truyền, vui lòng thử lại sau.");
    });

    // print("Response Status Code: " + response.statusCode.toString());
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print(jsonResponse.toString());
      onSuccess(jsonResponse);
    } else {
      onError("Xử lý thất bại, vui lòng kiểm tra lại đường truyền");
    }
  }

  signUp(
      String userRole,
      String username,
      String pass,
      String repass,
      String firstName,
      String lastName,
      String phone,
      String email,
      String activeDate,
      String activeCode,
      String inputActiveCode,
      Function onSuccess,
      Function(String) onSignupError) async {
    var jsonResponse;

    // print(ConstantParameter.getAddressUrl() + ServiceUser.register());

    var response = await http
        .post(
      Uri.parse(ConstantParameter.getAddressUrl() + ServiceUser.register()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'role': userRole,
        'username': username,
        'password': pass,
        'firstname': firstName,
        'lastname': lastName,
        'email': email,
        'phone': phone,
        'activeDate': activeDate,
        'activeCode': activeCode,
        'activeCodeSubmit': inputActiveCode
      }),
    )
        .catchError((err) {
      onSignupError("Có lỗi trong đường truyền, vui lòng thử lại sau.");
    });

    // print("Active Date: "+activeDate);
    print("Response Sign Up Status Code: " + response.statusCode.toString());
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      String key = jsonResponse['key'];
      if (key == "11") {
        onSuccess("Đăng kí thành công!");
      } else if (key == "12") {
        onSignupError("Người dùng đã tồn tại!");
      } else if (key == "13") {
        onSignupError("Email đã đã được sử dụng!");
      } else if (key == "14") {
        onSignupError("Số điện thoại đã được sử dụng!");
      } else if (key == "0") {
        onSignupError("Sai mã xác nhận!");
      } else if (key == "2") {
        onSignupError("Mã xác nhận hết hạn!");
      } else {
        onSignupError("Đăng ký thất bại");
      }
    } else {
      onSignupError("Đăng ký thất bại");
    }
  }

//ĐĂNG NHẬP
  signIn(String username, String pass, Function onSuccess,
      Function(String) onSignInError) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var jsonResponse = null;

    print("LOGIN URL: " +
        ConstantParameter.getAddressUrl() +
        ServiceUser.loginApp());

    var response = await http
        .post(
      Uri.parse(ConstantParameter.getAddressUrl() + ServiceUser.loginApp()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'name': username, 'password': pass}),
    )
        .catchError((err) {
      onSignInError("Có lỗi trong đường truyền, vui lòng thử lại sau.");
    });

    print("ME HERE!!!" + response.body);
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print(response.body);
      if (jsonResponse != null) {
        if (jsonResponse['token'] != null) {
          sharedPreferences.setString("token", jsonResponse['token']);
          sharedPreferences.setString("us", username);
          sharedPreferences.setString("pw", pass);
          print(jsonResponse['token']);
          onSuccess();
        } else {
          if (jsonResponse['error'] == "ERROR_LOGIN_DOUBLE") {
            onSignInError('Tài khoản này đã đăng nhập nơi khác');
          } else {
            onSignInError('Không tồn tại tài khoản hoặc nhập sai mật khẩu');
          }
        }
      }
    } else {
      onSignInError("Đăng nhập thất bại, vui lòng kiểm tra lại đường truyền");
    }
  }

//ĐỔI MẬT KHẨU
  changePass(String oldpass, String pass, Function onSuccess,
      Function(String) onChangePassError) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString("token");
    var jsonResponse = null;
    var response = await http
        .post(
      Uri.parse(ConstantParameter.getAddressUrl() + ServiceUser.changePass()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token"
      },
      body: jsonEncode(<String, String>{'oldPass': oldpass, 'newPass': pass}),
    )
        .catchError((err) {
      onChangePassError("Có lỗi trong đường truyền, vui lòng thử lại sau.");
    });

    print("Change pass respone: " + response.statusCode.toString());
    if (response.statusCode == 200) {
      // jsonResponse = json.decode(response.body);

      //jsonResponse = response.body;
      jsonResponse = response.body;
      //   print(jsonResponse);
      if (jsonResponse == "true") {
        onSuccess();
      } else {
        onChangePassError("Mật khẩu không đúng, xin vui lòng nhập lại");
      }
    } else {
      onChangePassError("Mật khẩu không đúng, xin vui lòng nhập lại");
    }
  }

//QUÊN MẬT KHẨU
  Future<String> checkUsernameGetEmail(
      String username, Function onSuccess, Function(String) onError) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var jsonResponse = null;
    var response = await http
        .post(
      Uri.parse(ConstantParameter.getAddressUrl() + ServiceUser.forgetPass()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
      }),
    )
        .catchError((err) {
      onError("Có lỗi trong đường truyền, vui lòng thử lại sau.");
    });
    print("checkUsernameGetEmail status: " + response.statusCode.toString());
    if (response.statusCode == 200) {
      jsonResponse = response.body;
      print("jsonResponse:" + jsonResponse.toString());
      if (jsonResponse != null && jsonResponse != "") {
        // onSuccess();
        String email = jsonResponse;
        return email;
      } else {
        return null;
      }
    } else {
      onError("Xử lý thất bại, vui lòng kiểm tra lại đường truyền");
    }
    return " ";
  }

  void changeForgetPass(String username, String email, Function onSuccess,
      Function(String) onError) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var jsonResponse = null;
    var response = await http
        .post(
      Uri.parse(ConstantParameter.getAddressUrl() + ServiceUser.forgetPass()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'username': username, 'email': email}),
    )
        .catchError((err) {
      onError("Có lỗi trong đường truyền, vui lòng thử lại sau.");
    });

    print("Status: " + response.statusCode.toString());
    if (response.statusCode == 200) {
      jsonResponse = response.body;
      print("jsonResponse:" + jsonResponse.toString());

      if (jsonResponse == 'false') {
        onError("Xử lý thất bại, vui lòng kiểm tra lại email");
      } else {
        onSuccess();
      }
    } else {
      onError("Xử lý thất bại, vui lòng kiểm tra lại tên đăng nhập");
    }
  }

//lấy lại mật khẩu
  Future<String> isEmailCorrect(String username, String email,
      Function onSuccess, Function(String) onError) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString("token");
    var jsonResponse = null;
    var response = await http
        .post(
      Uri.parse(ConstantParameter.getAddressUrl() + ServiceUser.getPass()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{'email': email, 'username': username}),
    )
        .catchError((err) {
      onError("Có lỗi trong đường truyền, vui lòng thử lại sau.");
    });
    // onSuccess();
    print("isEmailCorrect status: " + response.statusCode.toString());
    if (response.statusCode == 200) {
      jsonResponse = response.body;
      String isEmailCrt = jsonResponse;
      return isEmailCrt;
    } else {
      onError("Xử lý thất bại, vui lòng kiểm tra lại đường truyền");
    }
    return "zz";
  }

  Future<bool> activeUser(
      String activeCode,
      String activeDate,
      String activeCodeSubmit,
      Function onSuccess,
      Function(String) onError) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString("token");
    var jsonResponse = null;
    var response = await http
        .post(
      Uri.parse(ConstantParameter.getAddressUrl() + ServiceUser.activeUser()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token"
      },
      body: jsonEncode(<String, String>{
        'activeCode': activeCode,
        'activeDate': activeDate,
        'activeCodeSubmit': activeCodeSubmit
      }),
    )
        .catchError((err) {
      onError("Có lỗi trong đường truyền, vui lòng thử lại sau.");
    });
    print("activeUser status: " + response.statusCode.toString());
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse != null) {
        if (jsonResponse['status'] == "true" && jsonResponse['err'] == null) {
          return true;
        } else {
          return false;
        }
      }
    }
    return false;
  }

  // Future<ActiveUser> getActiveCode(
  //     Function onSuccess, Function(String) onError) async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   //goi o day
  //   String token = sharedPreferences.getString("token");
  //   print("token fetch userrr: " + token);

  //   final response = await http.get(
  //       ConstantParameter.getAddressUrl() + ServiceUser.sendMail(),
  //       headers: {
  //         HttpHeaders.authorizationHeader: "Bearer $token",
  //         HttpHeaders.contentTypeHeader: "application/json"
  //       }).catchError((err) {
  //     onError("Có lỗi trong đường truyền, vui lòng thử lại sau.");
  //   });
  //   var jsonResponse = null;
  //   print(response.statusCode);
  //   if (response.statusCode == 200) {
  //     print("200 fetch user");
  //     ActiveUser ativeUser;
  //     jsonResponse = json.decode(response.body);
  //     ativeUser =
  //         ActiveUser.fromJson(json.decode(utf8.decode(response.bodyBytes)));
  //     return ativeUser;
  //   } else {
  //     // If the server did not return a 200 OK response, then throw an exception.
  //     throw Exception('Failed to load post getActiveCode');
  //   }
  // }

//GET DỮ LIỆU USER
  Future<User> fetchUser(Function onSuccess, Function(String) onError) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    //goi o day
    String token = sharedPreferences.getString("token");
    print("token fetch userrr: " + token);

    try {
      final response = await http.get(
          Uri.parse(ConstantParameter.getAddressUrl() + ServiceUser.data()),
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $token",
            HttpHeaders.contentTypeHeader: "application/json"
          }).catchError((err) {
        onError("Có lỗi trong đường truyền, vui lòng thử lại sau.");
      });
      var jsonResponse = null;

      if (response.statusCode == 200) {
        User us;
        print("TEST NOW 1: " + response.body);
        jsonResponse = json.decode(response.body);
        us = User.fromJson(json.decode(utf8.decode(response.bodyBytes)));
        sharedPreferences.setString(
            "fullname", us.lastname + " " + us.firstname);
        sharedPreferences.setString("email", us.email);
        print("TEST NOW 2: " +
            " " +
            json.decode(response.body)['lastname'] +
            json.decode(response.body)['firstname']);
        return us;
      } else {
        sharedPreferences.setString("fullname", "Van Cong Le Ca");
        sharedPreferences.setString("email", "cascabusiness@gmail.com");
        return null;
      }
    } catch (e) {
      print("vào ddeye rồi ");
      return null;
    }
  }

/* 
    
    Liên quan đến address 

*/

/* 
    
    kết thúc address 

*/
  updateUser(
      String username,
      String firstName,
      String lastName,
      String phone,
      String email,
      String type,
      Function onSuccess,
      Function(String) onUpdateUserError) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    //goi o day
    String token = sharedPreferences.getString("token");
    var jsonResponse = null;
    var response = await http
        .post(
      Uri.parse(ConstantParameter.getAddressUrl() + ServiceUser.updateUser()),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token",
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'firstname': firstName,
        'lastname': lastName,
        'phone': phone,
        'email': email,
        'sex': '1',
        'type': type
      }),
    )
        .catchError((err) {
      onUpdateUserError("Có lỗi trong đường truyền, vui lòng thử lại sau.");
    });

    print(response.statusCode);
    if (response.statusCode == 200) {
      jsonResponse = response.body;
      print(jsonResponse);
      if (jsonResponse == "true") {
        onSuccess();
      } else {
        onUpdateUserError("Update thất bại, xin thử lại sau");
      }
    } else {
      onUpdateUserError("Update thất bại, xin thử lại sau");
    }
  }

  submitAnswerUser(List<AnswerUser> lsAnswerUser, int activeID,
      Function onSuccess, Function(String) onError, String typeSubmit) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    //goi o day
    String token = sharedPreferences.getString("token");
    var jsonResponse = null;

    List lsAnswerUserJson = List();
    String answerContent = "";
    lsAnswerUser.forEach((answerUswer) {
      answerContent = "";

      for (int i = 0; i < answerUswer.answerContent.length; i++) {
        if (i != answerUswer.answerContent.length - 1) {
          answerContent += answerUswer.answerContent[i].toString() + "_";
        } else
          answerContent += answerUswer.answerContent[i].toString();
      }
      lsAnswerUserJson.add({
        "questionID": answerUswer.questionID,
        "answerContent": answerContent,
        "activeId": activeID,
        // "userSurveyID": answerUswer.userSurveyID,
        "otherContent": answerUswer.answerOtherContent,
      });
    });
    var response = await http.post(
        typeSubmit == "completed"
            ? Uri.parse(ConstantParameter.getAddressUrl() +
                ServiceAnswer.answerCompleted())
            : Uri.parse(ConstantParameter.getAddressUrl() +
                ServiceAnswer.answerInprogress()),
        body: json.encode(lsAnswerUserJson),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
          'Content-Type': 'application/json'
        }).catchError((err) {
      onError("Có lỗi trong đường truyền, vui lòng thử lại sau.");
    });

    if (response.statusCode == 200) {
      jsonResponse = response.body;
      if (jsonResponse == "true") {
        onSuccess();
      } else {
        onError("Submit thất bại, xin thử lại sau");
      }
    } else {
      onError("Submit thất bại, xin thử lại sau");
    }
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
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   //goi o day
  //   String token = sharedPreferences.getString("token");
  //   var jsonResponse = null;
  //   var response = await http.post(
  //       Uri.parse(
  //           ConstantParameter.getAddressUrl() + ServiceVillage.submitVillage()),
  //       body: json.encode(<String, String>{
  //         'villageName': vil.villageName,
  //         'coordinate': vil.coordinate,
  //         'villageId': vil.villageId.toString(),
  //         'activeId': activeId,
  //         'totalQuestion': totalQuestion,
  //         'totalAnswer': totalAnswer,
  //         'totalImage': totalImage,
  //         'hasAdded': hasAdded,
  //         'note': vil.note,
  //         'adWardId': adWardId
  //       }),
  //       headers: {
  //         HttpHeaders.authorizationHeader: "Bearer $token",
  //         'Content-Type': 'application/json; charset=UTF-8'
  //       }).catchError((err) {
  //     onError("Có lỗi trong đường truyền, vui lòng thử lại sau.");
  //   });

  //   if (response.statusCode == 200) {
  //     jsonResponse = response.body;
  //     if (jsonResponse == "true") {
  //       onSuccess();
  //     } else {
  //       onError("Submit thất bại, xin thử lại sau");
  //     }
  //   } else {
  //     onError("Submit thất bại, xin thử lại sau");
  //   }
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
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    //goi o day
    print("SUBMIT HERE: " + villageId);
    String token = sharedPreferences.getString("token");
    var jsonResponse = null;

    print("Note: " + note);
    var response = await http.post(
        Uri.parse(
            ConstantParameter.getAddressUrl() + ServiceVillage.submitVillage()),
        body: json.encode(<String, String>{
          'villageId': villageId,
          'longitude': longitude,
          'latitude': latitude,
          'image': image,
          'result': result,
          'note': note,
        }),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
          'Content-Type': 'application/json; charset=UTF-8'
        }).catchError((err) {
      onError("Có lỗi trong đường truyền, vui lòng thử lại sau.");
    });

    if (response.statusCode == 200) {
      jsonResponse = response.body;
      if (jsonResponse == "true") {
        print("HERE MAN: " + response.body);
        onSuccess("Submit thành công!");
      } else {
        onError("Submit thất bại, xin thử lại sau");
      }
    } else {
      onError("Submit thất bại, xin thử lại sau");
    }
  }

  Future<int> createNewVillage(String adWardId, Village village) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString("token");

    String lat = village.coordinate.split(',')[1];
    String long = village.coordinate.split(',')[0];

    print("adWardId: " + adWardId);
    var jsonResponse = null;
    var response = await http.post(
        Uri.parse(ConstantParameter.getAddressUrl() +
            ServiceVillage.createNewVillage()),
        body: json.encode(<String, String>{
          'wardId': adWardId,
          'villageName': village.villageName,
          'note': village.note,
          'longitude': long,
          'latitude': lat,
          'hasAdded': '0'
        }),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
          'Content-Type': 'application/json; charset=UTF-8'
        }).catchError((err) {
      print("Có lỗi trong đường truyền, vui lòng thử lại sau.");
    });

    print("Create village code: " + response.body.toString());
    if (response.statusCode == 200) {
      // jsonResponse = json.decode(response.body);
      // print("Code: 200! " + json.decode(response.body));
      return int.parse(response.body);
    } else {
      print("Tạo làng nghề thất bại, xin thử lại sau");
      return null;
    }
  }

  //hiener thi ra cau hoi dang trong thoi gian active
  Future<SurveyStatus> fetchSurvey(
      Function onSuccess, Function(String) onError) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    //goi o day
    String token = sharedPreferences.getString("token");
    var jsonResponse = null;

    var response = await http.get(
        Uri.parse(ConstantParameter.getAddressUrl() +
            ServiceSurvey.getSurveyByStatus() +
            "?status=Active"),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
          'Content-Type': 'application/json'
        }).catchError((err) {
      onError("Có lỗi trong đường truyền, vui lòng thử lại sau.");
    });

    print("Code (Questions): " + response.statusCode.toString());
    if (response.statusCode == 200) {
      SurveyStatus surveyStatus = new SurveyStatus();
      List<SurveyStatus> lsSurveyStatus = [];
      Iterable list = json.decode(utf8.decode(response.bodyBytes));

      print("Decode here:\n");
      print(json.decode(utf8.decode(response.bodyBytes)).toString());

      int len = list.length;
      if (len != 0) {
        lsSurveyStatus =
            list.map((model) => SurveyStatus.fromJson(model)).toList();
        print("a");
        surveyStatus = lsSurveyStatus[0];
      } else {
        print("b");
      }
      return surveyStatus;
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<bool> checkSurveyInProgress(
      Function onSuccess, Function(String) onError) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    //goi o day
    String token = sharedPreferences.getString("token");
    var jsonResponse = null;

    var response = await http.get(
        Uri.parse(ConstantParameter.getAddressUrl() +
            ServiceSurvey.getSurveyByStatus() +
            "?status=InProgress"),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
          'Content-Type': 'application/json'
        }).catchError((err) {
      onError("Có lỗi trong đường truyền, vui lòng thử lại sau.");
    });

    if (response.statusCode == 200) {
      SurveyStatus surveyStatus = new SurveyStatus();
      List<SurveyStatus> lsSurveyStatus = [];
      Iterable list = json.decode(utf8.decode(response.bodyBytes));

      int len = list.length;
      if (len != 0) {
        return true;
      } else {
        return false;
      }
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<bool> resetUserSurvey(
      Function onSuccess, Function(String) onError) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    //goi o day
    String token = sharedPreferences.getString("token");
    var jsonResponse = null;

    var response = await http.get(
        Uri.parse(ConstantParameter.getAddressUrl() +
            ServiceAnswer.resetUserSurvey()),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
          'Content-Type': 'application/json'
        }).catchError((err) {
      onError("Có lỗi trong đường truyền, vui lòng thử lại sau.");
    });

    print("status fetch survey : " + response.statusCode.toString());
    if (response.statusCode == 200) {
      print("OK 200 survey");
      if (response.body.toString() == "true") {
        return true;
      } else {
        return false;
      }
    } else {
      throw Exception('Failed to load post');
    }
  }

  //lay du lieu truyen vao surveys completed
  // Future<List<SurveysCompletedModel>> fetchSurveysCompleted(
  //     String token, Function onSuccess, Function(String) onError) async {
  //   // final response = await http.get(
  //   //     Uri.parse(ConstantParameter.getAddressUrl() +
  //   //         ServiceSurvey.getActiveInfor() +
  //   //         "?status=Completed"),
  //   //     headers: {
  //   //       HttpHeaders.authorizationHeader: "Bearer $token",
  //   //       'Content-Type': 'application/json'
  //   //     }).catchError((err) {
  //   //   onError("Có lỗi trong đường truyền, vui lòng thử lại sau.");
  //   // });
  //   // print("fetch sv completed: " + response.statusCode.toString());
  //   // if (response.statusCode == 200) {
  //   //   List<SurveysCompletedModel> lsSurveyCompleted;
  //   //   Iterable list = json.decode(utf8.decode(response.bodyBytes));
  //   //   lsSurveyCompleted =
  //   //       list.map((model) => SurveysCompletedModel.fromJson(model)).toList();
  //   //   return lsSurveyCompleted;
  //   // } else {
  //   //   throw Exception('Failed to load post');
  //   // }
  //   print("URL SURVEY: " +
  //       ConstantParameter.getAddressUrl() +
  //       ServiceSurvey.getAllSurvey());
  //   final response = await http.get(
  //       Uri.parse(
  //           ConstantParameter.getAddressUrl() + ServiceSurvey.getAllSurvey()),
  //       headers: {
  //         HttpHeaders.authorizationHeader: "Bearer $token",
  //         'Content-Type': 'application/json'
  //       }).catchError((err) {
  //     onError("Có lỗi trong đường truyền, vui lòng thử lại sau.");
  //   });

  //   print("Fetch survey completed: " + utf8.decode(response.bodyBytes));

  //   if (response.statusCode == 200) {
  //     List<SurveysCompletedModel> lsSurveyCompleted;
  //     Iterable list = json.decode(utf8.decode(response.bodyBytes));
  //     lsSurveyCompleted =
  //         list.map((model) => SurveysCompletedModel.fromJson(model)).toList();
  //     return lsSurveyCompleted;
  //   } else {
  //     throw Exception('Failed to load post');
  //   }
  // }

  fetchSurveysCompleted(
      String token, Function onSuccess, Function(String) onError) async {
    print("URL SURVEY: " +
        ConstantParameter.getAddressUrl() +
        ServiceSurvey.getAllSurvey());

    final response = await http.get(
        Uri.parse(
            ConstantParameter.getAddressUrl() + ServiceSurvey.getAllSurvey()),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
          'Content-Type': 'application/json'
        }).catchError((err) {
      onError("Có lỗi trong đường truyền, vui lòng thử lại sau.");
    });

    print("Fetch survey in progress: " + response.statusCode.toString());
    print(json.decode(utf8.decode(response.bodyBytes).toString()));
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      // print("Here: " + jsonResponse['completeSurvey'].toString());
      return jsonResponse['completedSurvey'];
    } else {
      throw Exception('Failed to load post');
    }
  }

  fetchSurveysInProgress(
      String token, Function onSuccess, Function(String) onError) async {
    print("URL SURVEY: " +
        ConstantParameter.getAddressUrl() +
        ServiceSurvey.getAllSurvey());

    final response = await http.get(
        Uri.parse(
            ConstantParameter.getAddressUrl() + ServiceSurvey.getAllSurvey()),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
          'Content-Type': 'application/json'
        }).catchError((err) {
      onError("Có lỗi trong đường truyền, vui lòng thử lại sau.");
    });

    print("Fetch survey in progress: " + response.statusCode.toString());
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      // print("Here: " + jsonResponse['inprogressSurvey'].toString());
      return jsonResponse['inprogressSurvey'];
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<SurveyAnswerUserByID> fetchSurveyAnswerUserByID(int id,
      int usersurveyid, Function onSuccess, Function(String) onError) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    print("id : $id  và usersurveyid $usersurveyid");
    //goi o day
    String token = sharedPreferences.getString("token");
    final response = await http.get(
        Uri.parse(ConstantParameter.getAddressUrl() +
            ServiceAnswer.getAnswer() +
            "?activeid=$id&usersurveyid=$usersurveyid"),
        // "$apiUrl/getanswer?activeid=$id&usersurveyid=$usersurveyid",
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
          'Content-Type': 'application/json'
        }).catchError((err) {
      onError("Có lỗi trong đường truyền, vui lòng thử lại sau.");
    });
    if (response.statusCode == 200) {
      SurveyAnswerUserByID surveyAnswerUserByID;
      surveyAnswerUserByID = SurveyAnswerUserByID.fromJson(
          json.decode(utf8.decode(response.bodyBytes)));
      return surveyAnswerUserByID;
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<SurveyAnswerUserByID> fetchSurveyAnswerByImage(
      int id, Function onSuccess, Function(String) onError) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    //goi o day
    String token = sharedPreferences.getString("token");
    final response = await http.get(
        Uri.parse(ConstantParameter.getAddressUrl() +
            ServiceVillage.getVillageSurvey() +
            "?id=$id")
        // "$apiUrl/getvillagesurvey?id=$id"
        ,
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
          'Content-Type': 'application/json'
        }).catchError((err) {
      onError("Có lỗi trong đường truyền, vui lòng thử lại sau.");
    });
    if (response.statusCode == 200) {
      SurveyAnswerUserByID surveyAnswerUserByID;
      surveyAnswerUserByID = SurveyAnswerUserByID.fromJson(
          json.decode(utf8.decode(response.bodyBytes)));
      return surveyAnswerUserByID;
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<VillageUser> fetchVillageUserByID(
      int id, Function onSuccess, Function(String) onError) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    //goi o day
    String token = sharedPreferences.getString("token");
    final response = await http.get(
        Uri.parse(ConstantParameter.getAddressUrl() +
            ServiceVillage.getVillageInfo() +
            "?id=$id")
        //"$apiUrl/getvillageinfo?id=$id"
        ,
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
          'Content-Type': 'application/json'
        }).catchError((err) {
      onError("Có lỗi trong đường truyền, vui lòng thử lại sau.");
    });
    if (response.statusCode == 200) {
      VillageUser villageUserByID;
      villageUserByID =
          VillageUser.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      return villageUserByID;
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<VillageUser> fetchVillageUserByWardId(
      int id, Function onSuccess, Function(String) onError) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    //goi o day
    String token = sharedPreferences.getString("token");
    final response = await http.get(
        Uri.parse(ConstantParameter.getAddressUrl() +
            ServiceAddress.getAddress() +
            "?villageid=$id")
        // "$apiUrl/getaddress?villageid=$id"
        ,
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
          'Content-Type': 'application/json'
        }).catchError((err) {
      onError("Có lỗi trong đường truyền, vui lòng thử lại sau.");
    });

    if (response.statusCode == 200) {
      VillageUser villageUserByID;
      villageUserByID =
          VillageUser.fromJson(json.decode(utf8.decode(response.bodyBytes)));
      return villageUserByID;
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<bool> upLoadFileImage(
      File imageFile1, Function onSuccess, Function(String) onError) async {
    print('1 upload file image');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    //goi o day
    String token = sharedPreferences.getString("token");
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer " + token
    };
    var stream1 =
        new http.ByteStream(DelegatingStream.typed(imageFile1.openRead()));
    var length1 = await imageFile1.length();
    var uri = Uri.parse(
        ConstantParameter.getAddressUrl() + ServiceAnswer.uploadFile());

    var request = new http.MultipartRequest("POST", uri);
    var multipartFileSign1 = new http.MultipartFile('file', stream1, length1,
        filename: basename(imageFile1.path));
    print("length $length1");
    request.files.add(multipartFileSign1);
    request.headers.addAll(headers);
    var response = await request.send().catchError((err) {
      onError("Có lỗi trong đường truyền, vui lòng thử lại sau.");
    });

    print(response.statusCode);
    if (response.statusCode == 200) {
      print('done upload file image');
      final respStr = await response.stream.bytesToString();
      print("respStr $respStr");
      //  response.stream.transform(utf8.decoder).listen((value) {

      // Iterable list = json.decode(utf8.decode(response.bodyBytes));
      // for(var city in responseJson){
      //   City ct = new City(idCity: responseJson[city].code, nameCity: responseJson[city].name);
      //     lsCity.add(ct);
      // }
      /* //Để sau dùng
       Village vil;
      vil = Village.fromJson(json.decode(respStr));
    // */
      // List<Village> lsVillage;
      // Iterable list = json.decode(respStr);
      // // for(var city in responseJson){
      // //   City ct = new City(idCity: responseJson[city].code, nameCity: responseJson[city].name);
      // //     lsCity.add(ct);
      // // }
      // lsVillage = list.map((model) => Village.fromJson(model)).toList();
      return respStr == "true" ? true : false;
      //});
    } else {
      throw Exception('${response.statusCode} Failed to load post image');
    }
  }

  Future<List<String>> getListPicture(List<String> fileName, Function onSuccess,
      Function(String) onError) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    //goi o day
    String token = sharedPreferences.getString("token");
    var jsonResponse = null;

    var response = await http.post(
        Uri.parse(ConstantParameter.getAddressUrl() + ServiceImage.getPicture())
        // "$apiUrl/getpicture"
        ,
        body: json.encode(<String, List<String>>{
          'filename': fileName,
        }),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $token",
          'Content-Type': 'application/json; charset=UTF-8'
        }).catchError((err) {
      onError("Có lỗi trong đường truyền, vui lòng thử lại sau.");
    });
    print("vaof dday");
    print("submit : " + response.statusCode.toString());
    if (response.statusCode == 200) {
      jsonResponse = json.decode(response.body);
      List<String> lsPicture;

      lsPicture = List<String>.from(
          jsonResponse["fileImg"].map((x) => x == null ? null : x));
      return lsPicture;
    } else {
      onError("Submit thất bại, xin thử lại sau");
    }
  }

  Future<int> deletePicture(
      String filename, Function onSuccess, Function(String) onError) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    //goi o day
    String token = sharedPreferences.getString("token");
    var jsonResponse = null;
    var response = await http
        .post(
      Uri.parse(ConstantParameter.getAddressUrl() + ServiceImage.delPicture())
      // '$apiUrl/deletepicture'
      ,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token"
      },
      body: jsonEncode(<String, String>{'filename': filename}),
    )
        .catchError((err) {
      onError("Có lỗi trong đường truyền, vui lòng thử lại sau.");
    });
    if (response.statusCode == 200) {
      jsonResponse = response.body;
      if (jsonResponse == "true") {
        return 1;
      } else {
        return 0;
      }
    } else {
      return null;
    }
  }

  Future<bool> checkExistVillage(
      int villageId, Function onSuccess, Function(String) onError) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    //goi o day
    String token = sharedPreferences.getString("token");
    var jsonResponse = null;
    var response = await http
        .post(
      Uri.parse(
          ConstantParameter.getAddressUrl() + ServiceAddress.checkVillage())
      // '$apiUrl/checkvillage'
      ,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer $token"
      },
      body: jsonEncode(<String, int>{'villageId': villageId}),
    )
        .catchError((err) {
      onError("Có lỗi trong đường truyền, vui lòng thử lại sau.");
    });
    if (response.statusCode == 200) {
      jsonResponse = response.body;

      return jsonResponse == "true" ? true : false;
    } else {
      throw Exception(
          '${response.statusCode} Failed to load post checkExistVillage');
    }
  }

  Future<AnswerUserVillage> uploadImageGetInfoVillageAndAnswer(
      File imageFile1, Function onSuccess, Function(String) onError) async {
    print('1 upload file image');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    //goi o day
    String token = sharedPreferences.getString("token");
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer " + token
    };
    var stream1 =
        new http.ByteStream(DelegatingStream.typed(imageFile1.openRead()));
    var length1 = await imageFile1.length();
    var uri = Uri.parse(
        ConstantParameter.getAddressUrl() + ServiceAnswer.uploadFile());

    var request = new http.MultipartRequest("POST", uri);
    var multipartFileSign1 = new http.MultipartFile('file', stream1, length1,
        filename: basename(imageFile1.path));
    print("length $length1");
    request.files.add(multipartFileSign1);
    request.headers.addAll(headers);

    // var response = await request.send().catchError((err){
    //    onError("Có lỗi trong đường truyền, vui lòng thử lại sau.");
    // });
    var response = await http
        .get(Uri.parse("https://api.jsonbin.io/b/5fb792a704be4f05c927fbdc"));
    print(response.statusCode);
    if (response.statusCode == 200) {
      // print('done upload file image');
      // final respStr = await response.stream.bytesToString();
      // print("respStr $respStr");

      //  response.stream.transform(utf8.decoder).listen((value) {

      // Iterable list = json.decode(utf8.decode(response.bodyBytes));
      // for(var city in responseJson){
      //   City ct = new City(idCity: responseJson[city].code, nameCity: responseJson[city].name);
      //     lsCity.add(ct);
      // }
      /* //Để sau dùng
       Village vil;
      vil = Village.fromJson(json.decode(respStr));
    // */

      //Iterable list = json.decode(respStr);
      // for(var city in responseJson){
      //   City ct = new City(idCity: responseJson[city].code, nameCity: responseJson[city].name);
      //     lsCity.add(ct);
      // }
      print(response.body);
      AnswerUserVillage answerUserVillage = AnswerUserVillage.fromJson(
          json.decode(utf8.decode(response.bodyBytes)));
      return answerUserVillage;
      // return respStr == "true" ? true : false;
      //});
    } else {
      throw Exception('${response.statusCode} Failed to load post image');
    }
  }
}
