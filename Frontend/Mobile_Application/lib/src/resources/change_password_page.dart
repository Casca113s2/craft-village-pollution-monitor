import 'package:fl_nynberapp/src/blocs/auth_bloc.dart';
import 'package:fl_nynberapp/src/resources/custom_widget/language_app.dart';
import 'package:fl_nynberapp/src/resources/dialog/loading_dialog.dart';
import 'package:fl_nynberapp/src/resources/dialog/msg_dialog.dart';
import 'package:fl_nynberapp/src/resources/theme/colors/light_colors.dart';
import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
  //final Position position;

  //ChangePassword(this.position);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  AuthBloc auth = new AuthBloc();

  TextEditingController _oldpassController = new TextEditingController();
  TextEditingController _passController = new TextEditingController();
  TextEditingController _repassController = new TextEditingController();

  @override
  void dispose() {
    auth.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          elevation: 0,
        ),
        backgroundColor: LightColors.kLightYellow3,
        body: Container(
            padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
            constraints: BoxConstraints.expand(),
            child: SingleChildScrollView(
              child: Column(children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text(
                    LanguageConfig.getChangePassword(),
                    style: TextStyle(color: Colors.black, fontSize: 28),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: StreamBuilder(
                      stream: auth.oldpassStream,
                      builder: (context, snapshot) => TextField(
                        controller: _oldpassController,
                        style: TextStyle(color: Colors.black, fontSize: 18),
                        obscureText: true,
                        decoration: InputDecoration(
                            errorText:
                                snapshot.hasError ? snapshot.error : null,
                            labelText: LanguageConfig.getOldPassword(),
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
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: StreamBuilder(
                      stream: auth.passStream,
                      builder: (context, snapshot) => TextField(
                        controller: _passController,
                        style: TextStyle(color: Colors.black, fontSize: 18),
                        obscureText: true,
                        decoration: InputDecoration(
                            errorText:
                                snapshot.hasError ? snapshot.error : null,
                            labelText: LanguageConfig.getNewPassword(),
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
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: StreamBuilder(
                      stream: auth.repassStream,
                      builder: (context, snapshot) => TextField(
                        controller: _repassController,
                        style: TextStyle(color: Colors.black, fontSize: 18),
                        obscureText: true,
                        decoration: InputDecoration(
                            errorText:
                                snapshot.hasError ? snapshot.error : null,
                            labelText: LanguageConfig.getRePassword(),
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
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: RaisedButton(
                      color: Colors.blue,
                      onPressed: _onChangePassClicked,
                      child: Text(LanguageConfig.getChangePassword(),
                          style: TextStyle(color: Colors.white, fontSize: 18)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6))),
                    ),
                  ),
                ),
              ]),
            )));
  }

  _onChangePassClicked() {
    var isValid = auth.isValidChangePass(
        _oldpassController.text, _passController.text, _repassController.text);
        
    if (isValid) {
      LoadingDialog.showLoadingDialog(context, LanguageConfig.getProcessing());
      auth.changePass(_oldpassController.text, _passController.text, () {
        LoadingDialog.hideLoadingDialog(context);
        MsgDialog.showMsgDialogAndPushToScreenPage(
            context, LanguageConfig.getNotice(), LanguageConfig.getChangePasswordInfo());
      }, (msg) {
        LoadingDialog.hideLoadingDialog(context);
        MsgDialog.showMsgDialog(context, LanguageConfig.getNotice(), msg);
      });
    }
    
  }
}
