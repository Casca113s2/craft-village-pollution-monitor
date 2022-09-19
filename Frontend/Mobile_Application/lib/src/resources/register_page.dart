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
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  String _userRole = 'Cá nhân';

  //Household value
  TextEditingController _firstNameController = new TextEditingController();
  TextEditingController _lastNameController = new TextEditingController();
  TextEditingController _birthdayController = new TextEditingController();
  TextEditingController _personalController = new TextEditingController();

  //Address
  List<Province> lsProvince;
  Province selectedProvince;

  List<District> lsDistrict;
  District selectedDistrict;

  List<Ward> lsWard;
  Ward selectedWard;

  List<Village> lsVillage;
  Village selectedVillage;
  TextEditingController _infoCraftVillage = new TextEditingController();

  int selectTabVillage = 0;

  TextEditingController _addCraftVillage = new TextEditingController();
  TextEditingController _addInfoCraftVillage = new TextEditingController();

  //Component control values
  double _height;
  double _width;

  @override
  void dispose() {
    auth.dispose();
    super.dispose();
  }

  //Reset field to blank
  void _resetHouseHoldField() {
    _lastNameController.text = '';
    _firstNameController.text = '';
    _birthdayController.text = '';
    _personalController.text = '';

    _infoCraftVillage.text = '';
    selectedProvince = null;
    selectedWard = null;
    selectedDistrict = null;
    selectedVillage = null;
  }

  void initState() {
    super.initState();
    _checkLoginStatus();

    lsProvince = [];
    _getProvince(234);
    lsDistrict = [];
    lsWard = [];
    lsVillage = [];
    selectedProvince = null;
    selectedWard = null;
    selectedDistrict = null;
    selectedVillage = null;
  }

  //Get province list
  _getProvince(int countryId) async {
    await addressBloc.fetchProvince(countryId, () {}, (msg) {
      LoadingDialog.hideLoadingDialog(context);
      MsgDialog.showMsgDialog(context, LanguageConfig.getNotice(), msg);
    }).then((value) {
      setState(() {
        lsProvince = value;
      });
    });
  }

  //Get district list
  _getDistrict(int provinceId) async {
    print("START GET DISTRICT LIST");
    await addressBloc.fetchDistrict(provinceId, () {}, (msg) {
      LoadingDialog.hideLoadingDialog(context);
      MsgDialog.showMsgDialog(context, LanguageConfig.getNotice(), msg);
    }).then((value) {
      setState(() {
        lsDistrict = value;
        // print("CHECK LIST LENGTH: "+lsDistrict.length.toString());
      });
    });
    print("CHECK LIST LENGTH: " + lsDistrict.length.toString());
    print("END GET DISTRICT LIST");
  }

  //Get ward list
  _getWard(int districtId) async {
    await addressBloc.fetchWard(districtId, () {}, (msg) {
      LoadingDialog.hideLoadingDialog(context);
      MsgDialog.showMsgDialog(context, LanguageConfig.getNotice(), msg);
    }).then((value) {
      setState(() {
        lsWard = value;
      });
    });
  }

  //Get village list
  _getVillage(int wardId) async {
    await addressBloc.fetchVillage(wardId, () {}, (msg) {
      LoadingDialog.hideLoadingDialog(context);
      MsgDialog.showMsgDialog(context, LanguageConfig.getNotice(), msg);
    }).then((value) {
      setState(() {
        lsVillage = value;
      });
    });
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

  //Build a form that requires for household user
  List<Widget> householdInfoForm() {
    
    return <Widget>[
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
                    style: TextStyle(color: Colors.black, fontSize: 18),
                    decoration: InputDecoration(
                        errorText: snapshot.hasError ? snapshot.error : null,
                        labelText: "Họ",
                        prefixIcon: Container(
                          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                          width: 5,
                          child: Image.asset("ic_contact.png"),
                        ),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Color(0xffCED002), width: 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(6)))),
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
                    style: TextStyle(color: Colors.black, fontSize: 18),
                    decoration: InputDecoration(
                        errorText: snapshot.hasError ? snapshot.error : null,
                        labelText: "Tên",
                        prefixIcon: Container(
                          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                          width: 5,
                          child: Image.asset("ic_contact.png"),
                        ),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Color(0xffCED002), width: 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(6)))),
                  ),
                ),
              )
            ],
          )),
      Padding(
          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
          child: StreamBuilder(
              stream: auth.birthdayStream,
              builder: (context, snapshot) => MaskedTextField(
                    maskedTextFieldController: _birthdayController,
                    mask: "xx/xx/xxxx",
                    maxLength: 10,
                    keyboardType: TextInputType.number,
                    inputDecoration: new InputDecoration(
                        errorText: snapshot.hasError ? snapshot.error : null,
                        labelText: "Ngày sinh",
                        labelStyle:
                            TextStyle(color: Colors.grey[700], fontSize: 18),
                        prefixIcon: Container(
                          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                          width: 5,
                          child: Image.asset("ic_birthday.png"),
                        ),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Color(0xffCED002), width: 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(6)))),
                  ))),
      Padding(
          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
          child: StreamBuilder(
            stream: auth.personalIdStream,
            builder: (context, snapshot) => MaskedTextField(
              maskedTextFieldController: _personalController,
              maxLength: 12,
              keyboardType: TextInputType.phone,
              inputDecoration: new InputDecoration(
                  errorText: snapshot.hasError ? snapshot.error : null,
                  labelText: "CMND",
                  labelStyle: TextStyle(color: Colors.grey[700], fontSize: 18),
                  prefixIcon: Container(
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    width: 5,
                    child: Image.asset("ic_contact.png"),
                  ),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xffCED002),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(6)))),
            ),
          )),
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(6))),
          child: DropdownButton<Province>(
            underline: SizedBox(),
            hint: Text("   " + LanguageConfig.getPickProvince()),
            isExpanded: true,
            value: selectedProvince,
            onChanged: (Province value) {
              setState(() {
                selectedProvince = value;
                //Set quận/huyện
                _getDistrict(selectedProvince.provinceId);
                selectedDistrict = null;
                lsDistrict = [];
                lsWard = [];
                selectedWard = null;
                selectedVillage = null;
                lsVillage = [];
                _infoCraftVillage.text = '';
              });
            },
            items: lsProvince.map((Province province) {
              return DropdownMenuItem<Province>(
                value: province,
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      province.provinceName,
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(6))),
          child: DropdownButton<District>(
            underline: SizedBox(),
            hint: Text("   " + LanguageConfig.getPickDistrict()),
            isExpanded: true,
            value: selectedDistrict,
            onChanged: (District value) {
              setState(() {
                selectedDistrict = value;
                //set xã
                _getWard(selectedDistrict.districtId);
                selectedWard = null;
                lsWard = [];
                selectedVillage = null;
                lsVillage = [];
                _infoCraftVillage.text = '';
              });
            },
            items: lsDistrict.map((District district) {
              return DropdownMenuItem<District>(
                value: district,
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      district.districtName,
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(6))),
          child: DropdownButton<Ward>(
            underline: SizedBox(),
            hint: Text("   " + LanguageConfig.getPickWard()),
            isExpanded: true,
            value: selectedWard,
            onChanged: (Ward value) {
              setState(() {
                selectedWard = value;

                lsVillage = [];
                _infoCraftVillage.text = '';
                _getVillage(value.wardId);
                selectedVillage = null;
              });
            },
            items: lsWard.map((Ward ward) {
              return DropdownMenuItem<Ward>(
                value: ward,
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      ward.wardName,
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Container(
          height:
              _infoCraftVillage.text.trim() == "" ? _height / 3 : _height / 2.7,
          decoration: BoxDecoration(
            border: Border.all(width: 0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: _tabSection(context),
          ),
        ),
      ),
    ];
  }

  //Create a tab that let user choose their location
  Widget _tabSection(BuildContext context) {
    
    return DefaultTabController(
      initialIndex: selectTabVillage,
      length: 2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            child: TabBar(
                onTap: (index) {
                  selectTabVillage = index;
                },
                tabs: [
                  Tab(
                    child: Text("Chọn làng nghề",
                        style: TextStyle(color: Colors.black)),
                  ),
                  Tab(
                    child: Text("Thêm làng nghề",
                        style: TextStyle(color: Colors.black)),
                  ),
                ]),
          ),
          Container(
            //Add this to give height
            height: _infoCraftVillage.text.trim() == ""
                ? _height / 4.5
                : _height / 3.5,
            child: TabBarView(children: [
              Container(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.all(Radius.circular(6))),
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: DropdownButton<Village>(
                          underline: SizedBox(),
                          hint: Text(LanguageConfig.getPickVillage()),
                          isExpanded: true,
                          value: selectedVillage,
                          onChanged: (Village value) {
                            setState(() {
                              selectedVillage = value;
                              _infoCraftVillage.text = selectedVillage.note;
                            });
                          },
                          items: lsVillage.map((Village village) {
                            return DropdownMenuItem<Village>(
                              value: village,
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    village.villageName,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: Container(
                      width: double.infinity,
                      child: TextField(
                        enabled: false,
                        controller: _infoCraftVillage,
                        style: TextStyle(color: Colors.black, fontSize: 18),
                        maxLines: _infoCraftVillage.text.trim() == "" ? 1 : 4,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: LanguageConfig.getDescriptionVillage(),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xffCED002), width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6)))),
                      ),
                    ),
                  ),
                ],
              )),
              Container(
                  child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Container(
                      width: double.infinity,
                      child: TextField(
                        controller: _addCraftVillage,
                        style: TextStyle(color: Colors.black, fontSize: 16),
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: LanguageConfig.getVillageName(""),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xffCED002), width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6)))),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Container(
                      width: double.infinity,
                      child: TextField(
                        controller: _addInfoCraftVillage,
                        style: TextStyle(color: Colors.black, fontSize: 18),
                        maxLines: 2,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: LanguageConfig.getDescriptionVillage(),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xffCED002), width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6)))),
                      ),
                    ),
                  ),
                ],
              )),
            ]),
          ),
        ],
      ),
    );
  }

  //Build UI for the whole page
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
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
                  child: StreamBuilder(
                    stream: auth.userRoleStream,
                    builder: (context, snapshot) => Container(
                      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                      ),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: _userRole,
                        icon: const Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        style:
                            const TextStyle(fontSize: 18, color: Colors.black),
                        // underline: Container(
                        //   height: 1,
                        //   color: Colors.blue,
                        // ),
                        underline: SizedBox(),
                        onChanged: (String newValue) {
                          setState(() {
                            _userRole = newValue;
                            // print("Type User Sign Up: "+_userRole.toString());
                            if (_userRole == 'Cá nhân') {
                              _resetHouseHoldField();
                            }
                          });
                        },
                        items: <String>['Cá nhân', 'Hộ gia đình']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                      ),
                    ),
                  ),
                ),
                if (_userRole == 'Hộ gia đình') ...householdInfoForm(),
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
    // _usernameController.text = 'demo009';
    // _passController.text = 'demo009';
    // _repassController.text = 'demo009';
    // _firstNameController.text = 'Nguyen Van';
    // _lastNameController.text = 'Anh';
    // _phoneController.text = '0123456789';
    // _birthdayController.text = '01/01/2000';
    // _emailController.text = 'vancongleca1997@gmail.com';
    print("Type User Sign Up: "+_userRole.toString());

    var isValid = auth.isValid(
        _userRole,
        _usernameController.text,
        _passController.text,
        _repassController.text,
        _firstNameController.text,
        _lastNameController.text,
        _phoneController.text,
        _birthdayController.text,
        _emailController.text,
        _personalController.text);

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

                      auth.signUp(
                        _userRole,
                        _usernameController.text,
                        _passController.text,
                        _repassController.text,
                        _firstNameController.text,
                        _lastNameController.text,
                        _phoneController.text,
                        _birthdayController.text,
                        _emailController.text,
                        value["activeDate"],
                        value["activeCode"],
                        _inputActiveCode.text,
                        () {
                          LoadingDialog.hideLoadingDialog(context);
                          auth.signIn(
                              _usernameController.text, _passController.text,
                              () {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        HomePage()),
                                (Route<dynamic> route) => false);
                          }, (msg) {
                            LoadingDialog.hideLoadingDialog(context);
                            MsgDialog.showMsgDialog(context, "Đăng nhập", msg);
                          });
                        },
                        (msg) {
                          //show dialog
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
