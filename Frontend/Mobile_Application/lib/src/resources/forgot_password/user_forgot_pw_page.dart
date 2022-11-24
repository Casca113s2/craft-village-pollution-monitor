import 'package:fl_nynberapp/src/app.dart';
import 'package:fl_nynberapp/src/resources/dialog/loading_dialog.dart';
import 'package:fl_nynberapp/src/resources/dialog/msg_dialog.dart';
import 'package:fl_nynberapp/src/resources/forgot_password/email_forgot_pw_page.dart';
import 'package:fl_nynberapp/src/resources/login_page.dart';
import 'package:fl_nynberapp/src/resources/register_page.dart';
import 'package:fl_nynberapp/src/resources/theme/colors/light_colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class UserForgotPwPage extends StatefulWidget {
  @override
  _UserForgotPwPageState createState() => _UserForgotPwPageState();
}

double _height;
double _width;

class _UserForgotPwPageState extends State<UserForgotPwPage> {
  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: LightColors.kLightYellow3,
        leading: IconButton(
          icon: Icon(
            Icons.chevron_left,
            size: 40,
          ),
          onPressed: () {
            Navigator.maybePop(context);
          },
          color: Colors.green,
        ),
        //iconTheme: IconThemeData(color: Colors.blue),
        elevation: 0,
      ),
      backgroundColor: LightColors.kLightYellow3,
      body: Container(
        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
        constraints: BoxConstraints.expand(),
        child: SingleChildScrollView(
          //wrap tất cả thằng con thành 1 scroll, tránh thiết bị bị nhỏ
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(0, _height / 4.5, 0, 0),
                child: Text(
                  "Khôi phục mật khẩu",
                  style: TextStyle(color: Colors.black, fontSize: 28),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 30, 0, 10),
                child: TextField(
                  controller: _usernameController,
                  style: TextStyle(color: Colors.black, fontSize: 18),
                  decoration: InputDecoration(
                      labelText: "Nhập tên đăng nhập",
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
                padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: TextField(
                  controller: _emailController,
                  style: TextStyle(color: Colors.black, fontSize: 18),
                  decoration: InputDecoration(
                      labelText: "Nhập lại địa chỉ email",
                      prefixIcon: Container(
                        padding: EdgeInsets.fromLTRB(11, 0, 11, 0),
                        width: 5,
                        child: Image.asset("ic_email.png"),
                      ),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xffCED002), width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(6)))),
                ),
              ),
              Visibility(
                  visible: false,
                  child: Container(
                    width: _width / 1.32,
                    alignment: Alignment.center,
                    child: Text(
                      "Vui lòng điền đúng tên tài khoản",
                      style: TextStyle(color: Colors.red),
                    ),
                  )),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: RaisedButton(
                    color: Colors.blue,
                    onPressed: () {
                      _onChangeForgetPassword();
                    },
                    child: Text("Hoàn thành",
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6))),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              RichText(
                text: TextSpan(
                    text: "Chưa có tài khoản?",
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
              SizedBox(
                height: 20,
              ),
              RichText(
                text: TextSpan(
                    text: "Đã có tài khoản?",
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                    children: <TextSpan>[
                      TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()));
                            },
                          text: "Đăng nhập ngay nào!",
                          style: TextStyle(color: Colors.blue, fontSize: 15)),
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // _onCheckUsername() async {
  //   String name = _usernameController.text;
  //   // print(name);
  //   var auth = MyApp.of(context).auth;
  //   LoadingDialog.showLoadingDialog(context, "Đang xử lý...");
  //   await auth.checkUsernameGetEmail(name, () {
  //     LoadingDialog.hideLoadingDialog(context);
  //     MsgDialog.showMsgDialog(context, "Thông báo", "Thành công");
  //   }, (msg) {
  //     LoadingDialog.hideLoadingDialog(context);
  //     MsgDialog.showMsgDialog(context, "Thông báo", msg);
  //   }).then((email) {
  //     if (email != null && email != "") {
  //       LoadingDialog.hideLoadingDialog(context);
  //       Navigator.of(context).push(MaterialPageRoute(
  //           builder: (context) => EmailForgotPwPage(name, email)));
  //     } else {
  //       LoadingDialog.hideLoadingDialog(context);
  //       MsgDialog.showMsgDialog(
  //           context, "Thông báo", "Không tồn tại tên đăng nhập này");
  //     }
  //   });
  // }

  _onChangeForgetPassword() async {
    String name = _usernameController.text;
    String email = _emailController.text;
    // print(name);
    var auth = MyApp.of(context).auth;
    LoadingDialog.showLoadingDialog(context, "Đang xử lý...");
    await auth.changeForgetPass(name, email, () {
      LoadingDialog.hideLoadingDialog(context);
      MsgDialog.showMsgDialogAndBackToLogin(context, "Thông báo", "Thành công");
    }, (msg) {
      LoadingDialog.hideLoadingDialog(context);
      MsgDialog.showMsgDialog(context, "Thông báo", msg);
    });
  }
}
