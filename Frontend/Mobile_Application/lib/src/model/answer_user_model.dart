class AnswerUser{
  int questionID;
  List<String> answerContent;
  int activeID;
  String answerOtherContent;
  AnswerUser({this.questionID, this.answerContent, this.activeID, this.answerOtherContent});
  factory AnswerUser.fromJson(Map json) {
    return AnswerUser(
      questionID: json['srSqId'],
      answerContent: (json['answerContent'] as String).toString() != "null" ? (json['answerContent'] as String).split("_") : [""],
      answerOtherContent: json['otherContent'],
    );
  }
}