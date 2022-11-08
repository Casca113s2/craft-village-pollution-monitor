import 'package:fl_nynberapp/src/blocs/auth_bloc.dart';
import 'package:fl_nynberapp/src/resources/dialog/loading_dialog.dart';
import 'package:fl_nynberapp/src/resources/dialog/msg_dialog.dart';
import 'package:fl_nynberapp/src/resources/home_page.dart';
import 'package:fl_nynberapp/src/resources/login_page.dart';
import 'package:fl_nynberapp/src/resources/theme/colors/light_colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:masked_text/masked_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fl_nynberapp/src/model/address/province_model.dart';
import 'package:fl_nynberapp/src/model/address/district_model.dart';
import 'package:fl_nynberapp/src/model/address/ward_model.dart';
import 'package:fl_nynberapp/src/model/address/village_model.dart';
import 'package:fl_nynberapp/src/blocs/address_bloc.dart';
import 'custom_widget/language_app.dart';

class RegisterPage extends StatefulWidget {
  //final Position position;

  //RegisterPage(this.position);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  AuthBloc auth = new AuthBloc();
  AddressBloc addressBloc = new AddressBloc();

  //Must have value
  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _passController = new TextEditingController();
  TextEditingController _repassController = new TextEditingController();
  TextEditingController _firstNameController = new TextEditingController();
  TextEditingController _lastNameController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  String _userRole = 'USER';

  //Component control values
  double _height;
  double _width;

  @override
  void dispose() {
    auth.dispose();
    super.dispose();
  }

  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  //Check login status
  void _checkLoginStatus() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString("token");
    if (token != null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => HomePage()),
          (Route<dynamic> route) => false);
    }
  }

  //Build UI for the register page
  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: LightColors.kLightYellow3,
        body: Container(
            padding: EdgeInsets.fromLTRB(30, _height / 12, 30, 0),
            constraints: BoxConstraints.expand(),
            child: SingleChildScrollView(
              //wrap tất cả thằng con thành 1 scroll, tránh thiết bị bị nhỏ
              child: Column(children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                  child: Text(
                    "Sign-up",
                    style: TextStyle(color: Colors.black, fontSize: 28),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 30, 0, 10),
                    child: StreamBuilder(
                      stream: auth.usernameStream,
                      builder: (context, snapshot) => TextField(
                        controller: _usernameController,
                        style: TextStyle(color: Colors.black, fontSize: 18),
                        decoration: InputDecoration(
                            errorText:
                                snapshot.hasError ? snapshot.error : null,
                            labelText: "Tên đăng nhập",
                            prefixIcon: Container(
                              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                              width: 5,
                              child: Image.asset("ic_username.png"),
                            ),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xffCED002), width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6)))),
                      ),
                    )),
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                    child: StreamBuilder(
                      stream: auth.passStream,
                      builder: (context, snapshot) => TextField(
                        controller: _passController,
                        style: TextStyle(color: Colors.black, fontSize: 18),
                        obscureText: true,
                        decoration: InputDecoration(
                            errorText:
                                snapshot.hasError ? snapshot.error : null,
                            labelText: "Mật khẩu",
                            prefixIcon: Container(
                              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                              width: 5,
                              child: Image.asset("ic_password.png"),
                            ),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xffCED002), width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6)))),
                      ),
                    )),
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                    child: StreamBuilder(
                      stream: auth.repassStream,
                      builder: (context, snapshot) => TextField(
                        controller: _repassController,
                        style: TextStyle(color: Colors.black, fontSize: 18),
                        obscureText: true,
                        decoration: InputDecoration(
                            errorText:
                                snapshot.hasError ? snapshot.error : null,
                            labelText: "Nhập lại mật khẩu",
                            prefixIcon: Container(
                              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                              width: 5,
                              child: Image.asset("ic_password.png"),
                            ),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xffCED002), width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6)))),
                      ),
                    )),
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 5,
                          child: StreamBuilder(
                            stream: auth.lastNameStream,
                            builder: (context, snapshot) => TextField(
                              controller: _lastNameController,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                              decoration: InputDecoration(
                                  errorText:
                                      snapshot.hasError ? snapshot.error : null,
                                  labelText: "Họ",
                                  prefixIcon: Container(
                                    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                                    width: 5,
                                    child: Image.asset("ic_contact.png"),
                                  ),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xffCED002), width: 1),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(6)))),
                            ),
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(left: 10)),
                        Expanded(
                          flex: 5,
                          child: StreamBuilder(
                            stream: auth.firstNameStream,
                            builder: (context, snapshot) => TextField(
                              controller: _firstNameController,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                              decoration: InputDecoration(
                                  errorText:
                                      snapshot.hasError ? snapshot.error : null,
                                  labelText: "Tên",
                                  prefixIcon: Container(
                                    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                                    width: 5,
                                    child: Image.asset("ic_contact.png"),
                                  ),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xffCED002), width: 1),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(6)))),
                            ),
                          ),
                        )
                      ],
                    )),
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: StreamBuilder(
                      stream: auth.phoneStream,
                      builder: (context, snapshot) => MaskedTextField(
                        maskedTextFieldController: _phoneController,
                        mask: "xxx.xxx.xxxx",
                        maxLength: 12,
                        keyboardType: TextInputType.phone,
                        inputDecoration: new InputDecoration(
                            errorText:
                                snapshot.hasError ? snapshot.error : null,
                            labelText: "Số điện thoại",
                            labelStyle: TextStyle(
                                color: Colors.grey[700], fontSize: 18),
                            prefixIcon: Container(
                              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                              width: 5,
                              child: Image.asset("ic_phone.png"),
                            ),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xffCED002),
                                  width: 1,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6)))),
                      ),
                    )),
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: StreamBuilder(
                      stream: auth.emailStream,
                      builder: (context, snapshot) => TextField(
                        controller: _emailController,
                        style: TextStyle(color: Colors.black, fontSize: 18),
                        decoration: InputDecoration(
                            errorText:
                                snapshot.hasError ? snapshot.error : null,
                            labelText: "Địa chỉ email",
                            prefixIcon: Container(
                              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                              width: 5,
                              child: Image.asset("ic_email.png"),
                            ),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xffCED002),
                                  width: 1,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6)))),
                      ),
                    )),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: RaisedButton(
                      color: Colors.blue,
                      onPressed: _onSignUpClicked,
                      child: Text("Đăng ký",
                          style: TextStyle(color: Colors.white, fontSize: 18)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6))),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                  child: RichText(
                    text: TextSpan(
                        text: "Đã có tài khoản? ",
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
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 15)),
                        ]),
                  ),
                ),
              ]),
            )));
  }

  //Trigger the event when click sign up button
  _onSignUpClicked() {
    //Test code
    // _usernameController.text = 'demo009';
    // _passController.text = 'demo009';
    // _repassController.text = 'demo009';
    // _firstNameController.text = 'Anh';
    // _lastNameController.text = 'Nguyen Van';
    // _phoneController.text = '0352707895';
    // _emailController.text = 'vancongleca1997@gmail.com';
    //

    var isValid = auth.isValid(
      _userRole,
      _usernameController.text,
      _passController.text,
      _repassController.text,
      _firstNameController.text,
      _lastNameController.text,
      _phoneController.text,
      _emailController.text,
    );

    if (isValid) {
      // Create user
      // Loading dialog
      LoadingDialog.showLoadingDialog(context, 'Đang xử lý...');

      auth.getActiveCode(
        _emailController.text,
        (value) {
          LoadingDialog.hideLoadingDialog(context);

          TextEditingController _inputActiveCode = new TextEditingController();

          showDialog<String>(
            context: context,
            builder: (BuildContext activeCodeContext) => new AlertDialog(
              contentPadding: const EdgeInsets.all(16.0),
              content: new Row(
                children: <Widget>[
                  new Expanded(
                    child: new TextField(
                      controller: _inputActiveCode,
                      autofocus: true,
                      decoration: new InputDecoration(
                          labelText: 'Nhập Mã Kích Hoạt',
                          hintText: 'Mã Kích Hoạt'),
                    ),
                  )
                ],
              ),
              actions: <Widget>[
                FlatButton(
                    child: const Text('CANCEL'),
                    onPressed: () {
                      Navigator.pop(activeCodeContext);
                    }),
                FlatButton(
                    child: const Text('SENT'),
                    onPressed: () {
                      Navigator.pop(activeCodeContext);
                      LoadingDialog.showLoadingDialog(context, 'Đang xử lý...');
                      print("Type User Sign Up: " + _userRole.toString());

                      auth.signUp(
                        _userRole,
                        _usernameController.text,
                        _passController.text,
                        _repassController.text,
                        _firstNameController.text,
                        _lastNameController.text,
                        _phoneController.text,
                        _emailController.text,
                        value["activeDate"],
                        value["activeCode"],
                        _inputActiveCode.text,
                        (msg) {
                          //Move back to login page
                          LoadingDialog.hideLoadingDialog(context);
                          MsgDialog.showMsgDialogAndBackToLogin(
                              context, "Đăng kí", msg);
                        },
                        (msg) {
                          //Show error dialog
                          LoadingDialog.hideLoadingDialog(context);
                          MsgDialog.showMsgDialog(context, "Đăng kí", msg);
                        },
                      );
                    })
              ],
            ),
          );
        },
        (msg) {
          //show dialog
          LoadingDialog.hideLoadingDialog(context);
          MsgDialog.showMsgDialog(context, "Nhập mã", msg);
        },
      );
    }
  }
}
