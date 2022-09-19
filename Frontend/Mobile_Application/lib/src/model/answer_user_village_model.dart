import 'package:fl_nynberapp/src/model/answer_user_model.dart';
import 'package:fl_nynberapp/src/model/village_user_model.dart';

class AnswerUserVillage {
  List<AnswerUser> answerUser;
  VillageUser villageUser;
  AnswerUserVillage({this.answerUser, this.villageUser});
  factory AnswerUserVillage.fromJson(Map json) {
    return AnswerUserVillage(
      answerUser:  (json['answers'] as List).map( (p) => AnswerUser.fromJson(p)).toList(),
      villageUser: VillageUser.fromJson(json['village']) 
    );
  }
}
