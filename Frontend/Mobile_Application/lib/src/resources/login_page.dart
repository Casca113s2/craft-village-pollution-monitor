import 'package:fl_nynberapp/src/app.dart';
import 'package:fl_nynberapp/src/resources/craft_page.dart';
import 'package:fl_nynberapp/src/resources/dialog/loading_dialog.dart';
import 'package:fl_nynberapp/src/resources/dialog/msg_dialog.dart';
import 'package:fl_nynberapp/src/resources/forgot_password/user_forgot_pw_page.dart';
import 'package:fl_nynberapp/src/resources/home_page.dart';
import 'package:fl_nynberapp/src/resources/register_page.dart';
import 'package:fl_nynberapp/src/resources/theme/colors/light_colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Map<Permission, PermissionStatus> permissions;
  void initState() {
    super.initState();
    _checkLoginStatus();
    _getPermission();
  }

  void _checkLoginStatus() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString("token");
    if (token != null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => HomePage()),
          (Route<dynamic> route) => false);
    }
  }

  void _getPermission() async {
    permissions = await [
      Permission.location,
      Permission.camera,
      Permission.locationAlways,
    ].request();
  }

  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _passController = new TextEditingController();

  //Build UI for login page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightColors.kLightYellow3,
      body: Container(
        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
        constraints: BoxConstraints.expand(),
        child: SingleChildScrollView(
          //wrap tất cả thằng con thành 1 scroll, tránh thiết bị bị nhỏ
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 110,
              ),
              Image.asset('ic_cv.png'),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                child: Text(
                  "Welcome Back!",
                  style: TextStyle(color: Colors.black, fontSize: 28),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Text(
                  "Mobile App for collecting Craft Village Data",
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 100, 0, 10),
                child: TextField(
                  controller: _usernameController,
                  style: TextStyle(color: Colors.black, fontSize: 18),
                  decoration: InputDecoration(
                      labelText: "Tên đăng nhập",
                      prefixIcon: Container(
                        padding: EdgeInsets.fromLTRB(11, 0, 11, 0),
                        width: 5,
                        child: Image.asset("ic_username.png"),
                      ),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xffCED002), width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(6)))),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                child: TextField(
                  controller: _passController,
                  obscureText: true, // format mật khẩu thành dấu *
                  style: TextStyle(color: Colors.black, fontSize: 18),
                  decoration: InputDecoration(
                      labelText: "Mật khẩu",
                      prefixIcon: Container(
                        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                        width: 5,
                        child: Image.asset("ic_password.png"),
                      ),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xffCED002), width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(6)))),
                ),
              ),
              Container(
                  alignment: AlignmentDirectional.centerEnd,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserForgotPwPage()));
                    },
                    child: Text(
                      "Quên mật khẩu?",
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                  )),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: RaisedButton(
                    color: Colors.blue,
                    onPressed: _onClickLogin,
                    child: Text("Đăng nhập",
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6))),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                child: RichText(
                  text: TextSpan(
                      text: "Chưa có tài khoản? ",
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                      children: <TextSpan>[
                        TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RegisterPage()));
                              },
                            text: "Đăng ký ngay nào!",
                            style: TextStyle(color: Colors.blue, fontSize: 15)),
                      ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Trigger the event when user click login
  _onClickLogin() {
    String username = _usernameController.text;
    String pass = _passController.text;
    var auth = MyApp.of(context).auth;
    LoadingDialog.showLoadingDialog(context, "Đang xử lý...");
    try {
      auth.signIn(username, pass, () {
        //LoadingDialog.hideLoadingDialog(context);
        //  Navigator.of(context)
        //     .push(MaterialPageRoute(builder: (context) => HomePage()));

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => HomePage()),
            (Route<dynamic> route) => false);
      }, (msg) {
        LoadingDialog.hideLoadingDialog(context);
        MsgDialog.showMsgDialog(context, "Đăng nhập", msg);
      });
    } catch (e) {
      print('lỗi rồi'); 
      LoadingDialog.hideLoadingDialog(context);
      MsgDialog.showMsgDialog(context, "Thông báo", "Lỗi máy chủ, vui lòng thử lại sau");
    }
  }
}
