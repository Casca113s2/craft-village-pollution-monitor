import 'package:fl_nynberapp/src/api/api_auth.dart';
import 'package:fl_nynberapp/src/model/completed_model.dart';
import 'package:fl_nynberapp/src/model/inprogress_model.dart';
import 'package:fl_nynberapp/src/model/survey_answer_user_by_id.dart';
import 'package:fl_nynberapp/src/model/survey_status_model.dart';

class SurveyBloc {
  var _apiAuth = ApiAuth();

  Future<bool> checkSurveyInProgress(
      Function onSuccess, Function(String) onError) async {
    return _apiAuth.checkSurveyInProgress(onSuccess, onError);
  }

  Future<SurveyAnswerUserByID> fetchSurveyAnswerByImage(
      int id, Function onSuccess, Function(String) onError) async {
    return _apiAuth.fetchSurveyAnswerByImage(id, onSuccess, onError);
  }

  Future<SurveyAnswerUserByID> fetchSurveyAnswerUserByID(int id,
      int usersurveyid, Function onSuccess, Function(String) onError) async {
    return _apiAuth.fetchSurveyAnswerUserByID(
        id, usersurveyid, onSuccess, onError);
  }

  // Future<List<SurveysInProgressModel>> fetchSurveysInProgress(
  //     Function onSuccess, Function(String) onError) async {
  //   return _apiAuth.fetchSurveysInProgress(onSuccess, onError);
  // }

  fetchSurveysInProgress(
      String token, Function onSuccess, Function(String) onError) async {
    return _apiAuth.fetchSurveysInProgress(token, onSuccess, onError);
  }

  Future<List<SurveysCompletedModel>> fetchSurveysCompleted(
      String token, Function onSuccess, Function(String) onError) async {
    return _apiAuth.fetchSurveysCompleted(token, onSuccess, onError);
  }

  Future<SurveyStatus> fetchSurvey(
      Function onSuccess, Function(String) onError) async {
    return _apiAuth.fetchSurvey(onSuccess, onError);
  }
}
