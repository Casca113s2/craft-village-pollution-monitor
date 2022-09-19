class ConstantParameter {
  static String _SCHEMA_NAME = "DB_CRAFTVILLAGE";
  static String _URL_BACKEND = "craftvillage";
  // static String _URL_ROOT = "192.168.3.179";
  static String _URL_ROOT = "192.168.1.10";
  static String _URL_API = "api";
  static String _PORT_ROOT = "5050";
  static String _IMAGE_PATH = "image";
  //static final ServiceAddress _a ;
  static ServiceAddress _ADDRESS;
  static ServiceImage _IMAGE;
  static ServiceSurvey _SURVEY;
  static ServiceAnswer _ANSWER;
  static ServiceUser _USER;
  static ServiceVillage _VILLAGE;

  //AI Service
  static String _AI_IP = "127.0.0.1";
  static String _AI_PORT = "8000";
  static String _AI_API = "detect";

  static String getAIAddressUrl() {
    return 
        "http://" +
        _AI_IP +
        ":" +
        _AI_PORT +
        "/" +
        _AI_API;
  }
  //END AI

  ConstantParameter(
      String schemaName,
      String urlBackend,
      String urlRoot,
      String urlApi,
      String portRoot,
      String imagePath,
      ServiceAddress address,
      ServiceImage image,
      ServiceSurvey survey,
      ServiceAnswer answer,
      ServiceUser user,
      ServiceVillage village) {
    if (_SCHEMA_NAME != schemaName) _SCHEMA_NAME = schemaName;
    if (_URL_BACKEND != urlBackend) _URL_BACKEND = urlBackend;
    if (_URL_ROOT != urlRoot) _URL_ROOT = urlRoot;
    if (_URL_API != urlApi) _URL_API = urlApi;
    if (_PORT_ROOT != portRoot) _PORT_ROOT = portRoot;
    if (_IMAGE_PATH != imagePath) _IMAGE_PATH = imagePath;
    if (_ADDRESS != address) _ADDRESS = address;
    if (_IMAGE != image) _IMAGE = image;
    if (_SURVEY != survey) _SURVEY = survey;
    if (_ANSWER != answer) _ANSWER = answer;
    if (_USER != user) _USER = user;
    if (_VILLAGE != village) _VILLAGE = village;
  }
  factory ConstantParameter.fromJson(Map json) {
    return ConstantParameter(
      json['schema_name'],
      json['backend_url'],
      json['root_url'],
      json['root_api'],
      json['root_port'],
      json['path_image'],
      ServiceAddress.fromJson(json['address']),
      ServiceImage.fromJson(json['image']),
      ServiceSurvey.fromJson(json['survey']),
      ServiceAnswer.fromJson(json['answer']),
      ServiceUser.fromJson(json['user']),
      ServiceVillage.fromJson(json['village']),
    );
  }
  static String getImagePath(String rootpath, String username) {
    String pathFile = rootpath + _IMAGE_PATH + "/" + username + "/";
    return pathFile;
  }

  static String getAddressUrl() {
    return _URL_ROOT +
        ":" +
        _PORT_ROOT +
        "/" +
        _URL_BACKEND +
        "/" +
        _URL_API +
        "/";
  }
}

class ServiceAddress {
  static String _ADDRESS_SERVICE = "address";
  static String _ADDRESS_GET_COUNTRY = "getcountrylist";
  static String _ADDRESS_GET_PROVINCE = "getprovincelist";
  static String _ADDRESS_GET_DISTRICT = "getdistrictlist";
  static String _ADDRESS_GET_WARD = "getwardlist";
  static String _ADDRESS_GET_VILLAGE = "getvillage";
  static String _ADDRESS_CHECK_VILLAGE = "checkvillage";
  static String _ADDRESS_GET_ADDRESS = "getaddress";
  ServiceAddress(
      String service,
      String getCountry,
      String getProvice,
      String getDistrict,
      String getWard,
      String getVillage,
      String checkVillage,
      String getAddress) {
    if (_ADDRESS_SERVICE != service) _ADDRESS_SERVICE = service;
    if (_ADDRESS_GET_COUNTRY != getCountry) _ADDRESS_GET_COUNTRY = getCountry;
    if (_ADDRESS_GET_PROVINCE != getProvice) _ADDRESS_GET_PROVINCE = getProvice;
    if (_ADDRESS_GET_DISTRICT != getDistrict)
      _ADDRESS_GET_DISTRICT = getDistrict;
    if (_ADDRESS_GET_WARD != getWard) _ADDRESS_GET_WARD = getWard;
    if (_ADDRESS_GET_VILLAGE != getVillage) _ADDRESS_GET_VILLAGE = getVillage;
    if (_ADDRESS_CHECK_VILLAGE != checkVillage)
      _ADDRESS_CHECK_VILLAGE = checkVillage;
    if (_ADDRESS_GET_ADDRESS != getAddress) _ADDRESS_GET_ADDRESS = getAddress;
  }
  factory ServiceAddress.fromJson(Map json) {
    return ServiceAddress(
      json['service'],
      json['get_country'],
      json['get_province'],
      json['get_district'],
      json['get_ward'],
      json['get_village'],
      json['check_village'],
      json['get_address'],
    );
  }
  static String getCountry() {
    return "$_ADDRESS_SERVICE/$_ADDRESS_GET_COUNTRY";
  }

  static String getProvice() {
    return "$_ADDRESS_SERVICE/$_ADDRESS_GET_PROVINCE";
  }

  static String getDistrict() {
    return "$_ADDRESS_SERVICE/$_ADDRESS_GET_DISTRICT";
  }

  static String getWard() {
    return "$_ADDRESS_SERVICE/$_ADDRESS_GET_WARD";
  }

  static String getVillage() {
    return "$_ADDRESS_SERVICE/$_ADDRESS_GET_VILLAGE";
  }

  static String checkVillage() {
    return "$_ADDRESS_SERVICE/$_ADDRESS_CHECK_VILLAGE";
  }

  static String getAddress() {
    return "$_ADDRESS_SERVICE/$_ADDRESS_GET_ADDRESS";
  }
}

class ServiceImage {
  static String _IMAGE_SERVICE = "image";
  static String _IMAGE_GET_PICTURE = "getpicture";
  static String _IMAGE_DEL_PICTURE = "deletepicture";
  ServiceImage(String service, String getPicture, String delPicture) {
    if (_IMAGE_SERVICE != service) _IMAGE_SERVICE = service;
    if (_IMAGE_GET_PICTURE != getPicture) _IMAGE_GET_PICTURE = getPicture;
    if (_IMAGE_DEL_PICTURE != delPicture) _IMAGE_DEL_PICTURE = delPicture;
  }
  factory ServiceImage.fromJson(Map json) {
    return ServiceImage(
      json['service'],
      json['get_picture'],
      json['del_picture'],
    );
  }
  static String getPicture() {
    return "$_IMAGE_SERVICE/$_IMAGE_GET_PICTURE";
  }

  static String delPicture() {
    return "$_IMAGE_SERVICE/$_IMAGE_DEL_PICTURE";
  }
}

class ServiceSurvey {
  static String _SURVEY_SERVICE = "survey";
  static String _SURVEY_GET_ALL_SURVEY = "allsurvey";
  static String _SURVEY_GET_ACTIVE_INFOR = "surveyactiveinfo";
  static String _SURVEY_GET_SURVEY_BYSTATUS = "surveystatus";
  static String _SURVEY_GET_SURVEY_BYID = "survey";
  static String _SURVEY_GET_STATUS_SURVEY = "getstatus";

  ServiceSurvey(
    String service,
    String getAllSurvey,
    String getActiveInfor,
    String getSurveyByStatus,
    String getSurveyByID,
    String getStatusSurvey,
  ) {
    if (_SURVEY_SERVICE != service) _SURVEY_SERVICE = service;
    if (_SURVEY_GET_ALL_SURVEY != getAllSurvey)
      _SURVEY_GET_ALL_SURVEY = getAllSurvey;
    if (_SURVEY_GET_ACTIVE_INFOR != getActiveInfor)
      _SURVEY_GET_ACTIVE_INFOR = getActiveInfor;
    if (_SURVEY_GET_SURVEY_BYSTATUS != getSurveyByStatus)
      _SURVEY_GET_SURVEY_BYSTATUS = getSurveyByStatus;
    if (_SURVEY_GET_SURVEY_BYID != getSurveyByID)
      _SURVEY_GET_SURVEY_BYID = getSurveyByID;
    if (_SURVEY_GET_STATUS_SURVEY != getStatusSurvey)
      _SURVEY_GET_STATUS_SURVEY = getStatusSurvey;
  }
  factory ServiceSurvey.fromJson(Map json) {
    return ServiceSurvey(
      json['service'],
      json['get_all_Survey'],
      json['get_active_infor'],
      json['get_survey_by_status'],
      json['get_survey_by_id'],
      json['get_status_survey'],
    );
  }
  static String getAllSurvey() {
    return "$_SURVEY_SERVICE/$_SURVEY_GET_ALL_SURVEY";
  }

  static String getActiveInfor() {
    return "$_SURVEY_SERVICE/$_SURVEY_GET_ACTIVE_INFOR";
  }

  static String getSurveyByStatus() {
    return "$_SURVEY_SERVICE/$_SURVEY_GET_SURVEY_BYSTATUS";
  }

  static String getSurveyByID() {
    return "$_SURVEY_SERVICE/$_SURVEY_GET_SURVEY_BYID";
  }

  static String getStatusSurvey() {
    return "$_SURVEY_SERVICE/$_SURVEY_GET_STATUS_SURVEY";
  }
}

class ServiceAnswer {
  static String _ANSWER_SERVICE = "answer";
  static String _ANSWER_GET_ANSWER = "getanswer";
  static String _ANSWER_GET_COMPLETED = "answercompleted";
  static String _ANSWER_GET_INPROGRESS = "answerinprogress";
  static String _ANSWER_RESET_SURVEY = "resetusersurvey";
  static String _ANSWER_UPLOAD_FILE = "uploadfile";

  ServiceAnswer(
    String service,
    String getAnswer,
    String answerCompleted,
    String answerInprogress,
    String resetUserSurvey,
    String uploadFile,
  ) {
    if (_ANSWER_SERVICE != service) _ANSWER_SERVICE = service;
    if (_ANSWER_GET_ANSWER != getAnswer) _ANSWER_GET_ANSWER = getAnswer;
    if (_ANSWER_GET_COMPLETED != answerCompleted)
      _ANSWER_GET_COMPLETED = answerCompleted;
    if (_ANSWER_GET_INPROGRESS != answerInprogress)
      _ANSWER_GET_INPROGRESS = answerInprogress;
    if (_ANSWER_RESET_SURVEY != resetUserSurvey)
      _ANSWER_RESET_SURVEY = resetUserSurvey;
    if (_ANSWER_UPLOAD_FILE != uploadFile) _ANSWER_UPLOAD_FILE = uploadFile;
  }
  factory ServiceAnswer.fromJson(Map json) {
    return ServiceAnswer(
      json['service'],
      json['get_answer'],
      json['answer_completed'],
      json['answer_inprogress'],
      json['reset_user_survey'],
      json['upload_file'],
    );
  }
  static String getAnswer() {
    return "$_ANSWER_SERVICE/$_ANSWER_GET_ANSWER";
  }

  static String answerCompleted() {
    return "$_ANSWER_SERVICE/$_ANSWER_GET_COMPLETED";
  }

  static String answerInprogress() {
    return "$_ANSWER_SERVICE/$_ANSWER_GET_INPROGRESS";
  }

  static String resetUserSurvey() {
    return "$_ANSWER_SERVICE/$_ANSWER_RESET_SURVEY";
  }

  static String uploadFile() {
    return "$_ANSWER_SERVICE/$_ANSWER_UPLOAD_FILE";
  }
}

class ServiceUser {
  static String _USER_SERVICE = "user";
  static String _USER_LOGOUT_TEST = "logoutapptest";
  static String _USER_LOGOUT = "logoutapp";
  static String _USER_LOGIN = "loginapp";
  static String _USER_REGISTER = "register";
  static String _USER_GET_DATA = "data";
  static String _USER_CHANGE_PASS = "changepass";
  static String _USER_FORGOTTEN_PASS = "forgetpass";
  static String _USER_UPDATE_INFOR = "updateuser";
  static String _USER_GET_PASSWORD = "getpass";
  static String _USER_SEND_EMAIL = "sendmail";
  static String _USER_ACTIVATE = "activeuser";
  ServiceUser(
    String service,
    String logoutAppTest,
    String logoutApp,
    String loginApp,
    String register,
    String data,
    String changePass,
    String forgetPass,
    String updateUser,
    String getPass,
    String sendMail,
    String activeUser,
  ) {
    if (_USER_SERVICE != service) _USER_SERVICE = service;
    if (_USER_LOGOUT_TEST != logoutAppTest) _USER_LOGOUT_TEST = logoutAppTest;
    if (_USER_LOGOUT != logoutApp) _USER_LOGOUT = logoutApp;
    if (_USER_LOGIN != loginApp) _USER_LOGIN = loginApp;
    if (_USER_REGISTER != register) _USER_REGISTER = register;
    if (_USER_GET_DATA != data) _USER_GET_DATA = data;
    if (_USER_CHANGE_PASS != changePass) _USER_CHANGE_PASS = changePass;
    if (_USER_FORGOTTEN_PASS != forgetPass) _USER_FORGOTTEN_PASS = forgetPass;
    if (_USER_UPDATE_INFOR != updateUser) _USER_UPDATE_INFOR = updateUser;
    if (_USER_GET_PASSWORD != getPass) _USER_GET_PASSWORD = getPass;
    if (_USER_SEND_EMAIL != sendMail) _USER_SEND_EMAIL = sendMail;
    if (_USER_ACTIVATE != activeUser) _USER_ACTIVATE = activeUser;
  }

  factory ServiceUser.fromJson(Map json) {
    return ServiceUser(
      json['service'],
      json['logout_app_test'],
      json['logout_app'],
      json['login_app'],
      json['register'],
      json['data'],
      json['change_pass'],
      json['forget_pass'],
      json['update_user'],
      json['get_pass'],
      json['send_mail'],
      json['active_user'],
    );
  }

  static String logoutAppTest() {
    return "$_USER_SERVICE/$_USER_LOGOUT_TEST";
  }

  static String logoutApp() {
    return "$_USER_SERVICE/$_USER_LOGOUT";
  }

  static String loginApp() {
    return "$_USER_SERVICE/$_USER_LOGIN";
  }

  static String register() {
    return "$_USER_SERVICE/$_USER_REGISTER";
  }

  static String data() {
    return "$_USER_SERVICE/$_USER_GET_DATA";
  }

  static String changePass() {
    return "$_USER_SERVICE/$_USER_CHANGE_PASS";
  }

  static String forgetPass() {
    return "$_USER_SERVICE/$_USER_FORGOTTEN_PASS";
  }

  static String updateUser() {
    return "$_USER_SERVICE/$_USER_UPDATE_INFOR";
  }

  static String getPass() {
    return "$_USER_SERVICE/$_USER_GET_PASSWORD";
  }

  static String sendMail() {
    return "$_USER_SERVICE/$_USER_SEND_EMAIL";
  }

  static String activeUser() {
    return "$_USER_SERVICE/$_USER_ACTIVATE";
  }
}

class ServiceVillage {
  static String _VILLAGE_SERVICE = "village";
  static String _VILLAGE_SUBMIT = "submitvillage";
  static String _VILLAGE_GET_INFOR = "getvillageinfo";
  static String _VILLAGE_GET_SURVEY = "getvillagesurvey";
  static String _VILLAGE_DETECT = "detectvillage";

  ServiceVillage(String service, String submitVillage, String getVillageInfo,
      String getVillageSurvey, String detectVillage) {
    if (_VILLAGE_SERVICE != service) 
      _VILLAGE_SERVICE = service;

    if (_VILLAGE_SUBMIT != submitVillage) 
      _VILLAGE_SUBMIT = submitVillage;

    if (_VILLAGE_GET_INFOR != getVillageInfo)
      _VILLAGE_GET_INFOR = getVillageInfo;

    if (_VILLAGE_GET_SURVEY != getVillageSurvey)
      _VILLAGE_GET_SURVEY = getVillageSurvey;

    //print("TEST::"+detectVillage);
    if (_VILLAGE_DETECT != detectVillage)
      _VILLAGE_DETECT = detectVillage;
  }

  factory ServiceVillage.fromJson(Map json) {
    return ServiceVillage(
      json['service'],
      json['submit_village'],
      json['get_village_info'],
      json['get_village_survey'],
      json['detect_village'],
    );
  }

  //Detect location
  static String detectVillage() {
    return "$_VILLAGE_SERVICE/$_VILLAGE_DETECT";
  }

  static String submitVillage() {
    return "$_VILLAGE_SERVICE/$_VILLAGE_SUBMIT";
  }

  static String getVillageInfo() {
    return "$_VILLAGE_SERVICE/$_VILLAGE_GET_INFOR";
  }

  static String getVillageSurvey() {
    return "$_VILLAGE_SERVICE/$_VILLAGE_GET_SURVEY";
  }
}
