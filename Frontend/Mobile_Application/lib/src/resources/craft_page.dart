import 'dart:collection';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:exif/exif.dart';
import 'package:fl_nynberapp/src/app.dart';
import 'package:fl_nynberapp/src/blocs/address_bloc.dart';
import 'package:fl_nynberapp/src/blocs/answer_bloc.dart';
import 'package:fl_nynberapp/src/blocs/auth_bloc.dart';
import 'package:fl_nynberapp/src/blocs/image_bloc.dart';
import 'package:fl_nynberapp/src/blocs/survey_bloc.dart';
import 'package:fl_nynberapp/src/blocs/village_bloc.dart';
import 'package:fl_nynberapp/src/model/address/district_model.dart';
import 'package:fl_nynberapp/src/model/address/province_model.dart';
import 'package:fl_nynberapp/src/model/address/village_model.dart';
import 'package:fl_nynberapp/src/model/address/ward_model.dart';
import 'package:fl_nynberapp/src/model/answer_model.dart';
import 'package:fl_nynberapp/src/model/answer_user_model.dart';
import 'package:fl_nynberapp/src/model/answer_user_village_model.dart';
import 'package:fl_nynberapp/src/model/image_upload_model.dart';
import 'package:fl_nynberapp/src/model/infoPolygon_model.dart';
import 'package:fl_nynberapp/src/model/language_model.dart';
import 'package:fl_nynberapp/src/model/question_model.dart';
import 'package:fl_nynberapp/src/model/survey_answer_user_by_id.dart';
import 'package:fl_nynberapp/src/model/survey_status_model.dart';
import 'package:fl_nynberapp/src/model/village_user_model.dart';
import 'package:fl_nynberapp/src/resources/custom_widget/checkbox_list_tile_custom.dart';
import 'package:fl_nynberapp/src/resources/custom_widget/helper_custom.dart';
import 'package:fl_nynberapp/src/resources/custom_widget/language_app.dart';
import 'package:fl_nynberapp/src/resources/dialog/loading_dialog.dart';
import 'package:fl_nynberapp/src/resources/dialog/msg_dialog.dart';
import 'package:fl_nynberapp/src/resources/theme/colors/light_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geojson/geojson.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import "package:latlong/latlong.dart" as latLng;
import 'package:flutter/services.dart';

class CraftPage extends StatefulWidget {
  //final Position position;
  final int surveyActiveID;
  final int totalImageGlobal;
  final int userSurveyId;
  final List<String> filename;
  CraftPage(this.surveyActiveID, this.totalImageGlobal, this.userSurveyId,
      this.filename);
  //HomePage(this.position);
  @override
  _CraftPageState createState() => _CraftPageState(this.surveyActiveID,
      this.totalImageGlobal, this.userSurveyId, this.filename);
}

double _height;
double _width;
var scaffoldKey = GlobalKey<ScaffoldState>();
String fullname = "";
String email = "";
String typeUser = "";
List<Question> lsQuestion = new List<Question>();
List<Question> lsQuestionTemp = new List<Question>();
List<int> listFirstQuest = [];
Map<String, CheckboxListTileCustom> listCheckboxWidget = new Map();

SurveyStatus surveyStatus = new SurveyStatus();
SurveyAnswerUserByID surveyAnswerUserByID = new SurveyAnswerUserByID();

List<Answer> selectedAnswer = new List<Answer>();
List<bool> visibleAnother = new List<bool>();
List<bool> visibleQuestion = new List<bool>();
bool isAnother = false;

//Save widgets that display village information in survey
Widget surveyVillageInfo;
bool isDisplay = false;

//Test list visible
List<bool> listVisbileQuestion = [];

//Image base 64
String base64Img;

//Checkbox
List<List<bool>> lsCheckbox = new List<List<bool>>();
List<TextEditingController> _listController = [];
List<TextEditingController> _listOtherController = [];
bool _checkedAirPollution = false;
bool _checkedSoilPollution = false;
bool _checkedWaterPollution = false;
//List các câu trả lời của user
List<AnswerUser> lsAnswerUser = [];
//check xem đã load hết dữ liệu hay chưa
var checkLoadingData;
var nullValue;
var checkIconLoading = true;
int lgnQuestion = 0;
int lengthListQuest = 0;

int countFatherQuest = 0;

//Language
List<LanguageApp> lsLanguage = [];

LanguageApp selectedLanguage;

// Address
List<Province> lsProvince;
Province selectedProvince;

List<District> lsDistrict;
District selectedDistrict;

List<Ward> lsWard;
Ward selectedWard;

// End Address
TextField villageDescription;
List<Village> lsVillage;
Village selectedVillage;
Village selectedVillageImage;
//Image
List imgList = [];
List<String> base64Picture;

TextEditingController _infoCraftVillage = new TextEditingController();

TextEditingController _addCraftVillage = new TextEditingController();
TextEditingController _addInfoCraftVillage = new TextEditingController();
TextEditingController _additionalInfo = new TextEditingController();
Future<File> file;

List<Object> images = List<Object>();
Future<PickedFile> _imageFile;
//End iMage

//Tạo ảnh
int _imageNumber = 4;
List<File> lsImage = new List(_imageNumber);
bool enableAddCV = false;

//end tạo ảnh

//tính toán  tính toán số câu tl / tổng số câu hỏi
int totalQuestion = 0, toltalUserAnswerQuestion = 0;
double lat, long;
List<Village> lsVil = [];
LanguageConfig languageConfig;
final List<Tab> tabsVillage = <Tab>[
  Tab(text: 'Pick'),
  Tab(text: 'Add'),
];
TabController _controllerTabVillage;
int selectTabVillage = 0;
bool checkLoadingVillage;

class _CraftPageState extends State<CraftPage> {
  // List<TextEditingController> _listController = new List<TextEditingController>();
  Map<String, dynamic> _deviceData = <String, dynamic>{};
  int surveyActiveID;
  int totalImageGlobal;
  int userSurveyId;
  List<String> filename;
  _CraftPageState(this.surveyActiveID, this.totalImageGlobal, this.userSurveyId,
      this.filename);
  AuthBloc auth = new AuthBloc();
//  bool expanded = true;
  // AnimationController controller;
  AddressBloc addressBloc = new AddressBloc();

  AnswerBloc answerBloc = new AnswerBloc();
  ImageBloc imageBloc = new ImageBloc();
  SurveyBloc surveyBloc = new SurveyBloc();
  VillageBloc villageBloc = new VillageBloc();
  // var location = Location();
  void initState() {
    //CHÚ Ý: NÊN ĐỔI TẤT CẢ CHỮ TF => OTHER
    super.initState();
    scaffoldKey = GlobalKey<ScaffoldState>();
    fullname = "";
    email = "";
    lsQuestion = new List<Question>();
    lsQuestionTemp = new List<Question>();
    listFirstQuest = [];

    lgnQuestion = 0;
    lengthListQuest = 0;

    _checkedAirPollution = false;
    _checkedSoilPollution = false;
    _checkedWaterPollution = false;

    countFatherQuest = 0;
    checkLoadingVillage = false;
    surveyStatus = new SurveyStatus();
    surveyAnswerUserByID = new SurveyAnswerUserByID();

    selectedAnswer = new List<Answer>();
    visibleAnother = new List<bool>();
    visibleQuestion = new List<bool>();
    isAnother = false;
    lsVil = [];
    _imageFile = null;
    _getInfoUser();

    _getLanguage();
    images = List<Object>();
    setState(() {
      images.add("Add Image");
      // images.add("Add Image");
      // images.add("Add Image");

      lsProvince = [];
      lsDistrict = [];
      lsWard = [];
      lsVillage = [];
      selectedProvince = null;
      selectedWard = null;
      selectedDistrict = null;
      selectedVillage = null;
      selectedVillageImage = null;
    });
    //  _getProvince(234);
//ảnh
    lat = 16.4592479;
    long = 107.5906862;
    lsImage = new List(_imageNumber);

//Checkbox
    lsCheckbox = new List<List<bool>>();
    _listController = [];
    _listOtherController = [];
//List các câu trả lời của user
    lsAnswerUser = [];
    checkLoadingData = false;
    nullValue = false;
    checkIconLoading = true;

    listVisbileQuestion = [];
    _infoCraftVillage.text = "";
    _getProvince(234);

    // Gmap
    rootBundle.loadString('assets/map/map_style.json').then((string) {
      _mapStyle = string;
      checkLoadingMap = false;
      loadAllDataSet();
    });
    // checkLoadingMap = false;
    // loadAllDataSet();
    //End Gmap

    //add craftvillage

    _addCraftVillage = new TextEditingController();
    _addInfoCraftVillage = new TextEditingController();
    _additionalInfo = new TextEditingController();

    //end craftvillage
    print("Survey Active ID:" + surveyActiveID.toString());
    // if (surveyActiveID == null) {
    //   surveyBloc.fetchSurvey(() {}, (msg) {
    //     LoadingDialog.hideLoadingDialog(context);
    //     MsgDialog.showMsgDialog(context, LanguageConfig.getNotice(), msg);
    //   }).then((value) {
    //     if (value.srSurvey == null) {
    //       print("Survey null!");
    //     } else {
    //       selectTabVillage = 0;
    //       setState(() {
    //         surveyStatus = value;

    //         lsQuestionTemp = surveyStatus.srSurvey.srQuestions;

    //         Question quest = new Question();
    //         for (int i = 0; i < lsQuestionTemp.length; i++) {
    //           listFirstQuest.add(countFatherQuest++);
    //           quest = lsQuestionTemp[i];
    //           lsQuestion.add(lsQuestionTemp[i]);

    //           if (quest.answer.length != 0) {
    //             countListQuest(quest.answer);
    //           }
    //         }
    //         lgnQuestion = lsQuestion.length;
    //         selectedAnswer = new List(lgnQuestion);
    //         visibleAnother = new List(lgnQuestion);
    //         visibleQuestion = new List(lgnQuestion);
    //         listVisbileQuestion = new List(lgnQuestion);
    //         for (int i = 0; i < lgnQuestion; i++) {
    //           listVisbileQuestion[i] = false;
    //         }

    //         for (int i = 0; i < lgnQuestion; i++) {
    //           visibleAnother[i] = false;
    //           visibleQuestion[i] = false;
    //         }
    //         _listController =
    //             List.generate(lgnQuestion, (i) => TextEditingController());
    //         //add length list checkbox
    //         lsCheckbox = new List(lgnQuestion);
    //         //set default checkbox
    //         for (int j = 0; j < lgnQuestion; j++) {
    //           if (lsQuestion[j].questionType == KindOfQuestion.Checkbox) {
    //             lsCheckbox[j] = new List(lsQuestion[j]
    //                 .answer
    //                 .length); // ví dụ như 1 câu hỏi có 3 câu trả lời, thì cấp hắn list có độ dài là 3
    //             for (int i = 0; i < lsCheckbox[j].length; i++) {
    //               // đoạn này set false hết những câu trả lời, để mới mặc định ban đầu nó chưa đc chọn
    //               lsCheckbox[j][i] = false;
    //             }
    //           }
    //         }
    //       });
    //       totalQuestion = 0;
    //       toltalUserAnswerQuestion = 0;
    //       setState(() {
    //         totalQuestion = listFirstQuest.length;
    //       });
    //       print("totalQuestion : $totalQuestion");
    //     }
    //   });
    // } else {
    //   surveyBloc.fetchSurveyAnswerUserByID(surveyActiveID, userSurveyId, () {},
    //       (msg) {
    //     LoadingDialog.hideLoadingDialog(context);
    //     MsgDialog.showMsgDialog(context, LanguageConfig.getNotice(), msg);
    //   }).then((value) {
    //     // if (value != null) {

    //     if (value.surveys == null) {
    //       print("value null");
    //     } else {
    //       setState(() {
    //         surveyAnswerUserByID = value;

    //         lsQuestionTemp = surveyAnswerUserByID.surveys.srQuestions;

    //         Question quest = new Question();
    //         for (int i = 0; i < lsQuestionTemp.length; i++) {
    //           listFirstQuest.add(countFatherQuest++);
    //           quest = lsQuestionTemp[i];
    //           lsQuestion.add(lsQuestionTemp[i]);

    //           if (quest.answer.length != 0) {
    //             countListQuest(quest.answer);
    //           }
    //         }
    //         lgnQuestion = lsQuestion.length;
    //         selectedAnswer = new List(lgnQuestion);
    //         visibleAnother = new List(lgnQuestion);
    //         visibleQuestion = new List(lgnQuestion);
    //         listVisbileQuestion = new List(lgnQuestion);
    //         for (int i = 0; i < lgnQuestion; i++) {
    //           listVisbileQuestion[i] = false;
    //         }

    //         for (int i = 0; i < lgnQuestion; i++) {
    //           visibleAnother[i] = false;
    //           visibleQuestion[i] = false;
    //         }
    //         _listController =
    //             List.generate(lgnQuestion, (i) => TextEditingController());
    //         //add length list checkbox
    //         lsCheckbox = new List(lgnQuestion);
    //         //set default checkbox
    //         for (int j = 0; j < lgnQuestion; j++) {
    //           if (lsQuestion[j].questionType == KindOfQuestion.Checkbox) {
    //             lsCheckbox[j] = new List(lsQuestion[j]
    //                 .answer
    //                 .length); // ví dụ như 1 câu hỏi có 3 câu trả lời, thì cấp hắn list có độ dài là 3
    //             for (int i = 0; i < lsCheckbox[j].length; i++) {
    //               // đoạn này set false hết những câu trả lời, để mới mặc định ban đầu nó chưa đc chọn
    //               lsCheckbox[j][i] = false;
    //             }
    //           }
    //         }

    //         List<AnswerUser> lsAnswerUserTemp = surveyAnswerUserByID.answers;

    //         for (int i = 0; i < lgnQuestion; i++) {
    //           for (int j = 0; j < lsAnswerUserTemp.length; j++) {
    //             if (lsQuestion[i].id == lsAnswerUserTemp[j].questionID) {
    //               if (lsQuestion[i].questionType ==
    //                   KindOfQuestion.RadioCheckbox) {
    //                 for (int k = 0; k < lsQuestion[i].answer.length; k++) {
    //                   if (lsQuestion[i].answer[k].id.toString() ==
    //                       lsAnswerUserTemp[j].answerContent[0]) {
    //                     if (lsQuestion[i].answer[k].answerType !=
    //                         KindOfAnswer.Other) {
    //                       selectedAnswer[i] = lsQuestion[i].answer[k];
    //                       //visibleQuestion[i] = true;
    //                     } else {
    //                       //  visibleQuestion[i] = true;
    //                       selectedAnswer[i] = lsQuestion[i].answer[k];
    //                       // visibleAnother[i] = true;
    //                       _listController[i].text =
    //                           lsAnswerUserTemp[j].answerOtherContent;
    //                     }
    //                   }
    //                 }
    //               } else if (lsQuestion[i].questionType ==
    //                   KindOfQuestion.TextField) {
    //                 _listController[i].text =
    //                     lsAnswerUserTemp[j].answerContent[0];
    //               } else if (lsQuestion[i].questionType ==
    //                   KindOfQuestion.TextFieldNumber) {
    //                 _listController[i].text =
    //                     lsAnswerUserTemp[j].answerContent[0];
    //               } else if (lsQuestion[i].questionType ==
    //                   KindOfQuestion.Checkbox) {
    //                 for (int k = 0; k < lsQuestion[i].answer.length; k++) {
    //                   for (int p = 0;
    //                       p < lsAnswerUserTemp[j].answerContent.length;
    //                       p++) {
    //                     if (lsQuestion[i].answer[k].id.toString() ==
    //                         lsAnswerUserTemp[j].answerContent[p]) {
    //                       if (lsQuestion[i].answer[k].answerType !=
    //                           KindOfAnswer.Other) {
    //                         lsCheckbox[i][k] = true;
    //                         //  visibleQuestion[i] = true;
    //                       } else {
    //                         //   visibleQuestion[i] = true;
    //                         visibleAnother[i] = true;
    //                         lsCheckbox[i][k] = true;
    //                         _listController[i].text =
    //                             lsAnswerUserTemp[j].answerOtherContent;
    //                       }
    //                     }
    //                   }
    //                 }
    //               }
    //             }
    //           }
    //         }
    //         for (int i = 0; i < listFirstQuest.length; i++) {
    //           //  print(listFirstQuest[i]);
    //           if (lsQuestion[listFirstQuest[i]].questionType ==
    //               KindOfQuestion.RadioCheckbox) {
    //             if (selectedAnswer[listFirstQuest[i]] != null)
    //               visibleQuestion[listFirstQuest[i]] = true;
    //           } else if (lsQuestion[listFirstQuest[i]].questionType ==
    //               KindOfQuestion.Checkbox) {
    //             for (int k = 0;
    //                 k < lsQuestion[listFirstQuest[i]].answer.length;
    //                 k++) {
    //               if (lsCheckbox[listFirstQuest[i]][k]) {
    //                 visibleQuestion[listFirstQuest[i]] = true;
    //               }
    //             }
    //           }
    //         }
    //         for (int i = 0; i < lsQuestion.length; i++) {
    //           if (lsQuestion[i].questionType == KindOfQuestion.RadioCheckbox) {
    //             for (int k = 0; k < lsQuestion[i].answer.length; k++) {
    //               if (selectedAnswer[i] != null) {
    //                 if (lsQuestion[i].answer.length > 0 &&
    //                     selectedAnswer[i].id == lsQuestion[i].answer[k].id &&
    //                     visibleQuestion[i] == true) {
    //                   for (int m = 0;
    //                       m < lsQuestion[i].answer[k].srSurveyQuestions.length;
    //                       m++) {
    //                     for (int t = 0; t < lsQuestion.length; t++) {
    //                       if (lsQuestion[i].answer[k].srSurveyQuestions[m].id ==
    //                           lsQuestion[t].id) {
    //                         visibleQuestion[t] = true;
    //                       }
    //                     }
    //                   }
    //                 }
    //               }
    //             }
    //           } else if (lsQuestion[i].questionType ==
    //               KindOfQuestion.Checkbox) {
    //             for (int k = 0; k < lsQuestion[i].answer.length; k++) {
    //               if (lsCheckbox[i][k] == true && visibleQuestion[i] == true) {
    //                 for (int t = 0; t < lsQuestion.length; t++) {
    //                   for (int m = 0;
    //                       m < lsQuestion[i].answer[k].srSurveyQuestions.length;
    //                       m++) {
    //                     if (lsQuestion[t].id ==
    //                         lsQuestion[i].answer[k].srSurveyQuestions[m].id) {
    //                       visibleQuestion[t] = true;
    //                     }
    //                   }
    //                 }
    //               }
    //             }
    //           }
    //         }
    //       });
    //     }
    //     enableAddCV = false;

    //     _getVillageUser(userSurveyId);
    //     _getListPicture(filename);

    //     //gmap

    //     //endgmap
    //   });
    // }
  }

  @override
  void dispose() {
    auth.dispose();
    // _mapController.dispose();
    super.dispose();
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
            constraints: BoxConstraints.expand(),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      helper.drawerMenu(),
                      // lsQuestion.length != 0
                      //     ? (Container(
                      //         child: Column(
                      //           children: <Widget>[
                      //             Padding(
                      //                 padding: const EdgeInsets.fromLTRB(
                      //                     20, 10, 20, 0),
                      //                 child: Column(
                      //                   children: displayImages(context),
                      //                 ))
                      //           ],
                      //         ),
                      //       ))
                      //     : Container(),
                      (Container(
                        child: Column(
                          children: <Widget>[
                            Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 10, 20, 0),
                                child: Column(
                                  children: displayImages(context),
                                ))
                          ],
                        ),
                      )), // Draw picture area
                      createInfoCV(), // Draw infoCV
                      gMap(), // Draw map
                      // lsQuestion.length != 0 ? createInfoCV() : Container(),
                      // lsQuestion.length != 0 ? gMap() : Container(),
                      Padding(
                          // padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              // Align( //Village info (Don't need)
                              //   alignment: lsQuestion.length != 0
                              //       ? Alignment.centerLeft
                              //       : Alignment.center,
                              //   child: Container(
                              //     child: Text(
                              //       lsQuestion.length != 0
                              //           ? LanguageConfig.getInputInfo()
                              //           : (surveyActiveID != null
                              //               ? LanguageConfig.getWaiting()
                              //               : LanguageConfig.getNotice()),
                              //       style: surveyActiveID != null
                              //           ? TextStyle(
                              //               fontSize: 23, color: Colors.black)
                              //           : (TextStyle(
                              //               fontSize: 23,
                              //               color: Colors.red,
                              //               fontWeight: FontWeight.bold)),
                              //     ),
                              //   ),
                              // ),
                              SizedBox(
                                  child: Padding(
                                padding:
                                    // const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                    const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: createRadioGroupListAnswer()),
                                //children: createShowAllQuest()),
                              )),
                            ],
                          )),
                      // lsQuestion.length != 0 // Draw dection box
                      //     ? Padding(
                      //         padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                      //         child: SizedBox(
                      //           width: _width / 3.5,
                      //           height: 52,
                      //           child: RaisedButton(
                      //             color: Colors.blue,
                      //             onPressed: () {
                      //               showNoticeSubmitAndSaveDraft(
                      //                   context, "completed");
                      //               _onSubmitClick("completed");
                      //             },
                      //             child: Text(LanguageConfig.getSubmit(),
                      //                 style: TextStyle(
                      //                     color: Colors.white, fontSize: 18)),
                      //             shape: RoundedRectangleBorder(
                      //                 borderRadius:
                      //                     BorderRadius.all(Radius.circular(6))),
                      //           ),
                      //         ),
                      //       )
                      //     : (surveyActiveID != null
                      //         ? Container()
                      //         : Text(LanguageConfig.getWaiting2())),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                        child: SizedBox(
                          width: _width / 2.5,
                          height: 52,
                          child: RaisedButton(
                            color: Colors.blue,
                            onPressed: () {
                              // showNoticeSubmitAndSaveDraft(
                              //     context, "completed");
                              _onSubmitClick("completed");
                            },
                            child: Text(LanguageConfig.getSubmit(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18)),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6))),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )),
        drawer: helper.drawer(),
        floatingActionButton: floatingButtonSaveDraft());
  }

  _getInfoUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
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

  _getLanguage() {
    lsLanguage.add(new LanguageApp(languageID: 1, languageName: "VIE"));
    lsLanguage.add(new LanguageApp(languageID: 2, languageName: "ENG"));
    selectedLanguage = lsLanguage[0];
  }

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

  _getVillage(int wardId) async {
    await addressBloc.fetchVillage(wardId, () {}, (msg) {
      LoadingDialog.hideLoadingDialog(context);
      MsgDialog.showMsgDialog(context, LanguageConfig.getNotice(), msg);
    }).then((value) {
      setState(() {
        lsVillage = value;
        lsVillage.forEach((village) {
          _addMarkers(village);
        });
      });
    });
  }

  _getVillageUser(int userSurveyId) async {
    return villageBloc.fetchVillageUserByID(userSurveyId, () {}, (msg) {
      LoadingDialog.hideLoadingDialog(context);
      MsgDialog.showMsgDialog(context, LanguageConfig.getNotice(), msg);
    }).then((value) {
      var imagePosition = value.coordinate.split(',');
      _latController.text = imagePosition[0];
      _longController.text = imagePosition[1];
      lsProvince.forEach((f) {
        if (f.provinceId == value.provinceId) {
          setState(() {
            selectedProvince = f;
          });
        }
      });
      addressBloc.fetchDistrict(selectedProvince.provinceId, () {}, (msg) {
        LoadingDialog.hideLoadingDialog(context);
        MsgDialog.showMsgDialog(context, LanguageConfig.getNotice(), msg);
      }).then((dis) {
        setState(() {
          lsDistrict = dis;
          lsDistrict.forEach((f) {
            if (f.districtId == value.districtId) {
              setState(() {
                selectedDistrict = f;
              });
            }
          });
          addressBloc.fetchWard(selectedDistrict.districtId, () {}, (msg) {
            LoadingDialog.hideLoadingDialog(context);
            MsgDialog.showMsgDialog(context, LanguageConfig.getNotice(), msg);
          }).then((wards) {
            setState(() {
              lsWard = wards;

              lsWard.forEach((f) {
                if (f.wardId == value.wardId) {
                  setState(() {
                    selectedWard = f;
                  });
                }
              });
              if (value.hasAdded == 0) {
                addressBloc.fetchVillage(selectedWard.wardId, () {}, (msg) {
                  LoadingDialog.hideLoadingDialog(context);
                  MsgDialog.showMsgDialog(
                      context, LanguageConfig.getNotice(), msg);
                }).then((vils) {
                  setState(() {
                    lsVillage = vils;
                    lsVillage.forEach((f) {
                      if (f.villageId == value.villageId) {
                        setState(() {
                          selectedVillage = f;
                          _infoCraftVillage.text = value.villageNote;
                        });
                      }
                    });
                  });
                });
              } else {
                selectTabVillage = 1;
                _addCraftVillage.text = value.villageName;
                _addInfoCraftVillage.text = value.villageNote;
              }
            });
          });
        });
      });
    });
  }

  _getListPicture(List<String> lsName) async {
    print("lsName ");
    lsName.forEach((element) {
      print(element);
    });

    return imageBloc.getListPicture(lsName, () {}, (err) {}).then((value) {
      if (value == null) {
        print("getListPicture null rồi");
      } else {
        print("getListPicture hết null rồi");
        base64Picture = value;

        ImageUploadModel imageUpload;
        for (int i = 0; i < base64Picture.length; i++) {
          if (base64Picture[i] != null) {
            print("base64Picture: " + base64Picture[i]);
            Uint8List bytes = base64.decode(base64Picture[i]);
            print(bytes.length);
            _createFileFromBytes(bytes, i, lsName).then((value) {
              File f = value;
              print(f.path);
              imageUpload = new ImageUploadModel();
              imageUpload.isUploaded = false;
              imageUpload.uploading = false;
              imageUpload.imageFile = value;
              imageUpload.imageUrl = '';
              images[i] = imageUpload;

              //images.replaceRange(i, i + 1, [imageUpload]);
            });
          }
        }
        setState(() {});
      }
    });
  }

  Future<File> _createFileFromBytes(bytes, index, lsName) async {
    print("byte nèk: " + bytes.length.toString());
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = File("$dir/" + lsName[index].toString());
    await file.writeAsBytes(bytes);
    return file;
  }

  deleteFile() async {
    final dir = (await getApplicationDocumentsDirectory()).path;
    Directory(dir).delete(recursive: true);
  }

  void countListQuest(List<Answer> lsAnswer) {
    if (lsAnswer.length != 0) {
      for (int i = 0; i < lsAnswer.length; i++) {
        if (lsAnswer[i].srSurveyQuestions.length != 0) {
          for (int j = 0; j < lsAnswer[i].srSurveyQuestions.length; j++) {
            countFatherQuest++;
            lsQuestion.add(lsAnswer[i].srSurveyQuestions[j]);
            if (lsAnswer[i].srSurveyQuestions[j].answer.length != 0) {
              countListQuest(lsAnswer[i].srSurveyQuestions[j].answer);
            }
          }
        }
      }
    }
  }

  void showListQuestAnswerUser(List<Answer> lsAnswer) {
    if (lsAnswer.length != 0) {
      for (int i = 0; i < lsAnswer.length; i++) {
        if (lsAnswer[i].srSurveyQuestions.length != 0) {
          for (int j = 0; j < lsAnswer[i].srSurveyQuestions.length; j++) {
            // lengthListQuest++;
            countFatherQuest++;
            lsQuestion.add(lsAnswer[i].srSurveyQuestions[j]);
            //  print("quest sau: " +
            //      lsAnswer[i].srSurveyQuestions[j].questionContent);
            if (lsAnswer[i].srSurveyQuestions[j].answer.length != 0) {
              showListQuestAnswerUser(lsAnswer[i].srSurveyQuestions[j].answer);
            }
          }
        }
      }
    }
  }

  List<Widget> createRadioGroupListAnswer() {
    List<Widget> widgets = new List<Widget>();
    List<Widget> villageInfo = new List<Widget>();
    List<Widget> polutionInfo = new List<Widget>();
    bool notExist = false;
    bool firstFlag = false;

    for (int i = 0; i < lsQuestion.length; i++) {
      notExist = false;
      for (int j = 0; j < listFirstQuest.length; j++) {
        if (listFirstQuest[j] == i) {
          notExist = true;
          if (j == listFirstQuest.length - 1) firstFlag = true;
          break;
        }
      }
      if (notExist == true) {
        visibleQuestion[i] = true;
        if (firstFlag)
          polutionInfo.add(createQuestionNotExist(i));
        else
          villageInfo.add(createQuestionNotExist(i));
      } else {
        if (firstFlag)
          polutionInfo.add(createQuestionExist(i));
        else
          villageInfo.add(createQuestionExist(i));
      }
    }

    //Village info (don't need)
    // surveyVillageInfo = Container(
    //   child: Visibility(
    //       visible: isDisplay,
    //       child: Padding(
    //         padding: const EdgeInsets.only(top: 5),
    //         child: Column(
    //             mainAxisAlignment: MainAxisAlignment.start,
    //             children: villageInfo),
    //       )),
    // );

    //Display village information
    // if ((typeUser == "HouseHold") && (typeUser == "Hộ gia đình")) {
    // widgets.add(Padding(
    //     padding: EdgeInsets.only(top: 10),
    //     child: Container(
    //       decoration: BoxDecoration(
    //         color: Colors.grey[100],
    //         borderRadius: BorderRadius.only(
    //             topLeft: Radius.circular(15),
    //             topRight: Radius.circular(15),
    //             bottomLeft: Radius.circular(15),
    //             bottomRight: Radius.circular(15)),
    //         boxShadow: [
    //           BoxShadow(
    //             color: Colors.grey.withOpacity(0.5),
    //             spreadRadius: 1,
    //             blurRadius: 2,
    //             offset: Offset(0, 3), // changes position of shadow
    //           )
    //         ],
    //       ),
    //       child: SizedBox(
    //         width: double.infinity,
    //         child: TextButton(
    //           style: TextButton.styleFrom(
    //             textStyle: const TextStyle(fontSize: 20),
    //           ),
    //           onPressed: () {
    //             setState(() {
    //               if (isDisplay)
    //                 isDisplay = false;
    //               else
    //                 isDisplay = true;
    //             });
    //           },
    //           child: Row(
    //             mainAxisAlignment: MainAxisAlignment.spaceAround,
    //             children: <Widget>[
    //               Align(
    //                   alignment: lsQuestion.length != 0
    //                       ? Alignment.centerLeft
    //                       : Alignment.center,
    //                   child: Container(
    //                     child: Text(
    //                       lsQuestion.length != 0
    //                           ? LanguageConfig.getInputInfo()
    //                           : (surveyActiveID != null
    //                               ? LanguageConfig.getWaiting()
    //                               : LanguageConfig.getNotice()),
    //                       style: surveyActiveID != null
    //                           ? TextStyle(fontSize: 20, color: Colors.black)
    //                           : (TextStyle(
    //                               fontSize: 20,
    //                               color: Colors.red,
    //                               fontWeight: FontWeight.bold)),
    //                     ),
    //                   )),
    //               Icon(
    //                 isDisplay ? Icons.arrow_drop_up : Icons.arrow_drop_down,
    //                 color: Colors.green,
    //                 size: 30.0,
    //               )
    //             ],
    //           ),
    //         ),
    //       ),
    //     )));
    // }

    // widgets.add(surveyVillageInfo);
    polutionInfo.add(createPollutionQuestion());
    widgets..addAll(polutionInfo);

    checkLoadingData = true;
    checkIconLoading = false;

    return widgets;
  }

  Padding createPollutionQuestion() {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ]),
            child: Visibility(
                visible: true,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 10, top: 10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          child: Text(
                            "Thông tin ô nhiễm:",
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: GestureDetector(
                            onLongPress: () {},
                            child: Container(
                                child: Column(children: [
                              CheckboxListTileCustom(
                                title: Text("Ô nhiễm không khí"),
                                value: _checkedAirPollution,
                                onChanged: (bool value) {
                                  setState(() {
                                    _checkedAirPollution = value;
                                  });
                                },
                              ),
                              CheckboxListTileCustom(
                                title: Text("Ô nhiễm chất thải rắn"),
                                value: _checkedSoilPollution,
                                onChanged: (bool value) {
                                  setState(() {
                                    _checkedSoilPollution = value;
                                  });
                                },
                              ),
                              CheckboxListTileCustom(
                                title: Text("Ô nhiễm nước thải"),
                                value: _checkedWaterPollution,
                                onChanged: (bool value) {
                                  setState(() {
                                    _checkedWaterPollution = value;
                                  });
                                },
                              ),
                            ])))),
                  ],
                )),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ]),
            child: Visibility(
                visible: true,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 10, top: 10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          child: Text(
                            "Thông tin liên quan:",
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Container(
                        width: double.infinity,
                        child: TextField(
                          controller: _additionalInfo,
                          style: TextStyle(color: Colors.black, fontSize: 18),
                          maxLines: 3,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              labelText: "Thông tin liên qua về ô nhiễm",
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
          ),
        ],
      ),
    );
  }

  Padding createQuestionExist(int i) {
    return Padding(
      padding: EdgeInsets.only(top: visibleQuestion[i] ? 10 : 0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15)),
            boxShadow: visibleQuestion[i]
                ? ([
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ])
                : null),
        child: Visibility(
            visible: visibleQuestion[i],
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: Text(
                        lsQuestion[i].questionContent,
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: GestureDetector(
                        onLongPress: () {},
                        child: Container(
                            child: Column(
                          children: createAnswer(
                              lsQuestion[i].answer, i, lsQuestion[i]),
                        ))))
              ],
            )),
      ),
    );
  }

  Padding createQuestionNotExist(int i) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      child: Text(
                        lsQuestion[i].questionContent,
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: GestureDetector(
                        onLongPress: () {},
                        child: Container(
                            child: Column(
                          children: createAnswer(
                              lsQuestion[i].answer, i, lsQuestion[i]),
                        ))))
              ],
            )),
      ),
    );
  }

  List<Widget> createAnswer(
      List<Answer> lsAnswer, int indexQuestion, Question question) {
    List<Widget> widgets = new List<Widget>();
    isAnother = false;
    if (question.questionType == KindOfQuestion.RadioCheckbox) {
      Color colorAnswer = Colors.white;
      for (int i = 0; i < lsAnswer.length; i++) {
        widgets.add(createRadioCheckbox(lsAnswer, i, indexQuestion));
        if (lsAnswer[i].answerType == KindOfAnswer.Other) isAnother = true;
      }
      if (isAnother) {
        widgets.add(createAnotherAnswer(indexQuestion));
      }
    } else if (question.questionType == KindOfQuestion.TextField) {
      widgets.add(createTextField(indexQuestion, question));
    } else if (question.questionType == KindOfQuestion.TextFieldNumber) {
      widgets.add(createTextFieldNumber(indexQuestion, question));
    } else if (question.questionType == KindOfQuestion.Checkbox) {
      for (int i = 0; i < lsAnswer?.length; i++) {
        widgets.add(createCheckbox(lsAnswer, i, indexQuestion));
        if (lsAnswer[i].answerType == KindOfAnswer.Other) isAnother = true;
      }
      if (isAnother) {
        widgets.add(
            //   Padding(
            //   padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
            //   child: Visibility(
            //     visible: visibleAnother[indexQuestion],
            //     child: TextField(
            //       controller: _listController[indexQuestion],
            //       style: TextStyle(color: Colors.black, fontSize: 18),
            //       maxLines: 3,
            //       keyboardType: TextInputType.multiline,
            //       decoration: InputDecoration(
            //           labelText: "Vui lòng nhập thêm thông tin",
            //           border: OutlineInputBorder(
            //               borderSide:
            //                   BorderSide(color: Color(0xffCED002), width: 1),
            //               borderRadius: BorderRadius.all(Radius.circular(6)))),
            //     ),
            //   ),
            // )
            createAnotherAnswer(indexQuestion));
      }
    }

    return widgets;
  }

  Padding createAnotherAnswer(int indexQuestion) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
      child: Visibility(
        visible: visibleAnother[indexQuestion],
        child: TextField(
          controller: _listController[indexQuestion],
          style: TextStyle(color: Colors.black, fontSize: 18),
          maxLines: 3,
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
              labelText: LanguageConfig.getAddMoreInfo(),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffCED002), width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(6)))),
        ),
      ),
    );
  }

  Container createRadioCheckbox(
      List<Answer> lsAnswer, int i, int indexQuestion) {
    return Container(
      child: RadioListTile(
        dense: false,
        activeColor: Colors.blue,
        value: lsAnswer[i],
        groupValue: selectedAnswer[indexQuestion],
        title: Text(lsAnswer[i].answerContent),
        onChanged: (currentAnswer) {
          setState(() {
            //không hoàn thành survey
            nullValue = false;
            selectedAnswer[indexQuestion] = currentAnswer;

            //thêm đáp án
            toltalUserAnswerQuestion++;
            print(toltalUserAnswerQuestion);
            if (currentAnswer.srSurveyQuestions.length != 0) {
              for (int t = 0; t < currentAnswer.srSurveyQuestions.length; t++) {
                for (int k = 0; k < lsQuestion.length; k++) {
                  if (currentAnswer.srSurveyQuestions[t].id ==
                      lsQuestion[k].id) {
                    visibleQuestion[k] = true;
                  }
                }
              }
            } else {
              for (int z = 0; z < listFirstQuest.length; z++) {
                if (listFirstQuest[z] == indexQuestion) {
                  for (int k = listFirstQuest[z];
                      k < listFirstQuest[z + 1];
                      k++) {
                    visibleQuestion[k] = false;
                  }
                } else {
                  for (int k = 0;
                      k < lsQuestion[indexQuestion].answer.length;
                      k++) {
                    if (k != i) {
                      for (int m = 0;
                          m <
                              lsQuestion[indexQuestion]
                                  .answer[k]
                                  .srSurveyQuestions
                                  .length;
                          m++) {
                        for (int p = 0; p < lsQuestion.length; p++) {
                          if (lsQuestion[indexQuestion]
                                  .answer[k]
                                  .srSurveyQuestions[m]
                                  .id ==
                              lsQuestion[p].id) {
                            visibleQuestion[p] = false;
                          }
                        }
                      }
                    }
                  }
                }
              }
            }

            print(currentAnswer);
            lsAnswer[i].answerType == KindOfAnswer.Other
                ? visibleAnother[indexQuestion] = true
                : visibleAnother[indexQuestion] = false;
            //setSelectedAnswer(currentAnswer);

            print(lsAnswer[i].srSurveyQuestions.length);
            //kiểm tra xem có question ở answer hay không
            if (lsAnswer[i].srSurveyQuestions.length != 0) {
              listVisbileQuestion[indexQuestion] = true;
            } else {
              listVisbileQuestion[indexQuestion] = false;
            }
          });
        },
        selected: selectedAnswer[indexQuestion] == lsAnswer[i],
      ),
    );
  }

  Padding createTextField(int indexQuestion, Question question) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: TextField(
        controller: _listController[indexQuestion],
        obscureText: false, // format mật khẩu thành dấu *
        style: TextStyle(color: Colors.black, fontSize: 18),
        onChanged: (value) {
          if (value != "" || value != null || value.trim() != "")
            toltalUserAnswerQuestion++;
        },
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            //  hintText: ,
            isDense: true,
            contentPadding: EdgeInsets.all(12),
            labelText: question.questionLabel,
            labelStyle: TextStyle(color: Colors.grey),
            border: OutlineInputBorder()),
      ),
    );
  }

  GestureDetector createCheckbox(
      List<Answer> lsAnswer, int i, int indexQuestion) {
    CheckboxListTileCustom checkBox = CheckboxListTileCustom(
      title: Text(lsAnswer[i].answerContent),
      value: lsCheckbox[indexQuestion][i],
      onChanged: (bool value) {
        setState(() {
          print("Index Question: " +
              indexQuestion.toString() +
              "-" +
              i.toString());
          nullValue = false;

          //kiểm tra có check hết không
          bool isCheckAll = false;
          for (int z = 0; z < lsCheckbox[indexQuestion].length; z++) {
            if (!lsCheckbox[indexQuestion][z]) isCheckAll = true;
          }
          if (!isCheckAll) {
            toltalUserAnswerQuestion++;
          }

          if (lsAnswer[i].srSurveyQuestions.length != 0 &&
              lsCheckbox[indexQuestion][i] == false) {
            for (int t = 0; t < lsAnswer[i].srSurveyQuestions.length; t++) {
              for (int k = 0; k < lsQuestion.length; k++) {
                if (lsAnswer[i].srSurveyQuestions[t].id == lsQuestion[k].id) {
                  visibleQuestion[k] = true;
                }
              }
            }
          } else if (lsAnswer[i].srSurveyQuestions.length != 0 &&
              lsCheckbox[indexQuestion][i] == true) {
            bool isFirstQuest = false;
            int indexListFirstQuest;
            for (int z = 0; z < listFirstQuest.length; z++) {
              if (listFirstQuest[z] == indexQuestion) {
                isFirstQuest = true;
                indexListFirstQuest = z;
                break;
              }
            }
            if (isFirstQuest) {
              int beginIndex, endIndex;
              for (int k = indexQuestion; k < lsQuestion.length; k++) {
                if (lsQuestion[k].id == lsAnswer[i].srSurveyQuestions[0].id) {
                  beginIndex = k;
                  break;
                }
              }

              if (i < lsQuestion[indexQuestion].answer.length - 1) {
                for (int k = indexQuestion; k < lsQuestion.length; k++) {
                  endIndex = k;
                  if (lsQuestion[k].id ==
                      lsAnswer[i + 1].srSurveyQuestions[0].id) {
                    break;
                  }
                }
              } else {
                for (int k = indexQuestion; k < lsQuestion.length; k++) {
                  endIndex = k;
                  if (i != lsQuestion[indexQuestion].answer.length - 1) {
                    if (lsQuestion[k].id ==
                        lsQuestion[listFirstQuest[indexQuestion] + 1].id) {
                      break;
                    }
                  }
                }
              }
              print("endindex nè $endIndex");
              print(lsQuestion[endIndex].questionContent);
              for (int k = beginIndex; k <= endIndex; k++) {
                visibleQuestion[k] = false;
              }
            } else {
              int beginIndex, endIndex;
              for (int k = indexQuestion; k < lsQuestion.length; k++) {
                if (lsQuestion[k].id == lsAnswer[i].srSurveyQuestions[0].id) {
                  beginIndex = k;
                  break;
                }
              }
              print("begin ${lsQuestion[beginIndex].questionContent} ");
              if (i < lsQuestion[indexQuestion].answer.length - 1) {
                for (int k = indexQuestion; k < lsQuestion.length; k++) {
                  endIndex = k;
                  if (lsQuestion[k].id ==
                      lsAnswer[i + 1].srSurveyQuestions[0].id) {
                    break;
                  }
                }
              } else {
                for (int k = indexQuestion; k < lsQuestion.length; k++) {
                  endIndex = k;
                  if (i < lsQuestion[indexQuestion].answer.length - 1) {
                    print("object0");
                    if (lsQuestion[k].id ==
                        lsQuestion[lsAnswer[i].srSurveyQuestions.length + 1]
                            .id) {
                      print("object");
                      break;
                    }
                  } else {
                    if (indexQuestion < lsQuestion.length - 1) {
                      print(
                          "${lsQuestion[k].id}  a : ${lsQuestion[indexQuestion + 1].id}");
                      if (lsQuestion[k].id ==
                          lsQuestion[beginIndex +
                                  lsAnswer[i].srSurveyQuestions.length]
                              .id) {
                        break;
                      }
                    } else {
                      if (lsQuestion[k].id ==
                          lsQuestion[listFirstQuest[indexQuestion] + 1].id) {
                        print("object2");
                        break;
                      }
                    }
                  }
                }
              }
              print("end nè ${lsQuestion[beginIndex].questionContent} ");
              for (int k = beginIndex; k < endIndex; k++) {
                visibleQuestion[k] = false;
              }
            }
          }

          lsCheckbox[indexQuestion][i] =
              value; //nếu mà click thì hắn sẽ đổi theo giá trị value, ví dụ đang false thì tại vị trí đó là true

          if (lsAnswer[i].answerType == KindOfAnswer.Other &&
              lsCheckbox[indexQuestion][i] == false) {
            visibleAnother[indexQuestion] = false;
          } else if (lsAnswer[i].answerType == KindOfAnswer.Other)
            visibleAnother[indexQuestion] = true;
        });
      },
    );

    // Map<String, Widget> tmp = {lsAnswer[i].answerContent : checkBox};
    listCheckboxWidget[lsAnswer[i].answerContent] = checkBox;
    // listCheckboxWidget["listCheckbox"] = tmp;
    // listCheckboxWidget["listCheckbox"][lsAnswer[i].answerContent] = checkBox;

    return GestureDetector(
      onLongPress: () {
        print("on long press");
        setState(() {});
      },
      child: Container(
        child: checkBox,
      ),
    );
  }

  Padding createTextFieldNumber(int indexQuestion, Question question) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: TextField(
        keyboardType: TextInputType.number,
        controller: _listController[indexQuestion],
        obscureText: false, // format mật khẩu thành dấu *
        onChanged: (value) {
          if (value != "" || value != null || value.trim() != "")
            toltalUserAnswerQuestion++;
        },
        style: TextStyle(color: Colors.black, fontSize: 18),
        decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            labelText: question.questionLabel,
            isDense: true,
            contentPadding: EdgeInsets.all(12),
            labelStyle: TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xffCED002), width: 1),
                borderRadius: BorderRadius.all(Radius.circular(6)))),
      ),
    );
  }

  Widget floatingButtonSaveDraft() {
    if (lsQuestion.length != 0) {
      return FloatingActionButton.extended(
        onPressed: () {
          showNoticeSubmitAndSaveDraft(context, "inprogress");
          _onSubmitClick("inprogress");
        },
        label: Text(LanguageConfig.getSaveDraft()),
        //icon: Icon(Icons.save),
        backgroundColor: Colors.pink,
      );
    } else {
      return Container();
    }
  }

  _onSubmitClick(String typeSubmit) async {
    print("type tab selection: $selectTabVillage");
    lsAnswerUser = [];
    bool notComplete = false;
    toltalUserAnswerQuestion = 0;
    for (int i = 0; i < listFirstQuest.length; i++) {
      if (lsQuestion[listFirstQuest[i]].questionType ==
          KindOfQuestion.RadioCheckbox) {
        if (selectedAnswer[listFirstQuest[i]] != null) {
          toltalUserAnswerQuestion++;
        }
      } else if (lsQuestion[listFirstQuest[i]].questionType ==
          KindOfQuestion.Checkbox) {
        bool check = false;
        for (int k = 0; k < lsQuestion[listFirstQuest[i]].answer.length; k++) {
          if (lsCheckbox[listFirstQuest[i]][k]) {
            check = true;
            break;
          }
        }
        if (check) {
          toltalUserAnswerQuestion++;
        }
      } else {
        if (_listController[listFirstQuest[i]].text != "" &&
            _listController[listFirstQuest[i]].text != null) {
          toltalUserAnswerQuestion++;
        }
      }
    }
    print(
        "totalQuest: $totalQuestion , totalAnswer: $toltalUserAnswerQuestion");
    for (int i = 0; i < lsQuestion.length; i++) {
      if (lsQuestion[i].questionType == KindOfQuestion.RadioCheckbox) {
        if (selectedAnswer[i] == null)
          notComplete = true;
        else {
          List<String> lsAnswerRadioCB = new List<String>();

          lsAnswerRadioCB.add(selectedAnswer[i].id.toString());
          lsAnswerUser.add(new AnswerUser(
              activeID: surveyActiveID != null
                  ? surveyActiveID
                  : surveyStatus.activeID,
              // userSurveyID: survey.id,
              questionID: lsQuestion[i].id,
              answerContent: lsAnswerRadioCB,
              answerOtherContent: _listController[i].text));
        }
      } else if (lsQuestion[i].questionType == KindOfQuestion.Checkbox) {
        List<String> lsAnswerRadioCB = [];
        bool checkComplete = false;
        for (int j = 0; j < lsQuestion[i].answer.length; j++) {
          if (lsCheckbox[i][j]) {
            checkComplete = true;
            // notComplete = true;
            lsAnswerRadioCB.add(lsQuestion[i].answer[j].id.toString());
          }
        }
        if (!checkComplete) notComplete = true;
        lsAnswerUser.add(new AnswerUser(
            activeID:
                surveyActiveID != null ? surveyActiveID : surveyStatus.activeID,
            questionID: lsQuestion[i].id,
            answerContent: lsAnswerRadioCB,
            answerOtherContent: _listController[i].text));
      } else if (lsQuestion[i].questionType == KindOfQuestion.TextField) {
        List<String> lsAnswerTF = [];
        lsAnswerTF.add(_listController[i].text);
        lsAnswerUser.add(new AnswerUser(
            activeID:
                surveyActiveID != null ? surveyActiveID : surveyStatus.activeID,
            questionID: lsQuestion[i].id,
            answerContent: lsAnswerTF));
      } else if (lsQuestion[i].questionType == KindOfQuestion.TextFieldNumber) {
        List<String> lsAnswerTF = [];
        lsAnswerTF.add(_listController[i].text);
        lsAnswerUser.add(new AnswerUser(
            activeID:
                surveyActiveID != null ? surveyActiveID : surveyStatus.activeID,
            questionID: lsQuestion[i].id,
            answerContent: lsAnswerTF));
      }
    }

    int totalImage = 0;
    if (images[0] is ImageUploadModel) totalImage++;
    // if (images[1] is ImageUploadModel) totalImage++;
    // if (images[2] is ImageUploadModel) totalImage++;
    totalQuestion = listFirstQuest.length;
    print("lat: ${_latController.text}");
    print("long: ${_longController.text}");

    String coord = "${_latController.text},${_longController.text}";
    print(coord);

    Village newVillage = new Village(
        villageName: _addCraftVillage.text,
        note: _addInfoCraftVillage.text,
        coordinate: coord);

    //Validate form
    if ((selectedVillage == null && newVillage == null) ||
        (_longController.text == '') ||
        (_latController.text == '') ||
        (base64Img == null)) {
      MsgDialog.showMsgDialog(context, "Lỗi", "Không thể gửi đi!");
      return;
    }

    if (selectedVillage != null || newVillage != null) {
      lsVil = [];
      LoadingDialog.showLoadingDialog(context, LanguageConfig.getProcessing());

      String result = "";

      if (_checkedSoilPollution)
        result = result + "1";
      else
        result = result + "0";

      if (_checkedAirPollution)
        result = result + "1";
      else
        result = result + "0";

      if (_checkedWaterPollution)
        result = result + "1";
      else
        result = result + "0";

      print("Loai O nhiem: " + result);

      if (selectTabVillage != 0) {
        await villageBloc
            .createNewVillage(selectedWard.wardId.toString(), newVillage)
            .then((value) {
          print("Value: " + value.toString());
          if (value != null) {
            print("Village Id after add: " + value.toString());
            newVillage.villageId = value;
          }
        });
      }

      villageBloc.submitVillage(
          selectTabVillage == 0
              ? selectedVillage.villageId.toString()
              : newVillage.villageId.toString(),
          _longController.text,
          _latController.text,
          base64Img,
          result,
          _additionalInfo.text, (msg) {
        LoadingDialog.hideLoadingDialog(context);
        MsgDialog.showMsgDialogAndPushToScreenPage(
            context, LanguageConfig.getSubmit(), msg);
      }, (msg) {
        LoadingDialog.hideLoadingDialog(context);
        MsgDialog.showMsgDialog(context, LanguageConfig.getSubmit(), msg);
      });

      // villageBloc.submitVillage(
      //     selectedVillage.villageId.toString(),
      //     _longController.text,
      //     _latController.text,
      //     base64Img,
      //     result,
      //     _additionalInfo.text, (msg) {
      //   LoadingDialog.hideLoadingDialog(context);
      //   // MsgDialog.showMsgDialog(context, LanguageConfig.getSubmit(), msg);
      //   MsgDialog.showMsgDialogAndPushToScreenPage(
      //       context, LanguageConfig.getSubmit(), msg);
      // }, (msg) {
      //   LoadingDialog.hideLoadingDialog(context);
      //   MsgDialog.showMsgDialog(context, LanguageConfig.getSubmit(), msg);
      // });

      // if (surveyActiveID != null) {
      //   print("totalImage: $totalImage");
      //   uploadAllImage().then((vl) {
      //     villageBloc.submitVillage(
      //         selectTabVillage == 0
      //             ? selectedVillage
      //             : addIDToVillage(selectedWard.wardId.toString(), newVillage),
      //         surveyActiveID != null
      //             ? surveyActiveID.toString()
      //             : surveyStatus.activeID.toString(),
      //         totalQuestion.toString(),
      //         toltalUserAnswerQuestion.toString(),
      //         totalImage.toString(),
      //         selectTabVillage.toString(),
      //         selectedWard.wardId.toString(), () {
      //       answerBloc.submitAnswerUser(lsAnswerUser,
      //           surveyActiveID != null ? surveyActiveID : surveyStatus.activeID,
      //           () {
      //         LoadingDialog.hideLoadingDialog(context);
      //         MsgDialog.showMsgDialogAndPushToScreenPage(
      //             context,
      //             LanguageConfig.getNotice(),
      //             typeSubmit == "completed"
      //                 ? LanguageConfig.getCompletedInfo()
      //                 : LanguageConfig.getSaveDraftInfo());
      //       }, (msg) {
      //         LoadingDialog.hideLoadingDialog(context);
      //         MsgDialog.showMsgDialog(context, LanguageConfig.getSubmit(), msg);
      //       }, typeSubmit);
      //     }, (msg) {
      //       LoadingDialog.hideLoadingDialog(context);
      //       MsgDialog.showMsgDialog(context, LanguageConfig.getSubmit(), msg);
      //     });
      //   });
      // } else {
      // uploadAllImage().then((vl) {
      //   villageBloc.submitVillage(
      //       selectTabVillage == 0
      //           ? selectedVillage
      //           : addIDToVillage(selectedWard.wardId.toString(), newVillage),
      //       surveyActiveID != null
      //           ? surveyActiveID.toString()
      //           : surveyStatus.activeID.toString(),
      //       totalQuestion.toString(),
      //       toltalUserAnswerQuestion.toString(),
      //       totalImage.toString(),
      //       selectTabVillage.toString(),
      //       selectedWard.wardId.toString(), () {
      //     answerBloc.submitAnswerUser(lsAnswerUser,
      //         surveyActiveID != null ? surveyActiveID : surveyStatus.activeID,
      //         () {
      //       LoadingDialog.hideLoadingDialog(context);
      //       MsgDialog.showMsgDialogAndPushToScreenPage(
      //           context,
      //           LanguageConfig.getNotice(),
      //           typeSubmit == "completed"
      //               ? LanguageConfig.getCompletedInfo()
      //               : LanguageConfig.getSaveDraftInfo());
      //     }, (msg) {
      //       LoadingDialog.hideLoadingDialog(context);
      //       MsgDialog.showMsgDialog(context, LanguageConfig.getSubmit(), msg);
      //     }, typeSubmit);
      //   }, (msg) {
      //     LoadingDialog.hideLoadingDialog(context);
      //     MsgDialog.showMsgDialog(context, LanguageConfig.getSubmit(), msg);
      //   });
      // });
      // }
    } else {
      MsgDialog.showMsgDialog(context, LanguageConfig.getNotice(),
          LanguageConfig.getWarningSubmit());
    }
  }

  Future<bool> uploadAllImage() async {
    for (int m = 0; m < 1; m++) {
      if (images[m] is ImageUploadModel) {
        await imageBloc.upLoadFileImage(
            (images[m] as ImageUploadModel).imageFile, () {}, (msg) {
          LoadingDialog.hideLoadingDialog(context);
          MsgDialog.showMsgDialog(context, LanguageConfig.getNotice(), msg);
        });
      }
    }
  }

  List<Widget> displayImages(BuildContext context) {
    List<Widget> widgets = new List<Widget>();
    widgets.add(Container(
      alignment: Alignment.centerLeft,
      child: Text(LanguageConfig.getSuggestion(),
          textAlign: TextAlign.left,
          style: TextStyle(
            color: Colors.redAccent,
            fontSize: 11,
          )),
    ));

    widgets.add(
      Padding(
        padding: const EdgeInsets.only(left: 5, top: 10),
        child: Container(
          alignment: Alignment.centerLeft,
          child: Text(
            LanguageConfig.getCurrentGroup(typeUser),
          ),
        ),
      ),
    );
    widgets.add(Container(width: _width / 2, child: buildGridView(context)));
    return widgets;
  }

  Widget createInfoCV() {
    Widget wg = Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                child: Text(
                  LanguageConfig.getGeneralInfo(),
                  style: TextStyle(fontSize: 20, color: Colors.red),
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
                child: DropdownButton<Province>(
                  underline: SizedBox(),
                  hint: Text("   " + LanguageConfig.getPickProvince()),
                  isExpanded: true,
                  value: selectedProvince,
                  onChanged: (Province province) {
                    setState(() {
                      print("Value province: " + province.provinceName);
                      selectedProvince = province;
                      //set quận/huyện
                      _getDistrict(selectedProvince.provinceId);
                      polygonPickProvince.polygonPick = new Set();
                      polygonPickDistrict.polygonPick = new Set();

                      parseJsonFromProvinces(
                              selectedProvince.provinceId.toString())
                          .then((_) {
                        LatLngBounds bounds =
                            boundsFromLatLngList(polygonPickProvince.lsLatlng);
                        _mapController.animateCamera(
                            CameraUpdate.newLatLngBounds(bounds, 0));
                        // _mapController.animateCamera(CameraUpdate.newLatLngZoom(
                        //     LatLng(polygonPickProvince.lat,
                        //         polygonPickProvince.long),
                        //     polygonPickProvince.zoom));
                      });

                      selectedDistrict = null;
                      lsDistrict = [];
                      lsWard = [];
                      selectedWard = null;
                      selectedVillage = null;
                      lsVillage = [];
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
                      polygonPickDistrict.polygonPick = new Set();
                      parseJsonFromDistricts(
                              selectedDistrict.districtId.toString())
                          .then((_) {
                        polygonSetDefaultGmap
                            .addAll(polygonPickDistrict.polygonPick);
                        setState(() {});
                        LatLngBounds bounds =
                            boundsFromLatLngList(polygonPickDistrict.lsLatlng);
                        _mapController.animateCamera(
                            CameraUpdate.newLatLngBounds(bounds, 0));
                        // _mapController.animateCamera(CameraUpdate.newLatLngZoom(
                        //     LatLng(polygonPickDistrict.lat,
                        //         polygonPickDistrict.long),
                        //     polygonPickDistrict.zoom));
                        // polygonSetDefaultGmap2
                        //     .addAll(polygonPickDistrict.polygonPick);
                      });
                      _getWard(selectedDistrict.districtId);
                      selectedWard = null;
                      lsWard = [];
                      selectedVillage = null;
                      lsVillage = [];
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
                      _getVillage(value.wardId);
                      selectedWard = value;
                      selectedVillage = null;
                      lsVillage = [];
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
                height: _infoCraftVillage.text.trim() == ""
                    ? _height / 3
                    : _height / 2.7,
                decoration: BoxDecoration(
                  border: Border.all(width: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: _tabSection(context),
                ),
              ),
            )
          ],
        ));

    return wg;
  }

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
                        child: DropdownButton<Village>(
                          underline: SizedBox(),
                          hint: Text(LanguageConfig.getPickVillage()),
                          isExpanded: true,
                          value: selectedVillage,
                          onChanged: (Village value) {
                            // villageBloc.checkExistVillage(
                            //     value.villageId, () {}, (msg) {
                            //   LoadingDialog.hideLoadingDialog(context);
                            //   MsgDialog.showMsgDialog(
                            //       context, LanguageConfig.getNotice(), msg);
                            // }).then((result) {
                            //   if (result) {
                            //     setState(() {
                            //       selectedVillage = value;
                            //       List<String> splitLatLong =
                            //           selectedVillage.coordinate.split(",");
                            //       lat = double.parse(splitLatLong[0]);
                            //       long = double.parse(splitLatLong[1]);
                            //       _infoCraftVillage.text = selectedVillage.note;

                            //       //marker
                            //       var markerIdVal =
                            //           selectedVillage.villageId.toString();
                            //       final MarkerId markerId =
                            //           MarkerId(markerIdVal);
                            //       _onMarkerTapped(markerId);

                            //       //Set nearby villages makers
                            //       setNearbyVillagesMaker();
                            //     });
                            //   } else {
                            //     MsgDialog.showMsgDialog(
                            //         context,
                            //         LanguageConfig.getNotice(),
                            //         LanguageConfig.getInvestigated());
                            //   }
                            // });
                            setState(() {
                              selectedVillage = value;
                              List<String> splitLatLong =
                                  selectedVillage.coordinate.split(",");
                              lat = double.parse(splitLatLong[0]);
                              long = double.parse(splitLatLong[1]);
                              _infoCraftVillage.text = selectedVillage.note;

                              //marker
                              var markerIdVal =
                                  selectedVillage.villageId.toString();
                              final MarkerId markerId = MarkerId(markerIdVal);
                              _onMarkerTapped(markerId);

                              //Set nearby villages makers
                              setNearbyVillagesMaker();
                            });
                          },
                          items: lsVillage.map((Village village) {
                            return DropdownMenuItem<Village>(
                              value: village,
                              child: Row(
                                children: <Widget>[
                                  SizedBox(
                                    width: 10,
                                  ),
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
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
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
                        maxLines: 3,
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

  Widget createMap() {
    return Container();
  }

  // chooseImage() {
  //   setState(() {
  //     file = ImagePicker.pickImage(source: ImageSource.gallery);
  //   });
  // }

  Future<void> _showDialogPhoto(BuildContext context, int index) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(LanguageConfig.getOption()),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  RaisedButton.icon(
                      onPressed: () {
                        //Take Photo here
                        _onTakePhotoImageClick(index, context);
                      },
                      icon: Icon(Icons.add_a_photo),
                      label: Text(LanguageConfig.getTakePhoto())),
                  // RaisedButton.icon(
                  //     onPressed: () {
                  //       _onAddImageClick(index, context);
                  //     },
                  //     icon: Icon(Icons.add_photo_alternate),
                  //     label: Text("Thư viện")),
                ],
              ),
            ),
          );
        });
  }

  Widget buildGridView(BuildContext context) {
    return Center(
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 1,
        childAspectRatio: 1,
        children: List.generate(images.length, (index) {
          if (images[index] is ImageUploadModel) {
            ImageUploadModel uploadModel = images[index];
            return Card(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                children: <Widget>[
                  Center(
                    child: Image.file(
                      uploadModel.imageFile,
                      // width: 300,
                      // height: 400,
                    ),
                  ),
                  Positioned(
                    right: 5,
                    top: 5,
                    child: InkWell(
                      child: Icon(
                        Icons.remove_circle,
                        size: 20,
                        color: Colors.red,
                      ),
                      onTap: () {
                        showNoticeDeletePicture(context, index);
                      },
                    ),
                  ),
                ],
              ),
            );
          } else {
            if (_imageFile == null) _onTakePhotoImageClick(index, context);
            return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 3,
                child: IconButton(
                  // icon: Icon(Icons.add),
                  icon: Icon(
                    Icons.add_a_photo,
                    size: 60,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    // _onTakePhotoImageClick(index, context);
                    // _showDialogPhoto(context, index);
                    _onTakePhotoImageClick(index, context);
                  },
                ));
          }
        }),
      ),
    );
  }

  Future _onAddImageClick(int index, BuildContext context) async {
    _imageFile.then((image) async {
      var bytes = await image.readAsBytes();
      var tags = await readExifFromBytes(bytes);

      Map<String, String> mTags = HashMap();
      try {
        // mTags.addAll(exifToGPS(tags));
        Map<String, IfdTag> imgTags =
            await readExifFromBytes(File(image.path).readAsBytesSync());
      } catch (e) {
        print("noexif");
        Navigator.of(context).pop();
        MsgDialog.showMsgDialog(context, LanguageConfig.getNotice(),
            LanguageConfig.getSuggestPositionNotice());
      } finally {
        print(tags.length);
        if (tags.length > 0) {
          if (tags["GPS GPSLongitude"] != null) {
            tags.forEach((key, value) {
              print({"$key": "$value"});
              mTags.addAll({"$key": "$value"});
            });
            Navigator.of(context).pop();
            setState(() {
              getFileImage(index, "select");
            });
          }
        }
      }
    });
  }

  void getFileImage(int index, String type) async {
    _imageFile.then((file) async {
      if (file == null) {
        print("empty");
      } else {
        ImageUploadModel imageUpload = new ImageUploadModel();
        imageUpload.isUploaded = false;
        imageUpload.uploading = false;
        imageUpload.imageFile = File(file.path);
        imageUpload.imageUrl = '';
        images.replaceRange(index, index + 1, [imageUpload]);
        setState(() {});
        //dùng để lấy dữ liệu sau khi gửi ảnh
        //showNoticeConfirmGetDataFromImage(context, file);
      }
    }).catchError((error) {
      print("trống");
      return;
    });
  }

  showNoticeConfirmGetDataFromImage(BuildContext context, File file) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text(LanguageConfig.getCancel()),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text(LanguageConfig.getContinue()),
      onPressed: () {
        //getDataFromImage(file);

        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(LanguageConfig.getNotice()),
      content: Text(LanguageConfig.getSuggestionVillage()),
      actions: [
        cancelButton,
        continueButton,
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

  getDataFromImage(File file) async {
    return answerBloc
        .uploadImageGetInfoVillageAndAnswer(file, () {}, (msg) {})
        .then((answerUserVillage) {
      setState(() {
        List<AnswerUser> lsAnswerUserTemp = answerUserVillage.answerUser;
        for (int i = 0; i < lgnQuestion; i++) {
          for (int j = 0; j < lsAnswerUserTemp.length; j++) {
            if (lsQuestion[i].id == lsAnswerUserTemp[j].questionID) {
              if (lsQuestion[i].questionType == KindOfQuestion.RadioCheckbox) {
                for (int k = 0; k < lsQuestion[i].answer.length; k++) {
                  if (lsQuestion[i].answer[k].id.toString() ==
                      lsAnswerUserTemp[j].answerContent[0]) {
                    if (lsQuestion[i].answer[k].answerType !=
                        KindOfAnswer.Other) {
                      selectedAnswer[i] = lsQuestion[i].answer[k];
                      //visibleQuestion[i] = true;
                    } else {
                      //  visibleQuestion[i] = true;
                      selectedAnswer[i] = lsQuestion[i].answer[k];
                      // visibleAnother[i] = true;
                      _listController[i].text =
                          lsAnswerUserTemp[j].answerOtherContent;
                    }
                  }
                }
              } else if (lsQuestion[i].questionType ==
                  KindOfQuestion.TextField) {
                _listController[i].text = lsAnswerUserTemp[j].answerContent[0];
              } else if (lsQuestion[i].questionType ==
                  KindOfQuestion.TextFieldNumber) {
                _listController[i].text = lsAnswerUserTemp[j].answerContent[0];
              } else if (lsQuestion[i].questionType ==
                  KindOfQuestion.Checkbox) {
                for (int k = 0; k < lsQuestion[i].answer.length; k++) {
                  for (int p = 0;
                      p < lsAnswerUserTemp[j].answerContent.length;
                      p++) {
                    if (lsQuestion[i].answer[k].id.toString() ==
                        lsAnswerUserTemp[j].answerContent[p]) {
                      if (lsQuestion[i].answer[k].answerType !=
                          KindOfAnswer.Other) {
                        lsCheckbox[i][k] = true;
                        //  visibleQuestion[i] = true;
                      } else {
                        //   visibleQuestion[i] = true;
                        visibleAnother[i] = true;
                        lsCheckbox[i][k] = true;
                        _listController[i].text =
                            lsAnswerUserTemp[j].answerOtherContent;
                      }
                    }
                  }
                }
              }
            }
          }
        }
        for (int i = 0; i < listFirstQuest.length; i++) {
          //  print(listFirstQuest[i]);
          if (lsQuestion[listFirstQuest[i]].questionType ==
              KindOfQuestion.RadioCheckbox) {
            if (selectedAnswer[listFirstQuest[i]] != null)
              visibleQuestion[listFirstQuest[i]] = true;
          } else if (lsQuestion[listFirstQuest[i]].questionType ==
              KindOfQuestion.Checkbox) {
            for (int k = 0;
                k < lsQuestion[listFirstQuest[i]].answer.length;
                k++) {
              if (lsCheckbox[listFirstQuest[i]][k]) {
                visibleQuestion[listFirstQuest[i]] = true;
              }
            }
          }
        }
        for (int i = 0; i < lsQuestion.length; i++) {
          if (lsQuestion[i].questionType == KindOfQuestion.RadioCheckbox) {
            for (int k = 0; k < lsQuestion[i].answer.length; k++) {
              if (selectedAnswer[i] != null) {
                if (lsQuestion[i].answer.length > 0 &&
                    selectedAnswer[i].id == lsQuestion[i].answer[k].id &&
                    visibleQuestion[i] == true) {
                  for (int m = 0;
                      m < lsQuestion[i].answer[k].srSurveyQuestions.length;
                      m++) {
                    for (int t = 0; t < lsQuestion.length; t++) {
                      if (lsQuestion[i].answer[k].srSurveyQuestions[m].id ==
                          lsQuestion[t].id) {
                        visibleQuestion[t] = true;
                      }
                    }
                  }
                }
              }
            }
          } else if (lsQuestion[i].questionType == KindOfQuestion.Checkbox) {
            for (int k = 0; k < lsQuestion[i].answer.length; k++) {
              if (lsCheckbox[i][k] == true && visibleQuestion[i] == true) {
                for (int t = 0; t < lsQuestion.length; t++) {
                  for (int m = 0;
                      m < lsQuestion[i].answer[k].srSurveyQuestions.length;
                      m++) {
                    if (lsQuestion[t].id ==
                        lsQuestion[i].answer[k].srSurveyQuestions[m].id) {
                      visibleQuestion[t] = true;
                    }
                  }
                }
              }
            }
          }
        }
      });
      VillageUser villageInfo = answerUserVillage.villageUser;
      lsProvince.forEach((f) {
        if (f.provinceId == villageInfo.provinceId) {
          setState(() {
            selectedProvince = f;
          });
        }
      });
      addressBloc.fetchDistrict(selectedProvince.provinceId, () {}, (msg) {
        LoadingDialog.hideLoadingDialog(context);
        MsgDialog.showMsgDialog(context, LanguageConfig.getNotice(), msg);
      }).then((dis) {
        setState(() {
          lsDistrict = dis;
          lsDistrict.forEach((f) {
            if (f.districtId == villageInfo.districtId) {
              setState(() {
                selectedDistrict = f;

                polygonPickDistrict.polygonPick = new Set();
                parseJsonFromDistricts(selectedDistrict.districtId.toString())
                    .then((_) {
                  polygonSetDefaultGmap.addAll(polygonPickDistrict.polygonPick);
                  setState(() {});
                  LatLngBounds bounds =
                      boundsFromLatLngList(polygonPickDistrict.lsLatlng);
                  _mapController
                      .animateCamera(CameraUpdate.newLatLngBounds(bounds, 0));
                  _addMarkerCurrent(Random().nextInt(13232).toString(),
                      villageInfo.villageNote);
                });
              });
            }
          });
          addressBloc.fetchWard(selectedDistrict.districtId, () {}, (msg) {
            LoadingDialog.hideLoadingDialog(context);
            MsgDialog.showMsgDialog(context, LanguageConfig.getNotice(), msg);
          }).then((wards) {
            setState(() {
              lsWard = wards;

              lsWard.forEach((f) {
                if (f.wardId == villageInfo.wardId) {
                  setState(() {
                    selectedWard = f;
                  });
                }
              });
              addressBloc.fetchVillage(selectedWard.wardId, () {}, (msg) {
                LoadingDialog.hideLoadingDialog(context);
                MsgDialog.showMsgDialog(
                    context, LanguageConfig.getNotice(), msg);
              }).then((vils) {
                setState(() {
                  lsVillage = vils;
                  lsVillage.forEach((f) {
                    if (f.villageId == villageInfo.villageId) {
                      setState(() {
                        selectedVillage = f;
                        _infoCraftVillage.text = villageInfo.villageNote;
                      });
                    }
                  });
                });
              });
            });
          });
        });
      });
    });
  }

  Future checkGps() async {}
  //Take Photo Function

  Marker _currentMarker;
  List<Marker> _villageMakers = [];
  Map<String, Map<String, String>> _nearbyVillages = {};

  double setMakerColor(int inputVillageId) {
    // print(inputVillageId.toString()+"=="+selectedVillage.villageId.toString()+"="+(inputVillageId == selectedVillage.villageId).toString());

    if (inputVillageId == selectedVillage.villageId)
      return BitmapDescriptor.hueBlue;

    return BitmapDescriptor.hueOrange;
  }

  void setNearbyVillagesMaker() {
    _villageMakers = [];

    for (int i = 0; i < _nearbyVillages.length; i++) {
      double markerColor = setMakerColor(
          int.parse(_nearbyVillages["Village_" + i.toString()]["villageId"]));

      _villageMakers.add(Marker(
        markerId:
            MarkerId(_nearbyVillages["Village_" + i.toString()]["villageName"]),
        infoWindow: InfoWindow(
            title: _nearbyVillages["Village_" + i.toString()]["villageName"]),
        icon: BitmapDescriptor.defaultMarkerWithHue(markerColor),
        position: LatLng(
            double.parse(
                _nearbyVillages["Village_" + i.toString()]["villageLatitude"]),
            double.parse(_nearbyVillages["Village_" + i.toString()]
                ["villageLongitude"])),
      ));
    }
  }

  _setPollutionState(bool airValue, bool soilValue, bool waterValue) {
    setState(() {
      _checkedAirPollution = airValue;
      _checkedSoilPollution = soilValue;
      _checkedWaterPollution = waterValue;
    });
  }

  getImageGPSTag(String path) async {

    final fileBytes = File(path).readAsBytesSync();
    final data = await readExifFromBytes(fileBytes);

    final latitudeValue = data['GPS GPSLatitude'].values.map<double>( (item) => (item.numerator.toDouble() / item.denominator.toDouble()) ).toList();
    final latitudeSignal = data['GPS GPSLatitudeRef'].printable;


    final longitudeValue = data['GPS GPSLongitude'].values.map<double>( (item) => (item.numerator.toDouble() / item.denominator.toDouble()) ).toList();
    final longitudeSignal = data['GPS GPSLongitudeRef'].printable;

    double latitude = latitudeValue[0]
      + (latitudeValue[1] / 60)
      + (latitudeValue[2] / 3600);

    double longitude = longitudeValue[0]
      + (longitudeValue[1] / 60)
      + (longitudeValue[2] / 3600);

    if (latitudeSignal == 'S') latitude = -latitude;
    if (longitudeSignal == 'W') longitude = -longitude;

    print("Image GPS: " + latitude.toString() + " " + longitude.toString());

    _latController.text = latitude.toStringAsFixed(7);
    _longController.text = longitude.toStringAsFixed(7);
  }

  _onTakePhotoImageClick(int index, BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    } else {
      _imageFile = ImagePicker().getImage(source: ImageSource.camera);
      // _imageFile = ImagePicker().getImage(source: ImageSource.gallery);

      _imageFile.then((image) async {
        Position _locationData = await Geolocator.getCurrentPosition();

        // _latController.text = _locationData.latitude.toString();
        // _longController.text = _locationData.longitude.toString();

        //Get GPS from image
        await getImageGPSTag(image.path);

        setState(() {
          // print("IM HERE RIGHT NOW");
          _mapController
              .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(double.parse(_latController.text),
                double.parse(_longController.text)),
            zoom: 18,
          )));

          _currentMarker = Marker(
            markerId: MarkerId('currentPos'),
            infoWindow: InfoWindow(title: 'Current Position'),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            position: LatLng(double.parse(_latController.text),
                double.parse(_longController.text)),
          );

          //Detect image
          List<int> imageBytes = File(image.path).readAsBytesSync();
          base64Img = base64Encode(imageBytes);
          Future imageDetectionResult = auth.imageDetect(base64Img);

          print("Tra ve: " + (imageDetectionResult != null).toString());
          if (imageDetectionResult != null) {
            imageDetectionResult.then((value) {

              bool airValue = false;
              bool soilValue = false;
              bool waterValue = false;

              if (value['air_pollution'] > 50)
                airValue = true;

              if (value['soil_pollution'] > 50)
                soilValue = true;

              if (value['water_pollution'] > 50)
                waterValue = true;

              _setPollutionState(airValue, soilValue, waterValue);

              print("Casca Here! - " + _checkedSoilPollution.toString());
            });
          }

          //Detect location
          print("Latitude: " + _latController.text);
          print("Longitude: " + _longController.text);

          Future locationDetectionResult =
              auth.getLocation(_latController.text, _longController.text);

          print("START LOCATION DETECTION");
          if (locationDetectionResult != null) {
            locationDetectionResult.then((value) {
              //Set Province
              addressBloc.fetchProvince(234, () {}, (msg) {}).then((pro) {
                setState(() {
                  lsProvince = pro;
                  lsProvince.forEach((f) {
                    print("Debug here: " + value.toString());
                    if (f.provinceId == int.parse(value[0]["provinceId"]))
                      setState(() {
                        selectedProvince = f;
                      });
                  });
                });
              });

              //Set District
              addressBloc
                  .fetchDistrict(
                      int.parse(value[0]["provinceId"]), () {}, (msg) {})
                  .then((dis) {
                setState(() {
                  lsDistrict = dis;
                  lsDistrict.forEach((f) {
                    if (f.districtId == int.parse(value[0]["districtId"]))
                      setState(() {
                        selectedDistrict = f;
                      });
                  });
                });
              });

              //Set Ward
              addressBloc
                  .fetchWard(int.parse(value[0]["districtId"]), () {}, (msg) {})
                  .then((ward) {
                setState(() {
                  lsWard = ward;
                  lsWard.forEach((f) {
                    if (f.wardId == int.parse(value[0]["wardId"]))
                      setState(() {
                        selectedWard = f;
                      });
                  });
                });
              });

              //Set Village
              for (var item in value) {
                String coordinate =
                    item["villageLatitude"] + ", " + item["villageLongitude"];
                lsVillage.add(new Village(
                  villageId: int.parse(item["villageId"]),
                  villageName: item["villageName"],
                  coordinate: coordinate,
                  note: item["villageNote"],
                  provinceId: item["provinceId"],
                  districtId: item["districtId"],
                  wardId: item["wardId"],
                ));
              }

              lsVillage.forEach((f) {
                if (f.villageId == int.parse(value[0]["villageId"]))
                  setState(() {
                    selectedVillage = f;
                    _infoCraftVillage.text = selectedVillage.note;
                    print("IAM IN HERE RN");
                    //Save nearby villages
                    int count = 0;
                    for (var item in value) {
                      _nearbyVillages.addAll({
                        "Village_" + count.toString(): {
                          "villageId": item["villageId"],
                          "villageName": item["villageName"],
                          "villageLatitude": item["villageLatitude"],
                          "villageLongitude": item["villageLongitude"]
                        }
                      });
                      count++;
                    }

                    //Set nearby villages position to map
                    setNearbyVillagesMaker();
                  });
              });

              // print("ward id: " + value[0]["wardId"].toString());
              // addressBloc
              //     .fetchVillage(
              //         int.parse(value[0]["wardId"]), () {}, (msg) {})
              //     .then((village) {
              //   lsVillage = village;
              //   lsVillage.forEach((f) {
              //     if (f.villageId == int.parse(value[0]["villageId"]))
              //       setState(() {
              //         selectedVillage = f;
              //         _infoCraftVillage.text = selectedVillage.note;

              //         //Save nearby villages
              //         for (int i = 0; i < value.length; i++) {
              //           _nearbyVillages.addAll({
              //             "Village_" + i.toString(): {
              //               "villageId": (value["Village_" + i.toString()]
              //                       ["villageId"])
              //                   .toString(),
              //               "villageName": (value["Village_" + i.toString()]
              //                       ["villageName"])
              //                   .toString(),
              //               "villageLatitude": (value["Village_" + i.toString()]
              //                       ["villageLatitude"])
              //                   .toString(),
              //               "villageLongitude":
              //                   (value["Village_" + i.toString()]
              //                           ["villageLongitude"])
              //                       .toString()
              //             }
              //           });
              //         }

              //         //Set nearby villages position to map
              //         setNearbyVillagesMaker();
              //       });
              //   });
              // });
            });
          }
        });
      });

      getFileImage(index, "camera");
      print("Take Photo");
      //Navigator.of(context).pop();
    }
  }

  // _onTakePhotoImageClick(int index, BuildContext context) async {
  //   if (!await location.serviceEnabled()) {
  //     location.requestService();
  //   } else {
  //     _imageFile = ImagePicker().getImage(source: ImageSource.camera);
  //     // _imageFile = ImagePicker().getImage(source: ImageSource.gallery);
  //     _imageFile.then((image) async {
  //       try {
  //         var bytes = await image.readAsBytes();
  //         var tags = await readExifFromBytes(bytes);
  //         Map<String, String> mTags = HashMap();
  //         Map<String, IfdTag> imgTags;
  //         try {
  //           // mTags.addAll(exifToGPS(tags));
  //           imgTags =
  //               await readExifFromBytes(File(image.path).readAsBytesSync());
  //         } catch (e) {
  //           print("noexif");
  //         } finally {
  //           print("Tags length: " + tags.length.toString());
  //           if (tags.length > 0) {
  //             print("LENGTH > 0");
  //             if (tags["Image GPSInfo"] == null)
  //               print("NULL");
  //             else
  //               print("NOT NULL");

  //             if (tags["GPS GPSLongitude"] != null) {
  //               tags.forEach((key, value) {
  //                 print({"$key": "$value"});
  //                 mTags.addAll({"$key": "$value"});
  //               });
  //               _latController.text =
  //                   exifGPSTLatLong(imgTags, "latitude").toString();
  //               _longController.text =
  //                   exifGPSTLatLong(imgTags, "longtitude").toString();
  //             } else {
  //               print("ELSE CLAUSE");
  //               // print(tags["Image GPSInfo"].);
  //               // print(tags['Image GPSInfo'].toString());

  //               print("TEST" +
  //                   testExifGPSTLatLong(imgTags, "latitude").toString());
  //               // print("TEST: " + tags['GPS GPSLongitude'].);
  //               // print("Latitude: " + _latController.text);
  //               // print("Longtitude: " + _longController.text);
  //               // LoadingDialog.showLoadingDialog(
  //               //     context, LanguageConfig.getProcessing());
  //               // LoadingDialog.hideLoadingDialog(context);
  //               MsgDialog.showMsgDialog(context, LanguageConfig.getNotice(),
  //                   LanguageConfig.getSuggestPositionNotice());
  //             }
  //           }
  //         }
  //       } catch (ex) {}
  //     });
  //     getFileImage(index, "camera");
  //     print("Take Photo");
  //     Navigator.of(context).pop();
  //     setState(() {});
  //   }
  // }

  // double exifGPSTLatLong(Map<String, IfdTag> tags, String type) {
  //   tags
  //   final latitudeValue = tags['GPS GPSLatitude']
  //       .values
  //       .map<double>(
  //           (item) => (item.numerator.toDouble() / item.denominator.toDouble()))
  //       .toList();
  //   final latitudeSignal = tags['GPS GPSLatitudeRef'].printable;

  //   final longitudeValue = tags['GPS GPSLongitude']
  //       .values
  //       .map<double>(
  //           (item) => (item.numerator.toDouble() / item.denominator.toDouble()))
  //       .toList();
  //   final longitudeSignal = tags['GPS GPSLongitudeRef'].printable;

  //   double latitude =
  //       latitudeValue[0] + (latitudeValue[1] / 60) + (latitudeValue[2] / 3600);

  //   double longitude = longitudeValue[0] +
  //       (longitudeValue[1] / 60) +
  //       (longitudeValue[2] / 3600);

  //   if (latitudeSignal == 'S') latitude = -latitude;
  //   if (longitudeSignal == 'W') longitude = -longitude;

  //   return type == "latitude" ? latitude : longitude;
  // }

  showAlertDialogAddCV(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text(LanguageConfig.getCancel()),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text(LanguageConfig.getAddVillage()),
      onPressed: () {},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(LanguageConfig.getAddVillage()),
      content: Container(
          width: _width,
          height: _height / 2.3,
          child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(6))),
                      child: DropdownButton<Province>(
                        underline: SizedBox(),
                        hint: Text(LanguageConfig.getPickProvince()),
                        isExpanded: true,
                        value: selectedProvince,
                        onChanged: (Province value) {
                          setState(() {
                            selectedProvince = value;
                            selectedDistrict = null;
                            lsDistrict = [];
                            lsWard = [];
                            selectedWard = null;
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
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(6))),
                      child: DropdownButton<District>(
                        underline: SizedBox(),
                        hint: Text(LanguageConfig.getPickDistrict()),
                        isExpanded: true,
                        value: selectedDistrict,
                        onChanged: (District value) {
                          setState(() {
                            selectedDistrict = value;
                            selectedWard = null;
                            lsWard = [];
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
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(6))),
                      child: DropdownButton<Ward>(
                        underline: SizedBox(),
                        hint: Text(LanguageConfig.getPickWard()),
                        isExpanded: true,
                        value: selectedWard,
                        onChanged: (Ward value) {
                          setState(() {
                            selectedWard = value;
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
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Container(
                      width: double.infinity,
                      child: TextField(
                        controller: null, // format mật khẩu thành dấu *
                        style: TextStyle(color: Colors.black, fontSize: 17),
                        decoration: InputDecoration(
                            labelText: "Tên làng nghề",
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
                    child: TextField(
                      controller: _infoCraftVillage,
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                          labelText: "Thông tin thêm về làng nghề",
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xffCED002), width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6)))),
                    ),
                  ),
                ],
              ))),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget createListInfoVillage() {
    Widget wg;

    wg = Padding(
      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(6))),
          child: DropdownButton<Village>(
            underline: SizedBox(),
            hint: Text(LanguageConfig.getPickVillage()),
            isExpanded: true,
            value: selectedVillageImage,
            onChanged: (Village value) {
              setState(() {
                selectedVillageImage = value;
                print(value.villageName);
              });
            },
            items: lsVil.map((Village village) {
              return DropdownMenuItem<Village>(
                value: village,
                child: Row(
                  children: <Widget>[
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      village.villageName,
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              );
            }).toList(),
          )),
    );
    return wg;
  }

  showAlertGetDataCraftVillage(BuildContext context) {
    var auth = MyApp.of(context).auth;
    LoadingDialog.hideLoadingDialog(context);
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text(LanguageConfig.getCancel()),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text(LanguageConfig.getOK()),
      onPressed: () {
        setState(() {
          villageBloc.fetchVillageUserByWardId(
              selectedVillageImage.villageId, () {}, (msg) {
            LoadingDialog.hideLoadingDialog(context);
            MsgDialog.showMsgDialog(context, LanguageConfig.getNotice(), msg);
          }).then((info) {
            lsProvince.forEach((f) {
              if (f.provinceId == info.provinceId) {
                setState(() {
                  selectedProvince = f;
                });
              }
            });
            addressBloc.fetchDistrict(selectedProvince.provinceId, () {},
                (msg) {
              LoadingDialog.hideLoadingDialog(context);
              MsgDialog.showMsgDialog(context, LanguageConfig.getNotice(), msg);
            }).then((dis) {
              setState(() {
                lsDistrict = dis;
                lsDistrict.forEach((f) {
                  if (f.districtId == info.districtId) {
                    setState(() {
                      selectedDistrict = f;
                    });
                  }
                });
                addressBloc.fetchWard(selectedDistrict.districtId, () {},
                    (msg) {
                  LoadingDialog.hideLoadingDialog(context);
                  MsgDialog.showMsgDialog(
                      context, LanguageConfig.getNotice(), msg);
                }).then((wards) {
                  setState(() {
                    lsWard = wards;

                    lsWard.forEach((f) {
                      if (f.wardId == info.wardId) {
                        setState(() {
                          selectedWard = f;
                        });
                      }
                    });
                    addressBloc.fetchVillage(selectedWard.wardId, () {}, (msg) {
                      LoadingDialog.hideLoadingDialog(context);
                      MsgDialog.showMsgDialog(
                          context, LanguageConfig.getNotice(), msg);
                    }).then((vils) {
                      setState(() {
                        lsVillage = vils;
                        lsVillage.forEach((f) {
                          if (f.villageId.toString() ==
                              selectedVillageImage.villageId.toString()) {
                            setState(() {
                              selectedVillage = f;
                              _infoCraftVillage.text = info.villageNote;
                            });
                          }
                        });
                      });
                    });
                  });
                });
              });
            });
          });
          surveyBloc.fetchSurveyAnswerByImage(1, () {}, (msg) {
            LoadingDialog.hideLoadingDialog(context);
            MsgDialog.showMsgDialog(context, LanguageConfig.getNotice(), msg);
          }).then((value) {
            if (value == null) {
              print("khong co gi");
            } else {
              surveyAnswerUserByID = value;
              List<AnswerUser> lsAnswerUserTemp = surveyAnswerUserByID.answers;

              for (int i = 0; i < lgnQuestion; i++) {
                for (int j = 0; j < lsAnswerUserTemp.length; j++) {
                  if (lsQuestion[i].id == lsAnswerUserTemp[j].questionID) {
                    if (lsQuestion[i].questionType ==
                        KindOfQuestion.RadioCheckbox) {
                      for (int k = 0; k < lsQuestion[i].answer.length; k++) {
                        if (lsQuestion[i].answer[k].id.toString() ==
                            lsAnswerUserTemp[j].answerContent[0]) {
                          if (lsQuestion[i].answer[k].answerType !=
                              KindOfAnswer.Other) {
                            selectedAnswer[i] = lsQuestion[i].answer[k];
                            //visibleQuestion[i] = true;
                          } else {
                            //  visibleQuestion[i] = true;
                            selectedAnswer[i] = lsQuestion[i].answer[k];
                            // visibleAnother[i] = true;
                            _listController[i].text =
                                lsAnswerUserTemp[j].answerOtherContent;
                          }
                        }
                      }
                    } else if (lsQuestion[i].questionType ==
                        KindOfQuestion.TextField) {
                      _listController[i].text =
                          lsAnswerUserTemp[j].answerContent[0];
                    } else if (lsQuestion[i].questionType ==
                        KindOfQuestion.TextFieldNumber) {
                      _listController[i].text =
                          lsAnswerUserTemp[j].answerContent[0];
                    } else if (lsQuestion[i].questionType ==
                        KindOfQuestion.Checkbox) {
                      for (int k = 0; k < lsQuestion[i].answer.length; k++) {
                        for (int p = 0;
                            p < lsAnswerUserTemp[j].answerContent.length;
                            p++) {
                          if (lsQuestion[i].answer[k].id.toString() ==
                              lsAnswerUserTemp[j].answerContent[p]) {
                            if (lsQuestion[i].answer[k].answerType !=
                                KindOfAnswer.Other) {
                              lsCheckbox[i][k] = true;
                              //  visibleQuestion[i] = true;
                            } else {
                              //   visibleQuestion[i] = true;
                              visibleAnother[i] = true;
                              lsCheckbox[i][k] = true;
                              _listController[i].text =
                                  lsAnswerUserTemp[j].answerOtherContent;
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
              for (int i = 0; i < listFirstQuest.length; i++) {
                //  print(listFirstQuest[i]);
                if (lsQuestion[listFirstQuest[i]].questionType ==
                    KindOfQuestion.RadioCheckbox) {
                  if (selectedAnswer[listFirstQuest[i]] != null)
                    visibleQuestion[listFirstQuest[i]] = true;
                } else if (lsQuestion[listFirstQuest[i]].questionType ==
                    KindOfQuestion.Checkbox) {
                  for (int k = 0;
                      k < lsQuestion[listFirstQuest[i]].answer.length;
                      k++) {
                    if (lsCheckbox[listFirstQuest[i]][k]) {
                      visibleQuestion[listFirstQuest[i]] = true;
                    }
                  }
                }
              }
              for (int i = 0; i < lsQuestion.length; i++) {
                if (lsQuestion[i].questionType ==
                    KindOfQuestion.RadioCheckbox) {
                  for (int k = 0; k < lsQuestion[i].answer.length; k++) {
                    if (selectedAnswer[i] != null) {
                      if (lsQuestion[i].answer.length > 0 &&
                          selectedAnswer[i].id == lsQuestion[i].answer[k].id &&
                          visibleQuestion[i] == true) {
                        for (int m = 0;
                            m <
                                lsQuestion[i]
                                    .answer[k]
                                    .srSurveyQuestions
                                    .length;
                            m++) {
                          for (int t = 0; t < lsQuestion.length; t++) {
                            if (lsQuestion[i]
                                    .answer[k]
                                    .srSurveyQuestions[m]
                                    .id ==
                                lsQuestion[t].id) {
                              visibleQuestion[t] = true;
                            }
                          }
                        }
                      }
                    }
                  }
                } else if (lsQuestion[i].questionType ==
                    KindOfQuestion.Checkbox) {
                  for (int k = 0; k < lsQuestion[i].answer.length; k++) {
                    if (lsCheckbox[i][k] == true &&
                        visibleQuestion[i] == true) {
                      for (int t = 0; t < lsQuestion.length; t++) {
                        for (int m = 0;
                            m <
                                lsQuestion[i]
                                    .answer[k]
                                    .srSurveyQuestions
                                    .length;
                            m++) {
                          if (lsQuestion[t].id ==
                              lsQuestion[i].answer[k].srSurveyQuestions[m].id) {
                            visibleQuestion[t] = true;
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          });
          LoadingDialog.hideLoadingDialog(context);
          //   });
        });
      },
    );
    lsVil = lsVil.toSet().toList();
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Thông tin làng nghề có trong ảnh"),
      content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return Container(
            width: _width,
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(6))),
                  child: DropdownButton<Village>(
                    underline: SizedBox(),
                    hint: Text(LanguageConfig.getPickVillage()),
                    isExpanded: true,
                    value: selectedVillageImage,
                    onChanged: (Village value) {
                      setState(() {
                        selectedVillageImage = value;
                        print(value.villageName);
                      });
                    },
                    items: lsVil.map((Village village) {
                      return DropdownMenuItem<Village>(
                        value: village,
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              width: 220.0,
                              child: Text(
                                village.villageName,
                                style: TextStyle(color: Colors.black),
                              ),
                            )
                          ],
                        ),
                      );
                    }).toList(),
                  )),
            ));
      }),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showNoticeSubmitAndSaveDraft(BuildContext context, String typeSubmit) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text(LanguageConfig.getCancel()),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text(LanguageConfig.getContinue()),
      onPressed: () {
        Navigator.pop(context);
        // _onSubmitClick(typeSubmit);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(LanguageConfig.getNotice()),
      content: Container(
          child: Text(
        typeSubmit == "completed"
            ? LanguageConfig.getCompletedInfo()
            : LanguageConfig.getSaveDraftInfo(),
        textAlign: TextAlign.justify,
      )),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showNoticeDeletePicture(BuildContext context, int index) {
    // set up the buttons
    print("Delete Image!");
    Widget cancelButton = FlatButton(
      child: Text(LanguageConfig.getCancel()),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text(LanguageConfig.getOK()),
      onPressed: () {
        LoadingDialog.hideLoadingDialog(context);
        if (surveyActiveID != null && filename[index] != null) {
          LoadingDialog.showLoadingDialog(
              context, LanguageConfig.getProcessing());
          imageBloc.deletePicture(filename[index], () {}, (msg) {
            LoadingDialog.hideLoadingDialog(context);
            MsgDialog.showMsgDialog(context, LanguageConfig.getNotice(), msg);
          }).then((value) {
            if (value == 1) {
              LoadingDialog.hideLoadingDialog(context);
              setState(() {
                images.replaceRange(index, index + 1, ['Add Image']);
                filename[index] = null;
              });
            } else {
              LoadingDialog.hideLoadingDialog(context);
              MsgDialog.showMsgDialog(context, LanguageConfig.getNotice(),
                  LanguageConfig.getWarningRemoveImage());
            }
          });
        } else {
          setState(() {
            images.replaceRange(index, index + 1, ['Add Image']);
            _mapController
                .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
              target: LatLng(16.3680792, 107.0434273),
              zoom: 4.8,
            )));
            _latController.text = '';
            _longController.text = '';
            _currentMarker = null;
            _villageMakers = [];
            _nearbyVillages = {};

            for (int i = 0; i < 3; i++)
              if (listCheckboxWidget[lsQuestion[24].answer[i].answerContent]
                      .value ==
                  true)
                listCheckboxWidget[lsQuestion[24].answer[i].answerContent]
                    .onChanged(false);

            selectedProvince = null;
            selectedDistrict = null;
            selectedWard = null;
            selectedVillage = null;
            _infoCraftVillage.text = "";
          });
        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(LanguageConfig.getNotice()),
      content: Container(
          child: Text(
        LanguageConfig.getRemoveImage(),
        textAlign: TextAlign.justify,
      )),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

//ADD MAP
  Set<Polygon> polygonSetDefault = new Set();
  Set<Polygon> polygonSetDefaultGmap = new Set();
  final Set<Polygon> polygonSetRegions = new Set();
  final Set<Polygon> polygonSetProvinces = new Set();
  final Set<Polygon> polygonSetDistricts = new Set();
  InfoPolygon polygonPickProvince = new InfoPolygon();
  InfoPolygon polygonPickDistrict = new InfoPolygon();

  Map<String, bool> lsVietNamMap = {
    'Regions': false,
    'Provinces': true,
    'Districts': false,
  };

  bool checkLoadingMap;
  bool enableAbsorb = true;
  String textEnableAbsorb = "Enable map";
  GoogleMapController _mapController;
  String _mapStyle;

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  MarkerId selectedMarker;

  Color colorPowerEnable = Colors.red;
  bool indexPowerEnable = false;

  TextEditingController _latController = new TextEditingController();
  TextEditingController _longController = new TextEditingController();

  loadAllDataSet() {
    checkLoadingMap = true;
    // parseJsonFromRegions().then((_) => parseJsonFromDistricts(null)
    //     .then((value) => parseJsonFromProvinces(null).then((_) {
    //           setState(() {

    //             polygonSetDefault = polygonSetProvinces;
    //           });
    //         })));
  }

  LatLngBounds boundsFromLatLngList(List<LatLng> list) {
    assert(list.isNotEmpty);
    double x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1) y1 = latLng.longitude;
        if (latLng.longitude < y0) y0 = latLng.longitude;
      }
    }
    setState(() {});
    return LatLngBounds(northeast: LatLng(x1, y1), southwest: LatLng(x0, y0));
  }

  Future<void> parseJsonFromRegions() async {
    final geo = GeoJson();
    geo.processedFeatures.listen((GeoJsonFeature feature) {
      var multiPolygon = feature.geometry as GeoJsonMultiPolygon;

      for (final poly in multiPolygon.polygons) {
        List<LatLng> lsPolygons = [];
        List<latLng.LatLng> lsGeoLatLng = poly.geoSeries[0].toLatLng();
        lsGeoLatLng.forEach((element) {
          lsPolygons.add(LatLng(element.latitude, element.longitude));
        });
        polygonSetRegions.add(Polygon(
            polygonId: PolygonId(Random().nextInt(10000000).toString()),
            points: lsPolygons,
            strokeColor: LightColors.strokeColorCover,
            strokeWidth: 1,
            consumeTapEvents: true,
            onTap: () {
              print("á à");
            }));
      }
    });
    geo.endSignal.listen((_) => geo.dispose());
    final data =
        await rootBundle.loadString('assets/map/vietnam_regions.geojson');
    await geo.parse(data, verbose: true);
  }

  Future<void> parseJsonFromDistricts(String maQuanHuyen) async {
    final geo = GeoJson();
    geo.processedFeatures.listen((GeoJsonFeature feature) {
      var multiPolygon = feature.geometry as GeoJsonMultiPolygon;
      if (maQuanHuyen == null) {
        for (final poly in multiPolygon.polygons) {
          List<LatLng> lsPolygons = [];
          List<latLng.LatLng> lsGeoLatLng = poly.geoSeries[0].toLatLng();
          lsGeoLatLng.forEach((element) {
            lsPolygons.add(LatLng(element.latitude, element.longitude));
          });
          polygonSetDistricts.add(Polygon(
              polygonId: PolygonId(Random().nextInt(50000).toString()),
              points: lsPolygons,
              strokeColor: LightColors.strokeColorCover,
              strokeWidth: 1,
              consumeTapEvents: true,
              onTap: () {
                print("á à");
              }));
        }
      } else {
        if (int.parse(feature.properties['Ma']) == int.parse(maQuanHuyen)) {
          int dem = 0;
          polygonPickDistrict.lsLatlng = [];
          for (final poly in multiPolygon.polygons) {
            List<LatLng> lsPolygons = [];
            List<latLng.LatLng> lsGeoLatLng = poly.geoSeries[0].toLatLng();
            lsGeoLatLng.forEach((element) {
              lsPolygons.add(LatLng(element.latitude, element.longitude));
            });
            if (lsPolygons != null)
              polygonPickDistrict.lsLatlng.addAll(lsPolygons);
            polygonPickDistrict.polygonPick.add(Polygon(
                polygonId: PolygonId(Random().nextInt(50000).toString()),
                points: lsPolygons,
                strokeColor: LightColors.strokeColorDistrict,
                strokeWidth: 1,
                fillColor: Colors.transparent,
                consumeTapEvents: true,
                onTap: () {
                  print("á à");
                }));
          }
        }
      }
    });
    geo.endSignal.listen((_) => geo.dispose());
    final data =
        await rootBundle.loadString('assets/map/vietnam_districts.json');
    await geo.parse(data, verbose: true);
  }

  Future<void> parseJsonFromProvinces(String maTinh) async {
    final geo = GeoJson();
    geo.processedFeatures.listen((GeoJsonFeature feature) {
      var multiPolygon = feature.geometry as GeoJsonMultiPolygon;
      if (maTinh == null) {
        for (final poly in multiPolygon.polygons) {
          List<LatLng> lsPolygons = [];
          List<latLng.LatLng> lsGeoLatLng = poly.geoSeries[0].toLatLng();
          lsGeoLatLng.forEach((element) {
            lsPolygons.add(LatLng(element.latitude, element.longitude));
          });
          polygonSetProvinces.add(Polygon(
              polygonId: PolygonId(Random().nextInt(50000).toString()),
              points: lsPolygons,
              strokeColor: Colors.red,
              fillColor: Colors.transparent,
              strokeWidth: 1,
              consumeTapEvents: true,
              onTap: () {
                print("á à");
              }));
        }
      } else {
        if (int.parse(feature.properties['Ma']) == int.parse(maTinh)) {
          int dem = 0;
          polygonPickProvince.lsLatlng = [];
          double x = multiPolygon.polygons[0].geoSeries[0].geoPoints.length / 2;
          int midlePolygon = x.toInt();
          print("size polygon: $midlePolygon");
          for (final poly in multiPolygon.polygons) {
            List<LatLng> lsPolygons = [];
            List<latLng.LatLng> lsGeoLatLng = poly.geoSeries[0].toLatLng();
            lsGeoLatLng.forEach((element) {
              // if (dem == 0) {
              //   polygonPickProvince.lat = element.latitude;
              //   polygonPickProvince.long = element.longitude;
              // }
              lsPolygons.add(LatLng(element.latitude, element.longitude));
            });
            if (lsPolygons != null)
              polygonPickProvince.lsLatlng.addAll(lsPolygons);
            polygonPickProvince.polygonPick.add(Polygon(
                polygonId: PolygonId(Random().nextInt(50000).toString()),
                points: lsPolygons,
                strokeColor: Colors.red,
                fillColor: Colors.transparent,
                strokeWidth: 1,
                consumeTapEvents: true,
                onTap: () {
                  print("á à");
                }));
            dem++;
          }
        }
      }
    });
    geo.endSignal.listen((_) => geo.dispose());
    final data =
        await rootBundle.loadString('assets/map/vietnam_provinces.json');
    await geo.parse(data, verbose: true);
  }

  Set setMaker() {
    Set res;
    if (_villageMakers != null) res = _villageMakers.toSet();
    if (_currentMarker != null) res.add(_currentMarker);

    return res;
  }

  bool _visibleGmap = true;
  Widget gMap() {
    if (!checkLoadingMap)
      return Padding(
        padding: EdgeInsets.only(top: 15),
        child: Container(
          alignment: Alignment.center,
          child: Text(LanguageConfig.getLoadingGmap()),
        ),
      );
    return Padding(
      padding: EdgeInsets.only(top: 15, left: 20, right: 20),
      child: (Container(
        child: Column(
          children: <Widget>[
            Container(
              height: _height / 2,
              child: Stack(
                children: <Widget>[
                  // Padding(
                  //   padding: const EdgeInsets.all(15.0),
                  //   child: Container(
                  //     alignment: Alignment.centerRight,
                  //     child: RaisedButton(
                  //       onPressed: () {
                  //         _mapController.animateCamera(
                  //           CameraUpdate.newCameraPosition(CameraPosition(target: null))
                  //         );
                  //       },
                  //       child: new Text('Click me'),
                  //     ),
                  //   ),
                  // ),
                  AbsorbPointer(
                    absorbing: enableAbsorb,
                    child: Container(
                      child: GoogleMap(
                        onMapCreated: (GoogleMapController controller) {
                          _mapController = controller;
                          _mapController.setMapStyle(_mapStyle);
                        },
                        mapType: MapType.terrain,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(16.3680792, 107.0434273),
                          zoom: 4.8,
                        ),
                        mapToolbarEnabled: false,
                        zoomControlsEnabled: false,
                        markers: setMaker(),
                        //  markers: _markers.values.toSet(),
                        //   polylines: poly,
                        polygons: {
                          ...polygonPickProvince.polygonPick ?? [],
                          ...polygonPickDistrict.polygonPick ?? [],
                          //   ...polygonSetDefault ?? []
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Visibility(
                      visible: _visibleGmap,
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    color: Colors.black.withOpacity(0.2)),
                                child: IconButton(
                                    iconSize: 30,
                                    icon: Image.asset(
                                      "assets/ic_power_off.png",
                                      color: colorPowerEnable,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        indexPowerEnable = !indexPowerEnable;
                                        colorPowerEnable = indexPowerEnable
                                            ? Colors.red
                                            : Colors.green;
                                        enableAbsorb =
                                            indexPowerEnable ? true : false;
                                      });
                                    })),
                          ),
                          // Container(
                          //   // width: _width / 3,
                          //   height: 30,
                          //   decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.all(Radius.circular(20)),
                          //   ),
                          //   child: Container(
                          //       decoration: BoxDecoration(
                          //           borderRadius: BorderRadius.all(Radius.circular(20)),
                          //           color: Colors.black.withOpacity(0.5)),
                          //       child: IconButton(
                          //           iconSize: 30,
                          //           icon: Icon(Icons.menu, color: Colors.white),
                          //           onPressed: () {
                          //             setState(() {
                          //               _visibleGmap = !_visibleGmap;
                          //             });
                          //           })),
                          //   // RaisedButton(
                          //   //   color: Colors.blueAccent[100],
                          //   //   onPressed: () {
                          //   //     // showSecondGmap(context);
                          //   //     setState(() {
                          //   //       enableAbsorb = !enableAbsorb;
                          //   //       textEnableAbsorb =
                          //   //           enableAbsorb ? "Enable map" : "Disable map";
                          //   //     });
                          //   //   },
                          //   //   child: Text(textEnableAbsorb),
                          //   // ),
                          // ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    color: Colors.black.withOpacity(0.2)),
                                child: IconButton(
                                    iconSize: 30,
                                    icon: Image.asset("assets/refresh.png",
                                        color: Colors.white),
                                    onPressed: () {})),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                      right: 5,
                      top: 5,
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              color: Colors.black.withOpacity(0.5)),
                          child: IconButton(
                              iconSize: 30,
                              icon: Icon(Icons.menu, color: Colors.white),
                              onPressed: () {
                                setState(() {
                                  _visibleGmap = !_visibleGmap;
                                });
                              }))),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      color: Colors.white,
                      width: _width / 2.5,
                      child: TextField(
                        controller: _latController,
                        style: TextStyle(color: Colors.black, fontSize: 18),
                        decoration: InputDecoration(
                            labelText: LanguageConfig.getLatitude(),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xffCED002), width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6)))),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      width: _width / 2.5,
                      child: TextField(
                        controller: _longController,
                        style: TextStyle(color: Colors.black, fontSize: 18),
                        decoration: InputDecoration(
                            labelText: LanguageConfig.getLongtitude(),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xffCED002), width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6)))),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      )),
    );
  }

  showDialogFillPolygon(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text(LanguageConfig.getCancel()),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text(LanguageConfig.getSubmit()),
      onPressed: () {
        polygonSetDefault = null;
        lsVietNamMap.forEach((key, value) {
          if (value == true) {
            if (key == "Regions") {
              bool checkDistricts = false;
              bool checkProvinces = false;
              lsVietNamMap.forEach((key, value) {
                if (key == "Districts" && value) {
                  checkDistricts = true;
                } else if (key == "Provinces" && value) {
                  checkProvinces = true;
                }
              });
              if (!checkDistricts && checkProvinces)
                polygonSetDefault = polygonSetProvinces;
              else if ((checkDistricts && !checkProvinces) ||
                  (checkDistricts && checkProvinces))
                polygonSetDefault = polygonSetDistricts;
              else
                polygonSetDefault = polygonSetRegions;
            }
            if (key == "Provinces") {
              bool checkDistricts = false;
              lsVietNamMap.forEach((key, value) {
                if (key == "Districts" && value) {
                  checkDistricts = true;
                }
              });
              if (checkDistricts)
                polygonSetDefault = polygonSetDistricts;
              else
                polygonSetDefault = polygonSetProvinces;
            }
            if (key == "Districts") {
              polygonSetDefault = polygonSetDistricts;
            }
          } else {
            bool isCheckAll = false;
            lsVietNamMap.forEach((key, value) {
              if (value == true) {
                if (key == "Regions") {
                  polygonSetDefault = polygonSetRegions;
                }
                if (key == "Provinces") {
                  polygonSetDefault = polygonSetProvinces;
                }
                if (key == "Districts") {
                  polygonSetDefault = polygonSetDistricts;
                }
                isCheckAll = true;
              }
            });
            if (isCheckAll == false) polygonSetDefault = null;
          }
        });
        // _mapController.animateCamera(
        //               CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(16.3680792, 107.0434273), zoom: 4.8))
        //             );
        Navigator.pop(context);
        //LoadingDialog.showLoadingDialog(context, "Đang tải map..");
      },
    );

    // set up the AlertDialog
    StatefulBuilder builderStateful =
        StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        title: Text("Fill polygon"),
        content: Container(
          width: _width / 2.5 + 5,
          height: _height / 5,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: ListView(
            children: lsVietNamMap.keys.map((String key) {
              return new CheckboxListTile(
                title: Text(
                  key,
                  style: TextStyle(fontSize: 13),
                ),
                value: lsVietNamMap[key],
                onChanged: (bool value) {
                  setState(() {
                    lsVietNamMap[key] = value;
                  });
                },
              );
            }).toList(),
          ),
        ),
        actions: [
          cancelButton,
          continueButton,
        ],
      );
    });

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return builderStateful;
      },
    ).then((_) {
      setState(() {});
    });
  }

  void _addMarkers(Village village) {
    var markerIdVal = village.villageId.toString();
    final MarkerId markerId = MarkerId(markerIdVal);

    // creating a new MARKER
    var str = village.coordinate.split(",");
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(double.parse(str[0]), double.parse(str[1])),
      // LatLng(
      //   center.latitude + sin(_markerIdCounter * pi / 6.0) / 20.0,
      //   center.longitude + cos(_markerIdCounter * pi / 6.0) / 20.0,
      // ),
      infoWindow: InfoWindow(
          title: village.villageName,
          snippet: village.note,
          onTap: () {
            showAlertDialogPickVillageFromMap(context, village);
          }),
      onTap: () {
        _onMarkerTapped(markerId);
      },
    );

    setState(() {
      // adding a new marker to map
      markers[markerId] = marker;
    });
  }

  void _addMarkerCurrent(String idMarker, String villageNote) {
    var markerIdVal = idMarker;
    final MarkerId markerId = MarkerId(markerIdVal);

    // creating a new MARKER

    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(double.parse(_latController.text),
          double.parse(_longController.text)),
      // LatLng(
      //   center.latitude + sin(_markerIdCounter * pi / 6.0) / 20.0,
      //   center.longitude + cos(_markerIdCounter * pi / 6.0) / 20.0,
      // ),
      infoWindow: InfoWindow(
        title: LanguageConfig.getCurrentPosition(),
        snippet: villageNote,
      ),
      onTap: () {
        _onMarkerTapped(markerId);
      },
    );

    setState(() {
      // adding a new marker to map
      markers[markerId] = marker;
    });
  }

  void _onMarkerTapped(MarkerId markerId) {
    final Marker tappedMarker = markers[markerId];
    if (tappedMarker != null) {
      setState(() {
        if (markers.containsKey(selectedMarker)) {
          final Marker resetOld = markers[selectedMarker]
              .copyWith(iconParam: BitmapDescriptor.defaultMarker);
          markers[selectedMarker] = resetOld;
        }
        selectedMarker = markerId;
        final Marker newMarker = tappedMarker.copyWith(
          iconParam: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
        );
        markers[markerId] = newMarker;
      });
    }
  }

  showAlertDialogPickVillageFromMap(BuildContext context, Village village) {
    // set up the button
    Widget okButton = FlatButton(
        child: Text(LanguageConfig.getPick()),
        onPressed: () {
          LoadingDialog.hideLoadingDialog(context);

          villageBloc.checkExistVillage(village.villageId, () {}, (msg) {
            LoadingDialog.hideLoadingDialog(context);
            MsgDialog.showMsgDialog(context, LanguageConfig.getNotice(), msg);
          }).then((result) {
            if (result) {
              _infoCraftVillage.text = '';
              addressBloc.fetchVillage(selectedWard.wardId, () {}, (msg) {
                MsgDialog.showMsgDialog(
                    context, LanguageConfig.getNotice(), msg);
              }).then((vils) {
                setState(() {
                  lsVillage = vils;
                  lsVillage.forEach((f) {
                    if (f.villageId == village.villageId) {
                      setState(() {
                        selectedVillage = f;
                        _infoCraftVillage.text = village.note;
                      });
                    }
                  });
                });
              });
            } else {
              MsgDialog.showMsgDialog(context, LanguageConfig.getNotice(),
                  LanguageConfig.getInvestigated());
            }
          });
        });
    Widget cancleButton = FlatButton(
      child: Text(LanguageConfig.getCancel()),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(LanguageConfig.getNotice()),
      content: Text(LanguageConfig.getPickVillageFromMap(village.villageName)),
      //  "Bạn có muốn chọn làng nghề ${village.villageName} không?"),
      actions: [
        cancleButton,
        okButton,
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

//END ADD MAP
}
