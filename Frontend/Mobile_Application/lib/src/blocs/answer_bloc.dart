import 'dart:io';

import 'package:fl_nynberapp/src/api/api_auth.dart';
import 'package:fl_nynberapp/src/model/answer_user_model.dart';
import 'package:fl_nynberapp/src/model/answer_user_village_model.dart';
import 'package:fl_nynberapp/src/model/survey_status_model.dart';

class AnswerBloc {
  var _apiAuth = ApiAuth();
  Future<AnswerUserVillage> uploadImageGetInfoVillageAndAnswer(
      File imageFile1, Function onSuccess, Function(String) onError) async {
    return _apiAuth.uploadImageGetInfoVillageAndAnswer(
        imageFile1, onSuccess, onError);
  }

  Future<bool> resetUserSurvey(
      Function onSuccess, Function(String) onError) async {
    return _apiAuth.resetUserSurvey(onSuccess, onError);
  }

  submitAnswerUser(
      List<AnswerUser> lsAnswerUser,
      int activeID,
      Function onSuccess,
      Function(String) onSubmitAnswerUserError,
      String typeSubmit) {
    _apiAuth.submitAnswerUser(
        lsAnswerUser, activeID, onSuccess, onSubmitAnswerUserError, typeSubmit);
  }
}
