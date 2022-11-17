import 'package:connectivity/connectivity.dart';
import 'package:excel/excel.dart';
import 'package:fl_nynberapp/src/blocs/answer_bloc.dart';
import 'package:fl_nynberapp/src/blocs/auth_bloc.dart';
import 'package:fl_nynberapp/src/blocs/image_bloc.dart';
import 'package:fl_nynberapp/src/blocs/survey_bloc.dart';
import 'package:fl_nynberapp/src/blocs/village_bloc.dart';
import 'package:fl_nynberapp/src/model/inprogress_model.dart';
import 'package:fl_nynberapp/src/model/language_model.dart';
import 'package:fl_nynberapp/src/model/user_model.dart';
import 'package:fl_nynberapp/src/resources/craft_page.dart';
import 'package:fl_nynberapp/src/resources/custom_widget/active_project_card.dart';
import 'package:fl_nynberapp/src/resources/custom_widget/helper_custom.dart';
import 'package:fl_nynberapp/src/resources/custom_widget/language_app.dart';
import 'package:fl_nynberapp/src/resources/custom_widget/task_column.dart';
import 'package:fl_nynberapp/src/resources/custom_widget/top_container.dart';
import 'package:fl_nynberapp/src/resources/details_user_page.dart';
import 'package:fl_nynberapp/src/resources/dialog/loading_dialog.dart';
import 'package:fl_nynberapp/src/resources/dialog/msg_dialog.dart';
import 'package:fl_nynberapp/src/resources/login_page.dart';
import 'package:fl_nynberapp/src/resources/surveys_completed_page.dart';
import 'package:fl_nynberapp/src/resources/surveys_in_progress_page.dart';
import 'package:fl_nynberapp/src/resources/theme/colors/light_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

LanguageConfig languageConfig;
double _height;
double _width;
bool isHomePage;
var scaffoldKey = GlobalKey<ScaffoldState>();
String fullname = "";
String email = "";
String typeUser = "";
String token = "";
Future<ConnectivityResult> _streamCheckInternet;
List<SurveysInProgressModel> lsSurveysInProgress = [];
SurveysInProgressModel surveysPrivatePerson,
    surveysLocalAuthority,
    surveysHouseHold;
//Language
List<LanguageApp> lsLanguage = [];

LanguageApp selectedLanguage;

//EndLanguage
class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  AuthBloc auth = new AuthBloc();
  AnswerBloc answerBloc = new AnswerBloc();
  ImageBloc imageBloc = new ImageBloc();
  SurveyBloc surveyBloc = new SurveyBloc();
  VillageBloc villageBloc = new VillageBloc();

  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _getLanguage();
    isHomePage = true;
    surveysPrivatePerson = null;
    surveysLocalAuthority = null;
    surveysHouseHold = null;
    _getInfoUser();
    _getListInProgress();
    _streamCheckInternet = _checkInternetConnectivity();
    scaffoldKey = GlobalKey<ScaffoldState>();
    typeUser = "";
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    auth.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) return;

    final isForeground = state == AppLifecycleState.resumed;

    if (isForeground && isHomePage) {
      Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CraftPage(null, 0, 0, null)))
          .then((value) => isHomePage = true);
      isHomePage = false;
    }
  }

  //Get user information
  _getInfoUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString("token");
    String us = sharedPreferences.getString("us");
    String pw = sharedPreferences.getString("pw");

    if (token == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => LoginPage()));
      });
    } else {
      // setState(() {
      //   fullname = sharedPreferences.getString("fullname")??"";
      //   email = sharedPreferences.getString("email")??"";
      // });
      //goi o day
      // String token = sharedPreferences.getString("token");
      await auth.fetchUser(() {}, (msg) {
        LoadingDialog.hideLoadingDialog(context);
        MsgDialog.showMsgDialog(context, LanguageConfig.getNotice(), msg);
      }).then((value) {
        if (value == null) {
          print("null rồi");
          setState(() {
            fullname = "";
          });
          // print("us $us + pw $pw");
          // auth.signIn(us, pw, () {
          //   print("oekeeeeeeeeeeeeeeeeeee");
          //   Navigator.of(context).pop('String');

          // }, (error) {
          //   print("ZZZZZZZZZZZZZZZZZZZZZZZZZZoekeeeeeeeeeeeeeeeeeee");
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            await showDialog<String>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => new AlertDialog(
                title: new Text(LanguageConfig.getNotice()),
                content: new Text(LanguageConfig.getRelogin()),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text(LanguageConfig.getOK()),
                    onPressed: () {
                      print("aaaaaaaaaaaaa");
                      sharedPreferences.clear();
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (BuildContext context) => LoginPage()),
                          (Route<dynamic> route) => false);
                    },
                  ),
                ],
              ),
            );
          });
          return;
          // });
        } else {
          if (!mounted) return;
          setState(() {
            fullname = value.lastname + " " + value.firstname;
            email = value.email;

            typeUser = value.type == TypeOfUser.HouseHold
                ? LanguageConfig.getHouseHold()
                : (value.type == TypeOfUser.LocalAuthority
                    ? LanguageConfig.getLocalAuthority()
                    : LanguageConfig.getPrivatePerson());

            print("Type User: "+typeUser);
            sharedPreferences.setString("typeUser", typeUser);
          });
        }
      });
    }
  }

  //Get list of survey in progress
  _getListInProgress() async {
    await surveyBloc.fetchSurveysInProgress(() {}, (msg) {
      LoadingDialog.hideLoadingDialog(context);
      MsgDialog.showMsgDialog(context, LanguageConfig.getNotice(), msg);
    }).then((value) {
      lsSurveysInProgress = value;
      lsSurveysInProgress.forEach((element) {
        print(element.typeSurvey);
        if (element.typeSurvey == "PrivatePerson") {
          setState(() {
            surveysPrivatePerson = element;
          });
          return;
        } else if (element.typeSurvey == "HouseHold") {
          setState(() {
            surveysHouseHold = element;
          });
          return;
        } else if (element.typeSurvey == "Local Authority") {
          setState(() {
            surveysLocalAuthority = element;
          });
          return;
        }
      });
    });
  }

  //Get the current language (EN/VN)
  _getLanguage() {
    lsLanguage = [];
    lsLanguage.add(new LanguageApp(languageID: 1, languageName: "VIE"));
    lsLanguage.add(new LanguageApp(languageID: 2, languageName: "ENG"));

    checkExistSelectLanguage();
  }

  //Check the current selected language (EN/VN)
  checkExistSelectLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String checkLanguage = prefs.getString("selectLanguage");
    if (checkLanguage != null) {
      lsLanguage.forEach((element) {
        if (element.languageName == checkLanguage) selectedLanguage = element;
      });
    } else
      selectedLanguage = lsLanguage[1];
  }

  //Checks the connection status of the device
  Future<ConnectivityResult> _checkInternetConnectivity() async {
    var result = await Connectivity().checkConnectivity();
    return Future.value(result);
  }

  //Parse excel from assets
  Future<Excel> parseExcelFromAssets(String assetPath) async {
    ByteData data = await rootBundle.load(assetPath);
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    return Excel.decodeBytes(
      bytes,
      // update: true,
    );
  }

  //Homepage widgets
  Widget bodyHomePage(BuildContext context, Helper helper) {
    return StreamBuilder(
        stream: _streamCheckInternet.asStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var result = snapshot.data;
            if (result != ConnectivityResult.none) {
              return Container(
                width: _width,
                constraints: BoxConstraints.expand(),
                child: SingleChildScrollView(
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // helper.drawerMenu(),
                      TopContainer(
                        width: _width,
                        height: 200,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              helper.menuButton(),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 0.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    CircularPercentIndicator(
                                      radius: 90.0,
                                      lineWidth: 5.0,
                                      animation: true,
                                      percent: 0.75,
                                      circularStrokeCap:
                                          CircularStrokeCap.round,
                                      progressColor: LightColors.kRed,
                                      backgroundColor: LightColors.kDarkYellow,
                                      center: CircleAvatar(
                                        backgroundColor: LightColors.kBlue,
                                        radius: 35.0,
                                        backgroundImage: AssetImage(
                                          'assets/images/avatar.png',
                                        ),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          child: Text(
                                            fullname,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize: 22.0,
                                              color: LightColors.kDarkBlue,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          child: Text(
                                            typeUser,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              color: Colors.black45,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 80,
                                          height: 80,
                                          child: AbsorbPointer(
                                            absorbing:
                                                false, //Unblock drop down menu
                                            child: DropdownButton<LanguageApp>(
                                              underline: SizedBox(),
                                              isExpanded: true,
                                              value: selectedLanguage,
                                              onChanged: (LanguageApp value) {
                                                setState(() {
                                                  selectedLanguage = value;
                                                  saveDataFromSelectLanguage(
                                                      selectedLanguage);
                                                  String pathLanguageConfig =
                                                      "assets/excel/CVlang.xlsx";
                                                  parseExcelFromAssets(
                                                          pathLanguageConfig)
                                                      .then((excel) {
                                                    LanguageConfig
                                                        languageConfig =
                                                        new LanguageConfig(
                                                            selectedLanguage
                                                                .languageName,
                                                            excel);
                                                  });
                                                });
                                              },
                                              //   onChanged: null,
                                              items: lsLanguage
                                                  .map((LanguageApp type) {
                                                return DropdownMenuItem<
                                                    LanguageApp>(
                                                  value: type,
                                                  child: Row(
                                                    children: <Widget>[
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        type.languageName,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ]),
                      ),
                      Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              color: Colors.transparent,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      subheading(LanguageConfig.getMyTasks()),
                                    ],
                                  ),
                                  SizedBox(height: 15.0),
                                  GestureDetector(
                                    onTap: () {
                                      // Navigator.of(context).pushNamed(PETS_ITEM_LIST);
                                      // _showDialogTypes(context);

                                      // LoadingDialog.showLoadingDialog(
                                      //     context, LanguageConfig.getLoading());
                                      // if (typeUser != "noneType") {
                                      //   LoadingDialog.hideLoadingDialog(
                                      //       context);
                                      //   showAlertDialogNewSurvey(
                                      //       context, typeUser);
                                      // }
                                      print("Start new survey!");
                                      Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CraftPage(
                                                          null, 0, 0, null)))
                                          .then((value) => isHomePage = true);
                                      isHomePage = false;
                                    },
                                    child: TaskColumn(
                                      icon: Icons.alarm,
                                      iconBackgroundColor: LightColors.kRed,
                                      title: LanguageConfig.getNewSurvey(),
                                      subtitle:
                                          LanguageConfig.getNewSurveyTitle(),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      // Navigator.of(context).pushNamed(PETS_ITEM_LIST);
                                      // _showDialogTypes(context);
                                      Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SurveysInProgress()))
                                          .then((value) => isHomePage = true);
                                      isHomePage = false;
                                    },
                                    child: TaskColumn(
                                      icon: Icons.blur_circular,
                                      iconBackgroundColor:
                                          LightColors.kDarkYellow,
                                      title: LanguageConfig.getInProgress(),
                                      subtitle:
                                          LanguageConfig.getInProgressTile(),
                                    ),
                                  ),
                                  SizedBox(height: 15.0),
                                  GestureDetector(
                                    onTap: () {
                                      // Navigator.of(context).pushNamed(PETS_ITEM_LIST);
                                      // _showDialogTypes(context);
                                      Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SurveysCompleted()))
                                          .then((value) => isHomePage = true);
                                      isHomePage = false;
                                    },
                                    child: TaskColumn(
                                      icon: Icons.check_circle_outline,
                                      iconBackgroundColor: LightColors.kBlue,
                                      title: LanguageConfig.getCompleted(),
                                      subtitle:
                                          LanguageConfig.getCompletedTitle(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              color: Colors.transparent,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  subheading(
                                      LanguageConfig.getInProgressSurveys()),
                                  SizedBox(height: 5.0),
                                  Row(
                                    children: <Widget>[
                                      ActiveProjectsCard(
                                        cardColor: LightColors.kGreen,
                                        loadingPercent: surveysPrivatePerson !=
                                                null
                                            ? surveysPrivatePerson.totalAnswer /
                                                surveysPrivatePerson
                                                    .totalQuestion
                                            : 0,
                                        title:
                                            LanguageConfig.getPrivatePerson(),
                                        subtitle:
                                            LanguageConfig.getNewSurveyTitle(),
                                      ),
                                      SizedBox(width: 20.0),
                                      ActiveProjectsCard(
                                        cardColor: LightColors.kRed,
                                        loadingPercent:
                                            surveysLocalAuthority != null
                                                ? surveysLocalAuthority
                                                        .totalAnswer /
                                                    surveysLocalAuthority
                                                        .totalQuestion
                                                : 0,
                                        title:
                                            LanguageConfig.getLocalAuthority(),
                                        subtitle: LanguageConfig
                                            .getNewSurveySubtitle(),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      ActiveProjectsCard(
                                        cardColor: LightColors.kDarkGreen,
                                        loadingPercent: surveysHouseHold != null
                                            ? surveysHouseHold.totalAnswer /
                                                surveysHouseHold.totalQuestion
                                            : 0,
                                        title: LanguageConfig.getHouseHold(),
                                        subtitle: LanguageConfig
                                            .getNewSurveySubtitle(),
                                      ),
                                      SizedBox(width: 20.0),
                                      ActiveProjectsCard(
                                        cardColor: LightColors.kBlue,
                                        loadingPercent: 0,
                                        title: LanguageConfig.getAchievement(),
                                        subtitle: LanguageConfig
                                            .getAchievementSubtitle(),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            } else {
              return Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(LanguageConfig.getNoInternet()),
                    FloatingActionButton(
                      tooltip: LanguageConfig.getNoInternetTooltip(),
                      child: Icon(Icons.refresh),
                      onPressed: () {
                        setState(() {
                          _streamCheckInternet = _checkInternetConnectivity();
                        });
                      },
                    ),
                  ],
                ),
              );
            }
          }
          return Container();
        });
  }

  //Build the UI for the whole page
  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;
    Helper helper =
        new Helper(_height, _width, scaffoldKey, context, fullname, email);

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: LightColors.kLightYellow3,
      body: bodyHomePage(context, helper),
      drawer: helper.drawer(),
    );
  }

  //Save data from select language
  saveDataFromSelectLanguage(LanguageApp lg) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("selectLanguage", lg.languageName);
  }

  Text subheading(String title) {
    return Text(
      title,
      style: TextStyle(
          color: LightColors.kDarkBlue,
          fontSize: 20.0,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2),
    );
  }

  //Show alert dialog for a new survey
  showAlertDialogNewSurvey(BuildContext context, String type) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text(LanguageConfig.getCancel()),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget changeButton = FlatButton(
      child: Text(LanguageConfig.getChangeGroup()),
      onPressed: () {
        Navigator.pop(context);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => DetailsUserPage()));
      },
    );
    Widget continueButton = FlatButton(
      child: Text(LanguageConfig.getSkipAndSurvey()),
      onPressed: () {
        print("Start Survey Here!");
        Navigator.pop(context);
        LoadingDialog.showLoadingDialog(
            context, LanguageConfig.getProcessing());
        surveyBloc.checkSurveyInProgress(() {}, (msg) {
          LoadingDialog.hideLoadingDialog(context);
          MsgDialog.showMsgDialog(context, LanguageConfig.getNotice(), msg);
        }).then((value) {
          LoadingDialog.hideLoadingDialog(context);
          if (value.toString() == "true") {
            showCheckInProgressDialog(context);
          } else {
            print("Jump Here!");
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CraftPage(null, 0, 0, null)));
          }
        });
      },
    );

    //Set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(LanguageConfig.getNotice()),
      content: Container(
          child: Text(
        LanguageConfig.getNoticeChangeGroup(type),
        textAlign: TextAlign.justify,
      )),
      actions: [
        cancelButton,
        changeButton,
        continueButton,
      ],
    );

    //Show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showCheckInProgressDialog(BuildContext context) {
    // set up the buttons
    Widget breakButton = FlatButton(
      child: Text(LanguageConfig.getCancel()),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget cancelButton = FlatButton(
      child: Text(LanguageConfig.getOK()),
      onPressed: () {
        answerBloc.resetUserSurvey(() {}, (msg) {
          LoadingDialog.hideLoadingDialog(context);
          MsgDialog.showMsgDialog(context, LanguageConfig.getNotice(), msg);
        }).then((value) {
          if (value.toString() == "true") {
            if (surveysPrivatePerson != null &&
                typeUser == surveysPrivatePerson.typeSurvey) {
              setState(() {
                surveysPrivatePerson = null;
              });
            } else if (surveysLocalAuthority != null &&
                typeUser == surveysLocalAuthority.typeSurvey) {
              setState(() {
                surveysLocalAuthority = null;
              });
            } else if (surveysHouseHold != null &&
                typeUser == surveysHouseHold.typeSurvey) {
              setState(() {
                surveysHouseHold = null;
              });
            }
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CraftPage(null, 0, 0, null)));
          }
        });
      },
    );
    Widget continueButton = FlatButton(
      child: Text(LanguageConfig.getComeInprogress()),
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => SurveysInProgress()));
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(LanguageConfig.getNotice()),
      content: Text(LanguageConfig.getRemoveInprogress()),
      actions: [
        breakButton,
        continueButton,
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
