import 'dart:async';
import 'package:fl_nynberapp/src/api/api_auth.dart';
import 'package:fl_nynberapp/src/model/active_model.dart';
import 'package:fl_nynberapp/src/model/address/village_model.dart';
import 'package:fl_nynberapp/src/model/answer_user_model.dart';
import 'package:fl_nynberapp/src/model/answer_user_village_model.dart';
import 'package:fl_nynberapp/src/model/completed_model.dart';
import 'package:fl_nynberapp/src/model/inprogress_model.dart';
import 'package:fl_nynberapp/src/model/survey_answer_user_by_id.dart';
import 'package:fl_nynberapp/src/model/survey_model.dart';
import 'package:fl_nynberapp/src/model/survey_status_model.dart';
import 'package:fl_nynberapp/src/model/user_model.dart';
import 'dart:async';
import 'dart:io';
import 'package:fl_nynberapp/src/model/village_user_model.dart';

class AuthBloc {
  var _apiAuth = ApiAuth();
  StreamController _usernameController = new StreamController();
  StreamController _passController = new StreamController();
  StreamController _repassController = new StreamController();
  StreamController _phoneController = new StreamController();
  StreamController _emailController = new StreamController();
  StreamController _userRoleController = new StreamController();
  StreamController _firstNameController = new StreamController.broadcast();
  StreamController _lastNameController = new StreamController.broadcast();

  //change password
  StreamController _oldpassController = new StreamController();
  Stream get oldpassStream => _oldpassController.stream;

  Stream get usernameStream => _usernameController.stream;
  Stream get passStream => _passController.stream;
  Stream get repassStream => _repassController.stream;
  Stream get firstNameStream => _firstNameController.stream;
  Stream get lastNameStream => _lastNameController.stream;
  Stream get userRoleStream => _userRoleController.stream;
  Stream get phoneStream => _phoneController.stream;
  Stream get emailStream => _emailController.stream;

  void dispose() {
    _usernameController.close();
    _passController.close();
    _repassController.close();
    _firstNameController.close();
    _phoneController.close();
    _emailController.close();
    _userRoleController.close();

    //password
    _oldpassController.close();
  }

  bool isValid(
    String role,
    String username,
    String pass,
    String repass,
    String firstName,
    String lastName,
    String phone,
    String email,
  ) {
    final alphanumeric = RegExp(r'^[a-zA-Z0-9]+$');

    final phonenumeric = RegExp(r'^[0-9]+$');

    final nameRequired = RegExp(r"^[a-z ,.\'-]+$");

    final birthdayRequired = RegExp(
        r"^(?:(?:31(\/|-|\.)(?:0?[13578]|1[02]))\1|(?:(?:29|30)(\/|-|\.)(?:0?[13-9]|1[0-2])\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})$|^(?:29(\/|-|\.)0?2\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))$|^(?:0?[1-9]|1\d|2[0-8])(\/|-|\.)(?:(?:0?[1-9])|(?:1[0-2]))\4(?:(?:1[6-9]|[2-9]\d)?\d{2})$");

    if (username == null ||
        username.length == 0 ||
        alphanumeric.hasMatch(username) == false) {
      _usernameController.sink
          .addError("Không được để trống hoặc có ký tự đặc biệt");
      return false;
    }
    _usernameController.sink.add("");

    if (pass == null || pass.length < 6) {
      _passController.sink.addError("Vui lòng nhập password lớn hơn 6 ký tự");
      return false;
    }
    _passController.sink.add("");

    if (repass == null || repass.length < 6 || pass != repass) {
      _repassController.sink.addError("Vui lòng nhập lại đúng với password");
      return false;
    }
    _repassController.sink.add("");

    print(phonenumeric.hasMatch(phone));
    if (phone == null ||
        phone.length == 0 ||
        phone.length < 10 ||
        !phonenumeric.hasMatch(phone)) {
      _phoneController.sink
          .addError("Vui lòng nhập đúng định dạng số điện thoại");
      return false;
    }
    _phoneController.sink.add("");

    if (email == null ||
        email.length == 0 ||
        !email.contains(".") ||
        !email.contains("@")) {
      _emailController.sink.addError("Vui lòng nhập đúng định dạng email");
      return false;
    }
    _emailController.sink.add("");

    if (role == 'Hộ gia đình') {
      if (lastName == null || lastName.length == 0) {
        _lastNameController.sink.addError("Không để trống");
        return false;
      }
      _lastNameController.sink.add("");

      if (firstName == null || firstName.length == 0) {
        _firstNameController.sink.addError("Không để trống");
        return false;
      }
      _firstNameController.sink.add("");
    }
    _userRoleController.sink.add("");

    return true;
  }

  //Image detection
  imageDetect(String base64Img) {
    Future result = _apiAuth.imageDetect(base64Img);
    if (result != null) return result;
  }

  //Location detection
  getLocation(String latitude, String longitude) {
    Future result = _apiAuth.locationDetect(latitude, longitude);
    if (result != null) return result;
  }

  //Get sign up active code
  getActiveCode(String email, Function onSuccess, Function(String) onError) {
    _apiAuth.getActiveCode(email, onSuccess, onError);
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
      Function(String) onSignupSuccess) {
    //_firAuth.signUp(username, name, pass, phone, onSuccess, onRegisterError);
    _apiAuth.signUp(
      userRole,
      username,
      pass,
      repass,
      firstName,
      lastName,
      phone,
      email,
      activeDate,
      activeCode,
      inputActiveCode,
      onSuccess,
      onSignupSuccess,
    );
  }

  updateUser(
      String username,
      String firstName,
      String lastName,
      String phone,
      String email,
      String type,
      Function onSuccess,
      Function(String) onUpdateUserSuccess) {
    //_firAuth.signUp(username, name, pass, phone, onSuccess, onRegisterError);
    _apiAuth.updateUser(username, firstName, lastName, phone, email, type,
        onSuccess, onUpdateUserSuccess);
  }

  signIn(String username, String pass, Function onSuccess,
      Function(String) onSignInError) {
    //_firAuth.signIn(name, pass, onSuccess, onSignInError);
    _apiAuth.signIn(username, pass, onSuccess, onSignInError);
  }

  signOut(Function onSuccess, Function(String) onSignOutError) {
    _apiAuth.signOut(onSuccess, onSignOutError);
  }

  Future<User> fetchUser(Function onSuccess, Function(String) onError) async {
    return _apiAuth.fetchUser(onSuccess, onError);
  }

  changePass(String oldpass, String pass, Function onSuccess,
      Function(String) onChangePassError) {
    _apiAuth.changePass(oldpass, pass, onSuccess, onChangePassError);
  }

  bool isValidChangePass(String oldpass, String pass, String repass) {
    final alphanumeric = RegExp(r'^[a-zA-Z0-9]+$');

    final phonenumeric = RegExp(r'^[0-9]+$');

    final nameRequired = RegExp(r"^[a-z ,.\'-]+$");

    final birthdayRequired = RegExp(
        r"^(?:(?:31(\/|-|\.)(?:0?[13578]|1[02]))\1|(?:(?:29|30)(\/|-|\.)(?:0?[13-9]|1[0-2])\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})$|^(?:29(\/|-|\.)0?2\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))$|^(?:0?[1-9]|1\d|2[0-8])(\/|-|\.)(?:(?:0?[1-9])|(?:1[0-2]))\4(?:(?:1[6-9]|[2-9]\d)?\d{2})$");

    if (oldpass == null || oldpass.length < 6) {
      _oldpassController.sink
          .addError("Vui lòng nhập passsword lớn hơn 6 kí tự");
      return false;
    }
    _oldpassController.sink.add("");

    if (pass == null || pass.length < 6) {
      _passController.sink.addError("Vui lòng nhập password lớn hơn 6 ký tự");
      return false;
    }
    _passController.sink.add("");

    if (repass == null || repass.length < 6 || pass != repass) {
      _repassController.sink.addError("Vui lòng nhập lại đúng với password");
      return false;
    }

    _repassController.sink.add("");
    if (oldpass == pass) {
      _oldpassController.sink.addError("Không được đổi lại passsword cũ");
      return false;
    }
    _oldpassController.sink.add("");

    return true;
  }

  Future<String> checkUsernameGetEmail(
      String username, Function onSuccess, Function(String) onError) {
    return _apiAuth.checkUsernameGetEmail(username, onSuccess, onError);
  }

  Future<String> isEmailCorrect(String username, String email,
      Function onSuccess, Function(String) onError) async {
    return _apiAuth.isEmailCorrect(username, email, onSuccess, onError);
  }

  Future<bool> activeUser(
      String activeCode,
      String activeDate,
      String activeCodeSubmit,
      Function onSuccess,
      Function(String) onError) async {
    return _apiAuth.activeUser(
        activeCode, activeDate, activeCodeSubmit, onSuccess, onError);
  }
}
