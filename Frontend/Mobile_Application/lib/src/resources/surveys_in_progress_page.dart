import 'package:fl_nynberapp/src/blocs/answer_bloc.dart';
import 'package:fl_nynberapp/src/blocs/auth_bloc.dart';
import 'package:fl_nynberapp/src/blocs/image_bloc.dart';
import 'package:fl_nynberapp/src/blocs/survey_bloc.dart';
import 'package:fl_nynberapp/src/blocs/village_bloc.dart';
import 'package:fl_nynberapp/src/model/inprogress_model.dart';
import 'package:fl_nynberapp/src/resources/craft_page.dart';
import 'package:fl_nynberapp/src/resources/custom_widget/helper_custom.dart';
import 'package:fl_nynberapp/src/resources/custom_widget/language_app.dart';
import 'package:fl_nynberapp/src/resources/dialog/loading_dialog.dart';
import 'package:fl_nynberapp/src/resources/dialog/msg_dialog.dart';
import 'package:fl_nynberapp/src/resources/theme/colors/light_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nice_button/NiceButton.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'custom_widget/task_column.dart';

class SurveysInProgress extends StatefulWidget {
  @override
  _SurveysInProgressState createState() => _SurveysInProgressState();
}

double _height;
double _width;
final scaffoldKey = GlobalKey<ScaffoldState>();
var checkLoadingData = false;
String fullname = "";
String email = "";
String typeUser = "";
List<SurveysInProgressModel> lsSurveysInProgress = [];
String token = "";

class _SurveysInProgressState extends State<SurveysInProgress> {
  AuthBloc auth = new AuthBloc();
  AnswerBloc answerBloc = new AnswerBloc();
  ImageBloc imageBloc = new ImageBloc();
  SurveyBloc surveyBloc = new SurveyBloc();
  VillageBloc villageBloc = new VillageBloc();

  void initState() {
    checkLoadingData = false;
    super.initState();
    _getInfoUser();
  }

  @override
  void dispose() {
    auth.dispose();
    super.dispose();
  }

  _getInfoUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    token = sharedPreferences.getString("token");
    //goi o day
    setState(() {
      fullname = sharedPreferences.getString("fullname") != null
          ? sharedPreferences.getString("fullname")
          : "Van Cong Le Ca";
      email = sharedPreferences.getString("email") != null
          ? sharedPreferences.getString("email")
          : "cascabusiness@gmail.com";
      typeUser = sharedPreferences.getString("typeUser") != null
          ? sharedPreferences.getString("typeUser")
          : "none";
    });
  }

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    Helper helper =
        new Helper(_height, _width, scaffoldKey, context, fullname, email);

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: LightColors.kLightYellow3,
      body: Container(
        width: _width,
        constraints: BoxConstraints.expand(),
        child: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              helper.drawerMenu(),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    LanguageConfig.getListSurveysInprogress(),
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.red,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    LanguageConfig.getGroupUsing(typeUser),
                  ),
                ),
              ),
              createListInProgress(context),
            ],
          ),
        ),
      ),
      drawer: helper.drawer(),
    );
  }

  Widget createListInProgress(BuildContext context) {
    return (FutureBuilder(
      future: surveyBloc.fetchSurveysInProgress(token, () {}, (msg) {
        LoadingDialog.hideLoadingDialog(context);
        MsgDialog.showMsgDialog(context, LanguageConfig.getNotice(), msg);
      }),
      // future: _listInProgressdata,
      builder: (context, snapshot) {
        final values = snapshot.data;

        if (values == null)
          return Container(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(LanguageConfig.getNoSaveDraft()),
              ));

        return SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ListView.builder(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: values == null ? 0 : values.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: LightColors.kLightYellow3,
                        // border: Border.all(color: Colors.black,),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(5, 5), // changes position of shadow
                          ),
                        ],
                      ),
                      padding:
                          const EdgeInsets.only(left: 15, top: 10, bottom: 10),
                      margin: 
                          const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
                      child: TaskColumn(
                        icon: Icons.watch_later_outlined,
                        iconBackgroundColor: LightColors.kDarkYellow,
                        title: values[index]['villageName'].toString(),
                        subtitle: values[index]['date'].toString(),
                      ),
                    );
                  })
            ],
          ),
        );
      },
    ));
  }
}
