class SurveysInProgressModel {
  int surveyActiveID;
  String dateActive;
  String dateEnd;
  String surveyName;
  int surveyId;
  int totalQuestion;
  int totalAnswer;
  int totalImage;
  String dateSubmitSurvey;
  String villageName;
  int userSurveyId;
  List<String> filename;
  String typeSurvey;
  SurveysInProgressModel(
      {this.surveyActiveID,
      this.dateActive,
      this.dateEnd,
      this.surveyName,
      this.surveyId,
      this.totalQuestion,
      this.totalAnswer,
      this.totalImage,
      this.dateSubmitSurvey,
      this.villageName,
      this.userSurveyId,
      this.filename,
      this.typeSurvey
      });
  factory SurveysInProgressModel.fromJson(Map json) {
    return SurveysInProgressModel(
        surveyActiveID: json['surveyActiveID'],
        dateActive: json['dateActive'],
        dateEnd: json['dateEnd'],
        surveyName: json['surveyName'],
        surveyId: json['surveyId'],
        totalQuestion: json['totalQuestion'],
        totalAnswer: json['totalAnswer'],
        totalImage: json['totalImage'],
        dateSubmitSurvey: json['dateSubmitSurvey'],
        villageName: json['villageName'],
        userSurveyId: json['userSurveyId'],
		  	filename: List<String>.from(json["filename"].map((x) => x == null ? null : x)),
        //filename:  (json['filename'] as List).map( (p) => String.fromEnvironment(p)).toList(),
        typeSurvey: json['typeSurvey'],
        
        );
        
  }
}
