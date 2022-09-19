import 'package:fl_nynberapp/src/blocs/answer_bloc.dart';
import 'package:fl_nynberapp/src/blocs/auth_bloc.dart';
import 'package:fl_nynberapp/src/blocs/image_bloc.dart';
import 'package:fl_nynberapp/src/blocs/survey_bloc.dart';
import 'package:fl_nynberapp/src/blocs/village_bloc.dart';
import 'package:fl_nynberapp/src/model/completed_model.dart';
import 'package:fl_nynberapp/src/resources/craft_page.dart';
import 'package:fl_nynberapp/src/resources/custom_widget/helper_custom.dart';
import 'package:fl_nynberapp/src/resources/custom_widget/language_app.dart';
import 'package:fl_nynberapp/src/resources/dialog/loading_dialog.dart';
import 'package:fl_nynberapp/src/resources/dialog/msg_dialog.dart';
import 'package:fl_nynberapp/src/resources/theme/colors/light_colors.dart';
import 'package:flutter/material.dart';
import 'package:nice_button/NiceButton.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SurveysCompleted extends StatefulWidget {
  @override
  _SurveysCompletedState createState() => _SurveysCompletedState();
}

double _height;
double _width;
var scaffoldKey = GlobalKey<ScaffoldState>();
var checkLoadingData = false;
String fullname = "";
String email = "";
String token = "";
String typeUser = "";
List<SurveysCompletedModel> lsSurveysCompleted = [];

class _SurveysCompletedState extends State<SurveysCompleted> {
  AuthBloc auth = new AuthBloc();
  AnswerBloc answerBloc = new AnswerBloc();
  ImageBloc imageBloc = new ImageBloc();
  SurveyBloc surveyBloc = new SurveyBloc();
  VillageBloc villageBloc = new VillageBloc();
  void initState() {
    super.initState();
    //checkLoadingData = false;
    _getInfoUser();
  }

  @override
  void dispose() {
    super.dispose();
    auth.dispose();
  }

  _getInfoUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    token = sharedPreferences.getString("token");
    //goi o day
    setState(() {
      fullname = sharedPreferences.getString("fullname") != null
          ? sharedPreferences.getString("fullname")
          : "Nguyen Duc Nghia";
      email = sharedPreferences.getString("email") != null
          ? sharedPreferences.getString("email")
          : "ndnghia69@gmail.com";
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
                    LanguageConfig.getListSurveysCompleted(),
                    style: TextStyle(fontSize: 20, color: Colors.red),
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
                  child: Text(LanguageConfig.getGroupUsing(typeUser)),
                ),
              ),
              createListCompleted(context)
            ],
          ),
        ),
      ),
      drawer: helper.drawer(),
    );
  }

  Widget createListCompleted(BuildContext context) {
    return (FutureBuilder(
      future: surveyBloc.fetchSurveysCompleted(token, () {}, (msg) {
        LoadingDialog.hideLoadingDialog(context);
        MsgDialog.showMsgDialog(context, LanguageConfig.getNotice(), msg);
      }),
      builder: (context, snapshot) {
        var values = snapshot.data;
        if (values == null || values.length == 0)
          return Container(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(LanguageConfig.getNoCompleted()),
              ));
        return SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: values == null ? 0 : values.length,
                itemBuilder: (BuildContext context, int index) {
                  return ExpansionTile(
                    title: Text(typeUser +
                        " - " +
                        values[index].dateSubmitSurvey),
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          LanguageConfig.getVillageName(values[index].villageName.toString()),
                         // "Tên làng nghề: ${values[index].villageName.toString()}",
                          textAlign: TextAlign.left,
                        ),
                        onTap: () {
                          print("abbbbb");
                        },
                      ),
                      ListTile(
                        title: Text(
                          LanguageConfig.getNumberOfMainQuestion(values[index].totalQuestion.toString()),
                          //"Số câu hỏi chính:  " +
                         //     values[index].totalQuestion.toString(),
                          //  "Số câu hỏi: 17",
                          textAlign: TextAlign.left,
                        ),
                        onTap: () {
                          print("abbbbb");
                        },
                      ),

                      ListTile(
                        title: Text(
                          LanguageConfig.getNumberOfMainAnswer(values[index].totalAnswer.toString()),
                        //  "Số câu đã trả lời chính:  " +
                        //      values[index].totalAnswer.toString(),
                          //  "Số câu đã trả lời: 6",
                          textAlign: TextAlign.left,
                        ),
                        onTap: () {
                          print("abbbbb");
                        },
                      ),
                      ListTile(
                        title: Text(
                          LanguageConfig.getNumberImage(values[index].totalImage.toString()),
                       //   "Số ảnh:  " + values[index].totalImage.toString(),
                          //     "Số ảnh:  2",
                          textAlign: TextAlign.left,
                        ),
                        onTap: () {
                          print("abbbbb");
                        },
                      ),
                      ListTile(
                        title: Text(
                          LanguageConfig.getTypeSurvey(typeUser),
                          //  "Số ảnh:  2",
                          textAlign: TextAlign.left,
                        ),
                        onTap: () {
                          print("abbbbb");
                        },
                      ),
                      values[index].typeSurvey == (typeUser == "Người riêng tư" ? "PrivatePerson" : (typeUser == "Hộ gia đình") ? "HouseHold" : "LocalAuthority") ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topLeft,
                            child: NiceButton(
                              width: _width/2,
                              text:  LanguageConfig.getContinueSurvey(),
                              fontSize: 18,
                              textColor: Colors.white,
                              background: Color(0xff5b86e5),
                              gradientColors: [
                                Color(0xff5b86e5),
                                Color(0xff36d1dc)
                              ],
                              onPressed: () {
                                MsgDialog.showAlertDialog(context,  LanguageConfig.getNotice(),
                                    LanguageConfig.getContinueSurveyNotice(),
                                    () {
                                  Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) => CraftPage(
                                            values[index].surveyActiveID,
                                            values[index].totalImage,
                                            values[index].userSurveyId,
                                            values[index].filename)),
                                  );
                                });
                              },
                            ),
                          ),
                        ],
                      ) : Container()
                    ],
                  );
                },
              )
            ],
          ),
        );
      },
    ));
  }
}
