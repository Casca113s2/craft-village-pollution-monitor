import 'package:fl_nynberapp/src/model/answer_model.dart';

class Question {
  int id;
  String questionContent;
  KindOfQuestion questionType;
  List<Answer> answer;
  String questionLabel;
  Question(
      {this.id,
      this.questionContent,
      this.questionType,
      this.answer,
      this.questionLabel});

  factory Question.fromJson(Map json) {
    return Question(
        id: json['id'],
        questionContent: json['questionContent'],
        questionType: json['questionType'] == "RadioCheckBox"
            ? KindOfQuestion.RadioCheckbox
            : (json['questionType'] == "CheckBox"
                ? KindOfQuestion.Checkbox
                : (json['questionType'] == "TextField"
                    ? KindOfQuestion.TextField
                    : (json['questionType'] == "TextFieldNumber"
                        ? KindOfQuestion.TextFieldNumber
                        : KindOfQuestion.File))),
        answer: (json['srSurveyQuestionAnswers'] as List)
            .map((p) => Answer.fromJson(p))
            .toList(),
        questionLabel: json['questionLable']);
  }
}

enum KindOfQuestion {
  RadioCheckbox,
  Checkbox,
  TextField,
  TextFieldNumber,
  // Temp,
  File
}
