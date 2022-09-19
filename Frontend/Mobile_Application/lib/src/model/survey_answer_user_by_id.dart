import 'package:fl_nynberapp/src/model/answer_user_model.dart';
import 'package:fl_nynberapp/src/model/survey_model.dart';

class SurveyAnswerUserByID{
  List<AnswerUser> answers;
  Survey surveys;
  SurveyAnswerUserByID({this.answers, this.surveys});
   factory SurveyAnswerUserByID.fromJson(Map<String, dynamic> json) {
    return SurveyAnswerUserByID(
      answers:  (json['answers'] as List).map( (p) => AnswerUser.fromJson(p)).toList() ,
      surveys: Survey.fromJson(json['surveys']) 
    );
  }
}