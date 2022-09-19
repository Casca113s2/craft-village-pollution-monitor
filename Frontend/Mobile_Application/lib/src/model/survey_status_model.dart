import 'package:fl_nynberapp/src/model/survey_model.dart';

class SurveyStatus{
  int activeID;
  Survey srSurvey;
  SurveyStatus({this.activeID, this.srSurvey});
  factory SurveyStatus.fromJson(Map json) {
    return SurveyStatus(
      activeID: json['id'],
      srSurvey: Survey.fromJson(json['srSurvey']) ,
    );
  }
}