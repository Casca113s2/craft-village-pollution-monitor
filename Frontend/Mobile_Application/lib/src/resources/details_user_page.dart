import 'package:fl_nynberapp/src/app.dart';
import 'package:fl_nynberapp/src/blocs/auth_bloc.dart';
import 'package:fl_nynberapp/src/model/active_model.dart';
import 'package:fl_nynberapp/src/model/types_user_model.dart';
import 'package:fl_nynberapp/src/model/user_model.dart';
import 'package:fl_nynberapp/src/resources/custom_widget/language_app.dart';
import 'package:fl_nynberapp/src/resources/dialog/loading_dialog.dart';
import 'package:fl_nynberapp/src/resources/dialog/msg_dialog.dart';
import 'package:fl_nynberapp/src/resources/theme/colors/light_colors.dart';
import 'package:flutter/material.dart';
import 'package:masked_text/masked_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class DetailsUserPage extends StatefulWidget {
  //final Position position;

  //DetailsUserPage(this.position);

  @override
  _DetailsUserPageState createState() => _DetailsUserPageState();
}

String fullname;
String email;
int time_numer = 60;
List<TypeUserModel> lsTypeUser = [];
TypeUserModel selectedTypeUser = null;
bool enableDropDownList;
double _height;
double _width;
ActiveUser activeUsr;
TypeOfActive isActive;

int _counter = time_numer;
bool checkActiveCorrect = false;

class _DetailsUserPageState extends State<DetailsUserPage> {
  StreamController<int> _events = StreamController<int>();
  Timer _timer;
  int _counter = 0;
  AuthBloc auth = new AuthBloc();
  User user = new User();
  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _passController = new TextEditingController();
  TextEditingController _repassController = new TextEditingController();
  TextEditingController _firstNameController = new TextEditingController();
  TextEditingController _lastNameController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _birthdayController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _userRoleController = new TextEditingController();
  TextEditingController _addressController = new TextEditingController();

  TextEditingController _activeCodeController = new TextEditingController();

  @override
  void dispose() {
    auth.dispose();
    // _events.close();
    super.dispose();
  }

  void initState() {
    super.initState();
    _getInfoUser();
    enableDropDownList = false;
    _events = new StreamController<int>();
    _events.add(60);
    checkActiveCorrect = false;
  }

  _getInfoUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    //goi o day
    String token = sharedPreferences.getString("token");
    lsTypeUser = [];
    lsTypeUser.add(TypeUserModel(
        id: "PrivatePerson", nameType: LanguageConfig.getPrivatePerson()));
    lsTypeUser.add(TypeUserModel(
        id: "HouseHold", nameType: LanguageConfig.getHouseHold()));
    lsTypeUser.add(TypeUserModel(
        id: "LocalAuthority", nameType: LanguageConfig.getLocalAuthority()));
    selectedTypeUser = lsTypeUser[0];
    await auth.fetchUser(() {}, (msg) {
      LoadingDialog.hideLoadingDialog(context);
      MsgDialog.showMsgDialog(context, LanguageConfig.getNotice(), msg);
    }).then((value) {
      setState(() {
        user = value;
        _usernameController.text = user.username;
        _firstNameController.text = user.firstname;
        _lastNameController.text = user.lastname;
        _phoneController.text = user.phone;
        _birthdayController.text = user.birthdate;
        _emailController.text = user.email;
        isActive = user.isActive;
        List<String> temp = user.type.toString().split('.');

        lsTypeUser.forEach((f) {
          if (f.id == temp[1]) {
            selectedTypeUser = f;
          }
        });
      });
    });
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
              child: Column(children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                  child: Text(
                    LanguageConfig.getDetailUser(),
                    style: TextStyle(color: Colors.black, fontSize: 28),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 30, 0, 10),
                    child: StreamBuilder(
                      stream: auth.usernameStream,
                      builder: (context, snapshot) => TextField(
                        enabled: false,
                        controller: _usernameController,
                        style: TextStyle(color: Colors.black, fontSize: 18),
                        decoration: InputDecoration(
                            errorText:
                                snapshot.hasError ? snapshot.error : null,
                            labelText: LanguageConfig.getUsername(),
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
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 5,
                          child: StreamBuilder(
                            stream: auth.lastNameStream,
                            builder: (context, snapshot) => TextField(
                              maxLength: 30,
                              controller: _lastNameController,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                              decoration: InputDecoration(
                                  errorText:
                                      snapshot.hasError ? snapshot.error : null,
                                  labelText: LanguageConfig.getLastname(),
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
                        Expanded(
                          flex: 5,
                          child: StreamBuilder(
                            stream: auth.firstNameStream,
                            builder: (context, snapshot) => TextField(
                              maxLength: 20,
                              controller: _firstNameController,
                              style:
                                  TextStyle(color: Colors.black, fontSize: 18),
                              decoration: InputDecoration(
                                  errorText:
                                      snapshot.hasError ? snapshot.error : null,
                                  labelText: LanguageConfig.getFirstname(),
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
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: StreamBuilder(
                        stream: auth.phoneStream,
                        builder: (context, snapshot) => MaskedTextField(
                              maskedTextFieldController: _phoneController,
                              mask: "xxx.xxx.xxxx",
                              maxLength: 12,
                              keyboardType: TextInputType.number,
                              inputDecoration: new InputDecoration(
                                  errorText:
                                      snapshot.hasError ? snapshot.error : null,
                                  labelText: LanguageConfig.getPhoneNumber(),
                                  labelStyle: TextStyle(
                                      color: Colors.grey[700], fontSize: 18),
                                  prefixIcon: Container(
                                    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                                    width: 5,
                                    child: Image.asset("ic_phone.png"),
                                  ),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xffCED002), width: 1),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(6)))),
                            ))),
                // Padding(
                //     padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                //     child: StreamBuilder(
                //         stream: auth.birthdayStream,
                //         builder: (context, snapshot) => MaskedTextField(
                //               maskedTextFieldController: _birthdayController,
                //               mask: "xx/xx/xxxx",
                //               maxLength: 10,
                //               keyboardType: TextInputType.number,
                //               inputDecoration: new InputDecoration(
                //                   errorText:
                //                       snapshot.hasError ? snapshot.error : null,
                //                   labelText: LanguageConfig.getBirthday(),
                //                   labelStyle: TextStyle(
                //                       color: Colors.grey[700], fontSize: 18),
                //                   prefixIcon: Container(
                //                     padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                //                     width: 5,
                //                     child: Image.asset("ic_birthday.png"),
                //                   ),
                //                   border: OutlineInputBorder(
                //                       borderSide: BorderSide(
                //                           color: Color(0xffCED002), width: 1),
                //                       borderRadius: BorderRadius.all(
                //                           Radius.circular(6)))),
                //             ))),
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                    child: StreamBuilder(
                      stream: null,
                      builder: (context, snapshot) => TextField(
                        enabled: false,
                        controller: _emailController,
                        style: TextStyle(color: Colors.black, fontSize: 18),
                        decoration: InputDecoration(
                            errorText:
                                snapshot.hasError ? snapshot.error : null,
                            labelText: LanguageConfig.getEmail(),
                            prefixIcon: Container(
                              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                              width: 5,
                              child: Image.asset("ic_email.png"),
                            ),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xffCED002), width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6)))),
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(6))),
                      child: IgnorePointer(
                        ignoring: isActive == TypeOfActive.Activated
                            ? false
                            : true, //true là disable dropdown, false là mở
                        child: DropdownButton<TypeUserModel>(
                          underline: SizedBox(),
                          //  hint: Text("  Chọn loại"),
                          isExpanded: true,
                          value: selectedTypeUser,
                          onChanged: (TypeUserModel value) {
                            setState(() {
                              selectedTypeUser = value;
                            });
                          },
                          //   onChanged: null,
                          items: lsTypeUser.map((TypeUserModel type) {
                            return DropdownMenuItem<TypeUserModel>(
                              value: type,
                              child: Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    type.nameType,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      )),
                ),
                isActive == TypeOfActive.Activated
                    ? Padding(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: Text(
                          LanguageConfig.getConfirmedEmail(),
                          style: TextStyle(color: Colors.green),
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: FlatButton(
                          onPressed: () {
                            // showAlertDialogActive(context);
                          },
                          child: Text(
                            LanguageConfig.getUnconfirmedEmail(),
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: RaisedButton(
                      color: Colors.blue,
                      // onPressed: _onUpdateUserClicked,
                      child: Text(LanguageConfig.getUpdate(),
                          style: TextStyle(color: Colors.white, fontSize: 18)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6))),
                    ),
                  ),
                ),
              ]),
            )));
  }

  // _onUpdateUserClicked() async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

  //   var isValid = auth.isValid(
  //     _userRoleController.text,
  //     _usernameController.text,
  //     "123456",
  //     "123456",
  //     _firstNameController.text,
  //     _lastNameController.text,
  //     _phoneController.text,
  //     _birthdayController.text,
  //     _emailController.text,
  //     _addressController.text,
  //   );

  //   if (isValid) {
  //     // create user
  //     // loading dialog
  //     LoadingDialog.showLoadingDialog(context, LanguageConfig.getUpdating());

  //     auth.updateUser(
  //         _usernameController.text,
  //         _firstNameController.text,
  //         _lastNameController.text,
  //         _phoneController.text,
  //         _birthdayController.text,
  //         _emailController.text,
  //         selectedTypeUser.id, () {
  //       LoadingDialog.hideLoadingDialog(context);
  //       fullname = _lastNameController.text + " " + _firstNameController.text;
  //       email = _emailController.text;
  //       setState(() {
  //         sharedPreferences.setString("fullname", fullname);
  //         sharedPreferences.setString("email", email);
  //         sharedPreferences.setString("typeUser", selectedTypeUser.nameType);
  //       });
  //       MsgDialog.showMsgDialogAndPushToScreenPage(context,
  //           LanguageConfig.getNotice(), LanguageConfig.getConfirmedUpdate());
  //     }, (msg) {
  //       //show dialog
  //       LoadingDialog.hideLoadingDialog(context);
  //       MsgDialog.showMsgDialog(context, LanguageConfig.getNotice(), msg);
  //     });
  //   }
  // }

  // showAlertDialogActive(BuildContext context) {
  //   // set up the buttons
  //   Widget cancelButton = FlatButton(
  //     child: Text(LanguageConfig.getCancel()),
  //     onPressed: () {
  //       Navigator.pop(context);
  //       _events = new StreamController<int>();
  //       _events.add(60);
  //     },
  //   );
  //   Widget continueButton = FlatButton(
  //     child: Text(LanguageConfig.getContinue()),
  //     onPressed: () {
  //       _onContinueActiveCodeTime(context);
  //     },
  //   );

  //   // set up the AlertDialog
  //   AlertDialog alert = AlertDialog(
  //     title: Text(LanguageConfig.getInfo()),
  //     content: Container(
  //       child: Row(
  //         children: <Widget>[
  //           Container(
  //             width: _width / 2,
  //             child: Padding(
  //               padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
  //               child: TextField(
  //                 controller: _activeCodeController,
  //                 style: TextStyle(color: Colors.black, fontSize: 18),
  //                 decoration: InputDecoration(
  //                     labelText: LanguageConfig.getActiveCodeNotice(),
  //                     border: OutlineInputBorder(
  //                         borderSide:
  //                             BorderSide(color: Color(0xffCED002), width: 1),
  //                         borderRadius: BorderRadius.all(Radius.circular(6)))),
  //               ),
  //             ),
  //           ),
  //           StreamBuilder<int>(
  //               stream: _events.stream,
  //               builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
  //                 int temp = snapshot.data;
  //                 return SizedBox.fromSize(
  //                     size: Size(56, 56), // button width and height
  //                     child: ClipOval(
  //                         child: Material(
  //                       color: Colors.orange[50], // button color
  //                       child: temp == time_numer || temp == 0
  //                           ? InkWell(
  //                               splashColor: Colors.green, // splash color
  //                               onTap: () {
  //                                 _startTimer();
  //                                 _onActiveCodeTime(context);
  //                               }, // button pressed
  //                               child: Column(
  //                                 mainAxisAlignment: MainAxisAlignment.center,
  //                                 children: <Widget>[
  //                                   Icon(Icons.archive), // icon
  //                                   Text(LanguageConfig.getActive()), // text
  //                                 ],
  //                               ),
  //                             )
  //                           : Column(
  //                               mainAxisAlignment: MainAxisAlignment.center,
  //                               children: <Widget>[
  //                                 // icon
  //                                 Text("$temp"), // text
  //                               ],
  //                             ),
  //                     )));
  //               })
  //         ],
  //       ),
  //     ),
  //     actions: [
  //       cancelButton,
  //       continueButton,
  //     ],
  //   );

  //   // show the dialog
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return alert;
  //     },
  //   );

  //   ;
  // }

  // _onActiveCodeTime(BuildContext context) async {
  //   var auth = MyApp.of(context).auth;
  //   LoadingDialog.showLoadingDialog(context, LanguageConfig.getProcessing());
  //   await auth.getActiveCode(() {}, (msg) {
  //     LoadingDialog.hideLoadingDialog(context);
  //     MsgDialog.showMsgDialog(context, LanguageConfig.getNotice(), msg);
  //   }).then((activeUser) {
  //     activeUsr = activeUser;
  //     LoadingDialog.hideLoadingDialog(context);
  //   });
  // }

  // _onContinueActiveCodeTime(BuildContext context) async {
  //   var auth = MyApp.of(context).auth;
  //   LoadingDialog.showLoadingDialog(context, LanguageConfig.getProcessing());
  //   if (activeUsr != null) {
  //     await auth.activeUser(activeUsr.activeCode, activeUsr.activeDate,
  //         _activeCodeController.text, () {}, (msg) {
  //       LoadingDialog.hideLoadingDialog(context);
  //       MsgDialog.showMsgDialog(context, LanguageConfig.getNotice(), msg);
  //     }).then((value) {
  //       if (value.toString() == "true") {
  //         print("oncontinue active : " + value.toString());
  //         LoadingDialog.hideLoadingDialog(context);
  //         Navigator.pop(context);

  //         setState(() {
  //           isActive = TypeOfActive.Activated;
  //         });
  //       } else {
  //         LoadingDialog.hideLoadingDialog(context);
  //         MsgDialog.showMsgDialog(context, LanguageConfig.getNotice(),
  //             LanguageConfig.getWrongCode());
  //         _events = new StreamController<int>();
  //         _events.add(60);
  //       }
  //     });
  //   }
  // }

  // void _startTimer() {
  //   _counter = 60;
  //   if (_timer != null) {
  //     _timer.cancel();
  //   }
  //   _timer = Timer.periodic(Duration(seconds: 1), (timer) {
  //     //setState(() {
  //     (_counter > 0) ? _counter-- : _timer.cancel();
  //     //});
  //     _events.add(_counter);
  //   });
  // }
}
