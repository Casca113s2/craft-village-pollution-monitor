class SurveysCompletedModel {
  int surveyActiveID;
  String dateActive;
  String dateEnd;
  int questionCount;
  int answerCount;
  String surveyName;
  int surveyId;
  int totalQuestion;
  int totalAnswer;
  int totalImage;
  String dateSubmitSurvey;
  String villageName;
  String typeSurvey;
  int userSurveyId;
  List<String> filename;
  SurveysCompletedModel(
      {this.surveyActiveID,
      this.dateActive,
      this.dateEnd,
      this.questionCount,
      this.answerCount,
      this.surveyName,
      this.surveyId,
      this.totalQuestion,
      this.totalAnswer,
      this.totalImage,
      this.dateSubmitSurvey,
      this.villageName,
      this.typeSurvey,
      this.userSurveyId,
      this.filename,
      });
 factory SurveysCompletedModel.fromJson(Map json){
    return SurveysCompletedModel(
      surveyActiveID: json['surveyActiveID'],
      dateActive: json['dateActive'],
      dateEnd: json['dateEnd'],
      questionCount: json['questionCount'],
      answerCount: json['answerCount'],
      surveyName: json['surveyName'],
      surveyId: json['surveyId'],
      totalQuestion: json['totalQuestion'],
      totalAnswer: json['totalAnswer'],
      totalImage: json['totalImage'],
      dateSubmitSurvey: json['dateSubmitSurvey'],
      villageName: json['villageName'],
      typeSurvey: json['typeSurvey'],
      userSurveyId: json['userSurveyId'],
      filename: List<String>.from(json["filename"].map((x) => x == null ? null : x)),
      );
  }
}
