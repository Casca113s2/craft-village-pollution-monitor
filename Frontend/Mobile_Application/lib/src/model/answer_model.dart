import 'package:fl_nynberapp/src/model/question_model.dart';

class Answer {
  int id;
  String answerContent;
  KindOfAnswer answerType;
  List<Question> srSurveyQuestions;
  Answer(
      {this.id, this.answerContent, this.answerType, this.srSurveyQuestions});
  factory Answer.fromJson(Map json) {
    return Answer(
      id: json['id'],
      answerContent: json['answerContent'],
      answerType: json['answerType'] == "Other"
          ? KindOfAnswer.Other
          : (json['answerType'] == "TF"
              ? KindOfAnswer.TF
              : (json['answerType'] == "Radio"
                  ? KindOfAnswer.Radio
                  : KindOfAnswer.Check)),
      srSurveyQuestions: (json['srSurveyQuestions'] as List)
          .map((p) => Question.fromJson(p))
          .toList(),
    );
  }
}

enum KindOfAnswer {
  Radio,
  TF,
  Other,
  Check,
}
