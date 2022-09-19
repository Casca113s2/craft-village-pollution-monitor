import 'package:fl_nynberapp/src/model/question_model.dart';

class Survey{
  int id;
  String dateCreate;
  String campainName;
  String campainGoal;
  String dateEnd;
  int userIdCreate;
  String surveyCode;
  List<Question> srQuestions;
 Survey({this.id, this.dateCreate, this.campainName, this.campainGoal, this.userIdCreate, this.surveyCode, this.srQuestions});

  factory Survey.fromJson(Map<String, dynamic> json) {
    return Survey(
      id: json['id'],
      dateCreate: json['dateCreate'],
      campainName: json['campainName'],
      campainGoal: json['campainGoal'],
      userIdCreate: json['userIdCreate'],
      surveyCode: json['surveyCode'],
      srQuestions: (json['srSurveyQuestions'] as List).map( (p) => Question.fromJson(p)).toList() 
      
    );
  }
}