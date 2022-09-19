import 'package:excel/excel.dart';

class LanguageConfig {
  //home_page()
  static String _NOTICE = "Thông báo";
  static String _RELOGIN = "Vui lòng đăng nhập lại";
  static String _OK = "Đồng ý";
  static String _HOUSE_HOLD = "Hộ gia đình";
  static String _LOCAL_AUTHORITY = "Chính quyền địa phương";
  static String _PRIVATE_PERSON = "Người riêng tư";
  static String _MY_TASKS = "Nhiệm vụ của tôi";
  static String _LOADING = "Đang tải…";
  static String _NEW_SURVEY = "Khảo sát mới";
  static String _NEW_SURVEY_TITLE = "Khảo sát làng nghề ngay bây giờ";
  static String _IN_PROGRESS = "Trong tiến trình";
  static String _IN_PROGRESS_TITLE = "Những khảo sát cần được hoàn thiện";
  static String _IN_PROGRESS_SURVEYS = "Những tiến trình đang khảo sát";

  static String _COMPLETED = "Hoàn thành";
  static String _COMPLETED_TITLE = "Những khảo sát đã hoàn thành";
  static String _ACHIEVEMENT = "Thành tựu";

  static String _NEW_SURVEY_SUBTITLE = "Số câu trả lời trên số câu hỏi";
  static String _ACHIEVEMENT_SUBTITLE = "Số làng nghề đã khảo sát được";
  static String _NO_INTERNET =
      "Không có kết nối internet, Vui lòng mở và thử lại";
  static String _NO_INTERNET_TOOLTIP = "Không có kết nối internet";
  static String _CANCEL = "Hủy bỏ";
  static String _CHANGE_GROUP = "Đổi nhóm";
  static String _SKIP_AND_SURVEY = "Bỏ qua và khảo sát";
  static String _PROCESSING = "Đang xử lý..";
  static String _NOTICE_CHANGE_GROUP =
      "Bạn đang ở nhóm {type}, bạn có muốn đổi sang nhóm khác để tiếp tục khảo sát không?";
  static String _COME_INPROGRESS = "Đến tiến trình";
  static String _REMOVE_INPROGRESS =
      "Bạn đã có một khảo sát ở 'Trong tiến trình', bạn có muốn xóa khảo sát cũ và tạo khảo sát mới không?";

  //end home_page()
  //surveys_in_progress_page()
  static String _LIST_SURVEYS_INPROGRESS = "Danh sách các khảo sát lưu tạm";
  static String _GROUP_USING = "Nhóm đang sử dụng: {typeUser}";
  static String _NO_SAVE_DRAFT = "Hiện tại không tìm ra bản lưu tạm nào";
  static String _EDIT_AND_REMOVE_NOTICE =
      "(*)Người dùng chỉ có thể sửa đổi hoặc xóa khảo sát khi đã thay đổi nhóm người dùng tương ứng với khảo sát đó";
  static String _VILLAGE_NAME = "Tên làng nghề: {villageName}";
  static String _NUMBER_OF_MAIN_QUESTION = "Số câu hỏi chính: {mainQuestion}";
  static String _NUMBER_OF_MAIN_ANSWER = "Số câu trả lời chính: {mainAnswer}";
  static String _NUMBER_IMAGE = "Số ảnh: {numberImage}";
  static String _TYPE_SURVEY = "Loại khảo sát: {typeSurvey}";
  static String _CONTINUE_SURVEY = "Tiếp tục khảo sát";
  static String _CONTINUE_SURVEY_NOTICE =
      "Bạn có muốn tiếp tục khảo sát này hay không?";
  static String _REMOVE_SURVEY = "Đã xóa thành công";
  static String _REMOVE_SURVEY_NOTICE =
      "Bạn có chắc muốn xóa khảo sát này không?";
  static String _REMOVE = "Xóa";
  //end surveys_in_progress_page()

  //surveys_completed_page()
  static String _LIST_SURVEYS_COMPLETED =
      "Danh sách các khảo sát đã hoàn thành";
  static String _NO_COMPLETED = "Hiện tại không tìm ra khảo sát hoàn thành nào";
  //end surveys_completed_page()

  //details_user_page()
  static String _DETAIL_USER = "Thông tin người dùng";
  static String _USERNAME = "Tên đăng nhập";
  static String _LASTNAME = "Họ đệm";
  static String _FIRSTNAME = "Tên";
  static String _PHONE_NUMBER = "Số điện thoại";
  static String _BIRTHDAY = "Ngày sinh";
  static String _EMAIL = "Địa chỉ email";
  static String _CONFIRMED_EMAIL = "(*) Email đã được xác nhận";
  static String _UNCONFIRMED_EMAIL =
      "(*) Email chưa xác nhận nên không thể thay đổi loại người dùng, bấm vào đây để xác nhận email";
  static String _UPDATING = "Đang cập nhật..";
  static String _CONFIRMED_UPDATE = "Cập nhật thành công";
  static String _INFO = "Thông tin";
  static String _ACTIVE_CODE_NOTICE = "Nhập mã ";
  static String _ACTIVE = "Xác nhận";
  static String _WRONG_CODE = "Sai mã xác nhận";
  static String _UPDATE = "Cập nhật";
  static String _CONTINUE = "Tiếp tục";
  //end details_user_page()

  //craft_page()
  static String _INPUT_INFO = "Thông tin sản phẩm và đầu vào";
  static String _WAITING = "Đang tải nội dung";
  static String _SUBMIT = "Xác nhận";
  static String _WAITING_2 = "Đang tải..xin hãy chờ";
  static String _ADD_MORE_INFO = "Vui lòng nhập thêm thông tin";
  static String _COMPLETED_INFO =
      "Khảo sát đã được lưu lại thành công. Bạn có thể xem lại kết quả khảo sát tại mục Completed survey.";
  static String _SAVE_DRAFT = "Lưu tạm";
  static String _SAVE_DRAFT_INFO =
      "Khảo sát hiện tại đã được lưu dữ liệu tạm thời. Có thể xem lại và tiếp tục khảo sát tại mục InProgress.";
  static String _WARNING_SUBMIT =
      "Vui lòng điền đầy đủ thông tin chung của làng nghề";
  static String _SUGGESTION =
      "(*) Nếu bạn chụp ảnh, thông tin bên dưới sẽ được gợi ý.";
  static String _CURRENT_GROUP = "Nhóm đang sử dụng: {typeUser}";
  static String _GENERAL_INFO = "Thông tin chung (*)";
  static String _PICK_PROVINCE = "Chọn Tỉnh/Thành Phố";
  static String _PICK_DISTRICT = "Chọn Quận/Huyện";
  static String _PICK_WARD = "Chọn Xã/Phường";
  static String _PICK_VILLAGE = "Chọn Làng Nghề";
  static String _INVESTIGATED = "Làng nghề này đã khảo sát";
  static String _DESCRIPTION_VILLAGE = "Mô tả làng nghề";
  static String _OPTION = "Lựa chọn";
  static String _TAKE_PHOTO = "Chụp ảnh";
  static String _SUGGESTION_VILLAGE =
      "Tạm thời chưa tìm ra làng nghề gần bạn, vui lòng thêm làng nghề mới.";
  static String _ADD_VILLAGE = "Thêm làng nghề";
  static String _WARNING_REMOVE_IMAGE = "Lỗi khi xóa ảnh";
  static String _REMOVE_IMAGE = "Bạn có chắc chắn muốn xóa ảnh này hay không?";
  static String _LOADING_GMAP = "Đang tải bản đồ…";
  static String _LATITUDE = "Vĩ độ";
  static String _LONGTITUDE = "Kinh độ";
  static String _CURRENT_POSITION = "Vị trí hiện tại";
  static String _PICK_VILLAGE_FROM_MAP =
      "Bạn có muốn chọn làng nghề {villageName} không?";
  static String _SUGGEST_POSITION_NOTICE = "Vui lòng chọn ảnh đã bật định vị";
  static String _PICK = "Chọn";
  //end craft_page()

  //change_password_page()

  static String _CHANGE_PASSWORD = "Đổi mật khẩu";
  static String _OLD_PASSWORD = "Mật khẩu cũ";
  static String _NEW_PASSWORD = "Mật khẩu mới";
  static String _RE_PASSWORD = "Nhập lại mật khẩu";
  static String _CHANGE_PASSWORD_INFO = "Đổi mật khẩu thành công";

  //end change_password_page()

  //help_custom()

  static String _LOGOUT = "Đăng xuất";

  //end help_custom()
  LanguageConfig(String languageName, Excel excel) {
    for (var table in excel.tables.keys) {
      // print(table); //sheet Name
      // print(excel.tables[table].maxCols);
      // print(excel.tables[table].maxRows);

      var rowTable = excel.tables[table].rows[0];
      int indexLanguageCode;
      for (int i = 0; i < rowTable.length; i++) {
        if (rowTable[i].value == languageName) {
          indexLanguageCode = i;
          break;
        }
      }
      for (int i = 1; i < excel.tables[table].rows.length; i++) {
        List<Data> row = excel.tables[table].rows[i];
        if (row[0].value == "notice") _NOTICE = row[indexLanguageCode].value;
        if (row[0].value == "relogin") _RELOGIN = row[indexLanguageCode].value;
        if (row[0].value == "ok") _OK = row[indexLanguageCode].value;
        if (row[0].value == "house_hold")
          _HOUSE_HOLD = row[indexLanguageCode].value;
        if (row[0].value == "local_authority")
          _LOCAL_AUTHORITY = row[indexLanguageCode].value;
        if (row[0].value == "private_person")
          _PRIVATE_PERSON = row[indexLanguageCode].value;
        if (row[0].value == "my_tasks") _MY_TASKS = row[indexLanguageCode].value;
        if (row[0].value == "loading") _LOADING = row[indexLanguageCode].value;
        if (row[0].value == "new_survey")
          _NEW_SURVEY = row[indexLanguageCode].value;
        if (row[0].value == "new_survey_title")
          _NEW_SURVEY_TITLE = row[indexLanguageCode].value;
        if (row[0].value == "in_progress")
          _IN_PROGRESS = row[indexLanguageCode].value;
        if (row[0].value == "in_progress_title")
          _IN_PROGRESS_TITLE = row[indexLanguageCode].value;
        if (row[0].value == "completed")
          _COMPLETED = row[indexLanguageCode].value;
        if (row[0].value == "completed_title")
          _COMPLETED_TITLE = row[indexLanguageCode].value;

        if (row[0].value == "achievement")
          _ACHIEVEMENT = row[indexLanguageCode].value;
        if (row[0].value == "new_survey_subtitle")
          _NEW_SURVEY_SUBTITLE = row[indexLanguageCode].value;
        if (row[0].value == "achievement_subtitle")
          _ACHIEVEMENT_SUBTITLE = row[indexLanguageCode].value;
        if (row[0].value == "no_internet")
          _NO_INTERNET = row[indexLanguageCode].value;
        if (row[0].value == "no_internet_tooltip")
          _NO_INTERNET_TOOLTIP = row[indexLanguageCode].value;
        if (row[0].value == "cancel") _CANCEL = row[indexLanguageCode].value;
        if (row[0].value == "change_group")
          _CHANGE_GROUP = row[indexLanguageCode].value;
        if (row[0].value == "skip_and_survey")
          _SKIP_AND_SURVEY = row[indexLanguageCode].value;
        if (row[0].value == "processing")
          _PROCESSING = row[indexLanguageCode].value;
        if (row[0].value == "notice_change_group")
          _NOTICE_CHANGE_GROUP = row[indexLanguageCode].value;
        if (row[0].value == "in_progress_surveys")
          _IN_PROGRESS_SURVEYS = row[indexLanguageCode].value;
        if (row[0].value == "come_inprogress")
          _COME_INPROGRESS = row[indexLanguageCode].value;
        if (row[0].value == "remove_inprogress")
          _REMOVE_INPROGRESS = row[indexLanguageCode].value;
        //end

        if (row[0].value == "list_surveys_inprogress")
          _LIST_SURVEYS_INPROGRESS = row[indexLanguageCode].value;
        if (row[0].value == "group_using")
          _GROUP_USING = row[indexLanguageCode].value;
        if (row[0].value == "no_save_draft")
          _NO_SAVE_DRAFT = row[indexLanguageCode].value;
        if (row[0].value == "edit_and_remove_notice")
          _EDIT_AND_REMOVE_NOTICE = row[indexLanguageCode].value;
        if (row[0].value == "village_name")
          _VILLAGE_NAME = row[indexLanguageCode].value;
        if (row[0].value == "number_of_main_question")
          _NUMBER_OF_MAIN_QUESTION = row[indexLanguageCode].value;
        if (row[0].value == "number_of_main_answer")
          _NUMBER_OF_MAIN_ANSWER = row[indexLanguageCode].value;
        if (row[0].value == "number_image")
          _NUMBER_IMAGE = row[indexLanguageCode].value;
        if (row[0].value == "type_survey")
          _TYPE_SURVEY = row[indexLanguageCode].value;
        if (row[0].value == "continue_survey")
          _CONTINUE_SURVEY = row[indexLanguageCode].value;
        if (row[0].value == "continue_survey_notice")
          _CONTINUE_SURVEY_NOTICE = row[indexLanguageCode].value;
        if (row[0].value == "remove_survey")
          _REMOVE_SURVEY = row[indexLanguageCode].value;
        if (row[0].value == "remove_survey_notice")
          _REMOVE_SURVEY_NOTICE = row[indexLanguageCode].value;
        if (row[0].value == "remove") _REMOVE = row[indexLanguageCode].value;

        //end

        if (row[0].value == "list_surveys_completed")
          _LIST_SURVEYS_COMPLETED = row[indexLanguageCode].value;
        if (row[0].value == "no_completed")
          _NO_COMPLETED = row[indexLanguageCode].value;

        //end

        if (row[0].value == "detail_user")
          _DETAIL_USER = row[indexLanguageCode].value;
        if (row[0].value == "username") _USERNAME = row[indexLanguageCode].value;
        if (row[0].value == "lastname") _LASTNAME = row[indexLanguageCode].value;
        if (row[0].value == "firstname")
          _FIRSTNAME = row[indexLanguageCode].value;
        if (row[0].value == "phone_number")
          _PHONE_NUMBER = row[indexLanguageCode].value;
        if (row[0].value == "birthday") _BIRTHDAY = row[indexLanguageCode].value;
        if (row[0].value == "email") _EMAIL = row[indexLanguageCode].value;
        if (row[0].value == "confirmed_email")
          _CONFIRMED_EMAIL = row[indexLanguageCode].value;
        if (row[0].value == "unconfirmed_email")
          _UNCONFIRMED_EMAIL = row[indexLanguageCode].value;
        if (row[0].value == "updating") _UPDATING = row[indexLanguageCode].value;
        if (row[0].value == "confirmed_update")
          _CONFIRMED_UPDATE = row[indexLanguageCode].value;
        if (row[0].value == "info") _INFO = row[indexLanguageCode].value;
        if (row[0].value == "active_code_notice")
          _ACTIVE_CODE_NOTICE = row[indexLanguageCode].value;
        if (row[0].value == "active") _ACTIVE = row[indexLanguageCode].value;
        if (row[0].value == "wrong_code")
          _WRONG_CODE = row[indexLanguageCode].value;
        if (row[0].value == "update") _UPDATE = row[indexLanguageCode].value;
        if (row[0].value == "continue") _CONTINUE = row[indexLanguageCode].value;

        //end
        if (row[0].value == "input_info")
          _INPUT_INFO = row[indexLanguageCode].value;
        if (row[0].value == "waiting") _WAITING = row[indexLanguageCode].value;
        if (row[0].value == "submit") _SUBMIT = row[indexLanguageCode].value;
        if (row[0].value == "waiting_2")
          _WAITING_2 = row[indexLanguageCode].value;
        if (row[0].value == "add_more_info")
          _ADD_MORE_INFO = row[indexLanguageCode].value;
        if (row[0].value == "completed_info")
          _COMPLETED_INFO = row[indexLanguageCode].value;
        if (row[0].value == "save_draft")
          _SAVE_DRAFT = row[indexLanguageCode].value;
        if (row[0].value == "save_draft_info")
          _SAVE_DRAFT_INFO = row[indexLanguageCode].value;
        if (row[0].value == "warning_submit")
          _WARNING_SUBMIT = row[indexLanguageCode].value;
        if (row[0].value == "suggestion")
          _SUGGESTION = row[indexLanguageCode].value;
        if (row[0].value == "current_group")
          _CURRENT_GROUP = row[indexLanguageCode].value;
        if (row[0].value == "general_info")
          _GENERAL_INFO = row[indexLanguageCode].value;
        if (row[0].value == "pick_province")
          _PICK_PROVINCE = row[indexLanguageCode].value;
        if (row[0].value == "pick_district")
          _PICK_DISTRICT = row[indexLanguageCode].value;
        if (row[0].value == "pick_ward")
          _PICK_WARD = row[indexLanguageCode].value;
        if (row[0].value == "pick_village")
          _PICK_VILLAGE = row[indexLanguageCode].value;
        if (row[0].value == "investigated")
          _INVESTIGATED = row[indexLanguageCode].value;
        if (row[0].value == "description_village")
          _DESCRIPTION_VILLAGE = row[indexLanguageCode].value;
        if (row[0].value == "option") _OPTION = row[indexLanguageCode].value;
        if (row[0].value == "take_photo")
          _TAKE_PHOTO = row[indexLanguageCode].value;
        if (row[0].value == "suggestion_village")
          _SUGGESTION_VILLAGE = row[indexLanguageCode].value;
        if (row[0].value == "add_village")
          _ADD_VILLAGE = row[indexLanguageCode].value;
        if (row[0].value == "warning_remove_image")
          _WARNING_REMOVE_IMAGE = row[indexLanguageCode].value;
        if (row[0].value == "remove_image")
          _REMOVE_IMAGE = row[indexLanguageCode].value;
        if (row[0].value == "loading_gmap")
          _LOADING_GMAP = row[indexLanguageCode].value;
        if (row[0].value == "latitude") _LATITUDE = row[indexLanguageCode].value;
        if (row[0].value == "longtitude")
          _LONGTITUDE = row[indexLanguageCode].value;
        if (row[0].value == "current_position")
          _CURRENT_POSITION = row[indexLanguageCode].value;
        if (row[0].value == "pick_village_from_map")
          _PICK_VILLAGE_FROM_MAP = row[indexLanguageCode].value;
        if (row[0].value == "suggest_position_notice")
          _SUGGEST_POSITION_NOTICE = row[indexLanguageCode].value;
        if (row[0].value == "pick") _PICK = row[indexLanguageCode].value;

        if (row[0].value == "change_password")
          _CHANGE_PASSWORD = row[indexLanguageCode].value;
        if (row[0].value == "old_password")
          _OLD_PASSWORD = row[indexLanguageCode].value;
        if (row[0].value == "new_password")
          _NEW_PASSWORD = row[indexLanguageCode].value;
        if (row[0].value == "re_password")
          _RE_PASSWORD = row[indexLanguageCode].value;
        if (row[0].value == "change_password_info")
          _CHANGE_PASSWORD_INFO = row[indexLanguageCode].value;
        if (row[0].value == "logout") _LOGOUT = row[indexLanguageCode].value;
        //end
      }
      // for (var row in excel.tables[table].rows) {
      //   print("$row");
      // }
    }
  }
  static String getNotice() {
    return _NOTICE;
  }

  static String getRelogin() {
    return _RELOGIN;
  }

  static String getOK() {
    return _OK;
  }

  static String getHouseHold() {
    return _HOUSE_HOLD;
  }

  static String getLocalAuthority() {
    return _LOCAL_AUTHORITY;
  }

  static String getPrivatePerson() {
    return _PRIVATE_PERSON;
  }

  static String getMyTasks() {
    return _MY_TASKS;
  }

  static String getLoading() {
    return _LOADING;
  }

  static String getNewSurvey() {
    return _NEW_SURVEY;
  }

  static String getNewSurveyTitle() {
    return _NEW_SURVEY_TITLE;
  }

  static String getInProgress() {
    return _IN_PROGRESS;
  }

  static String getInProgressTile() {
    return _IN_PROGRESS_TITLE;
  }

  static String getCompleted() {
    return _COMPLETED;
  }

  static String getCompletedTitle() {
    return _COMPLETED_TITLE;
  }

  // 30/11/2020
  static String getAchievement() {
    return _ACHIEVEMENT;
  }

  static String getNewSurveySubtitle() {
    return _NEW_SURVEY_SUBTITLE;
  }

  static String getAchievementSubtitle() {
    return _ACHIEVEMENT_SUBTITLE;
  }

  static String getNoInternet() {
    return _NO_INTERNET;
  }

  static String getNoInternetTooltip() {
    return _NO_INTERNET_TOOLTIP;
  }

  static String getCancel() {
    return _CANCEL;
  }

  static String getChangeGroup() {
    return _CHANGE_GROUP;
  }

  static String getSkipAndSurvey() {
    return _SKIP_AND_SURVEY;
  }

  static String getProcessing() {
    return _PROCESSING;
  }

  static String getNoticeChangeGroup(String type) {
    return _NOTICE_CHANGE_GROUP.replaceAll("{type}", type);
  }

  static String getInProgressSurveys() {
    return _IN_PROGRESS_SURVEYS;
  }

  //end home page()

  //surveys_in_progress_page()

  static String getListSurveysInprogress() {
    return _LIST_SURVEYS_INPROGRESS;
  }

  static String getGroupUsing(String typeUser) {
    return _GROUP_USING.replaceAll("{typeUser}", typeUser);
  }

  static String getNoSaveDraft() {
    return _NO_SAVE_DRAFT;
  }

  static String getEditAndRemoveNotice() {
    return _EDIT_AND_REMOVE_NOTICE;
  }

  static String getVillageName(String villageName) {
    return _VILLAGE_NAME.replaceAll("{villageName}", villageName);
  }

  static String getNumberOfMainQuestion(String mainQuestion) {
    return _NUMBER_OF_MAIN_QUESTION.replaceAll("{mainQuestion}", mainQuestion);
  }

  static String getNumberOfMainAnswer(String mainAnswer) {
    return _NUMBER_OF_MAIN_ANSWER.replaceAll("{mainAnswer}", mainAnswer);
  }

  static String getNumberImage(String numberImage) {
    return _NUMBER_IMAGE.replaceAll("{numberImage}", numberImage);
  }

  static String getTypeSurvey(String typeSurvey) {
    return _TYPE_SURVEY.replaceAll("{typeSurvey}", typeSurvey);
  }

  static String getContinueSurvey() {
    return _CONTINUE_SURVEY;
  }

  static String getContinueSurveyNotice() {
    return _CONTINUE_SURVEY_NOTICE;
  }

  static String getRemoveSurvey() {
    return _REMOVE_SURVEY;
  }

  static String getRemoveSurveyNotice() {
    return _REMOVE_SURVEY_NOTICE;
  }

  //end surveys_in_progress_page()

  //surveys_completed_page()

  static String getListSurveysCompleted() {
    return _LIST_SURVEYS_COMPLETED;
  }

  static String getNoCompleted() {
    return _NO_COMPLETED;
  }

  //end surveys_completed_page()

  //details_user_page()

  static String getDetailUser() {
    return _DETAIL_USER;
  }

  static String getUsername() {
    return _USERNAME;
  }

  static String getLastname() {
    return _LASTNAME;
  }

  static String getFirstname() {
    return _FIRSTNAME;
  }

  static String getPhoneNumber() {
    return _PHONE_NUMBER;
  }

  static String getBirthday() {
    return _BIRTHDAY;
  }

  static String getEmail() {
    return _EMAIL;
  }

  static String getConfirmedEmail() {
    return _CONFIRMED_EMAIL;
  }

  static String getUnconfirmedEmail() {
    return _UNCONFIRMED_EMAIL;
  }

  static String getUpdating() {
    return _UPDATING;
  }

  static String getConfirmedUpdate() {
    return _CONFIRMED_UPDATE;
  }

  static String getInfo() {
    return _INFO;
  }

  static String getActiveCodeNotice() {
    return _ACTIVE_CODE_NOTICE;
  }

  static String getActive() {
    return _ACTIVE;
  }

  static String getWrongCode() {
    return _WRONG_CODE;
  }

  //end details_user_page()

  //craft_page()

  static String getInputInfo() {
    return _INPUT_INFO;
  }

  static String getWaiting() {
    return _WAITING;
  }

  static String getSubmit() {
    return _SUBMIT;
  }

  static String getWaiting2() {
    return _WAITING_2;
  }

  static String getAddMoreInfo() {
    return _ADD_MORE_INFO;
  }

  static String getCompletedInfo() {
    return _COMPLETED_INFO;
  }

  static String getSaveDraftInfo() {
    return _SAVE_DRAFT_INFO;
  }

  static String getWarningSubmit() {
    return _WARNING_SUBMIT;
  }

  static String getSuggestion() {
    return _SUGGESTION;
  }

  static String getCurrentGroup(String typeUser) {
    return _CURRENT_GROUP.replaceAll("{typeUser}", typeUser);
  }

  static String getGeneralInfo() {
    return _GENERAL_INFO;
  }

  static String getPickProvince() {
    return _PICK_PROVINCE;
  }

  static String getPickDistrict() {
    return _PICK_DISTRICT;
  }

  static String getPickWard() {
    return _PICK_WARD;
  }

  static String getPickVillage() {
    return _PICK_VILLAGE;
  }

  static String getInvestigated() {
    return _INVESTIGATED;
  }

  static String getDescriptionVillage() {
    return _DESCRIPTION_VILLAGE;
  }

  static String getOption() {
    return _OPTION;
  }

  static String getTakePhoto() {
    return _TAKE_PHOTO;
  }

  static String getSuggestionVillage() {
    return _SUGGESTION_VILLAGE;
  }

  static String getAddVillage() {
    return _ADD_VILLAGE;
  }

  static String getWarningRemoveImage() {
    return _WARNING_REMOVE_IMAGE;
  }

  static String getRemoveImage() {
    return _REMOVE_IMAGE;
  }

  static String getLoadingGmap() {
    return _LOADING_GMAP;
  }

  static String getLatitude() {
    return _LATITUDE;
  }

  static String getLongtitude() {
    return _LONGTITUDE;
  }

  static String getCurrentPosition() {
    return _CURRENT_POSITION;
  }

  static String getPickVillageFromMap(String villageName) {
    return _PICK_VILLAGE_FROM_MAP.replaceAll("{villageName}", villageName);
  }

  static String getRemoveInprogress() {
    return _REMOVE_INPROGRESS;
  }

  static String getComeInprogress() {
    return _COME_INPROGRESS;
  }

  static String getRemove() {
    return _REMOVE;
  }

  static String getUpdate() {
    return _UPDATE;
  }

  static String getContinue() {
    return _CONTINUE;
  }

  static String getSaveDraft() {
    return _SAVE_DRAFT;
  }

  static String getSuggestPositionNotice() {
    return _SUGGEST_POSITION_NOTICE;
  }

  static String getPick() {
    return _PICK;
  }

  //end craft_page()

  //change_password_page()

  static String getChangePassword() {
    return _CHANGE_PASSWORD;
  }

  static String getOldPassword() {
    return _OLD_PASSWORD;
  }

  static String getNewPassword() {
    return _NEW_PASSWORD;
  }

  static String getRePassword() {
    return _RE_PASSWORD;
  }

  static String getChangePasswordInfo() {
    return _CHANGE_PASSWORD_INFO;
  }

  static String getLogout() {
    return _LOGOUT;
  }

  //end change_password_page()
}

// import 'package:excel/excel.dart';

// class LanguageConfig {
//   //home_page()
//   static String _NOTICE = "Notice";
//   static String _RELOGIN = "Please login again";
//   static String _OK = "OK";
//   static String _HOUSE_HOLD = "House hold";
//   static String _LOCAL_AUTHORITY = "Local Authority";
//   static String _PRIVATE_PERSON = "Private Person";
//   static String _MY_TASKS = "My task";
//   static String _LOADING = "Loading..";
//   static String _NEW_SURVEY = "New Survey";
//   static String _NEW_SURVEY_TITLE = "Survey new craft villages now";
//   static String _IN_PROGRESS = "In Progress";
//   static String _IN_PROGRESS_TITLE = "Surveys need to be completed";
//   static String _IN_PROGRESS_SURVEYS = "In Progress Surveys";

//   static String _COMPLETED = "Completed";
//   static String _COMPLETED_TITLE = "Surveys was completed";
//   static String _ACHIEVEMENT = "Achievement";

//   static String _NEW_SURVEY_SUBTITLE =
//       "Number of responses per question number";
//   static String _ACHIEVEMENT_SUBTITLE = "Number of villages surveyed";
//   static String _NO_INTERNET =
//       "No internet connection, turn on internet and retry";
//   static String _NO_INTERNET_TOOLTIP = "No internet connection";
//   static String _CANCEL = "Cancel";
//   static String _CHANGE_GROUP = "Change group";
//   static String _SKIP_AND_SURVEY = "Skip and survey";
//   static String _PROCESSING = "Processing..";
//   static String _NOTICE_CHANGE_GROUP =
//       "You are in group {type}, do you want to change to another group to continue survey?";
//   static String _COME_INPROGRESS =
//       "Come InProgress";
//   static String _REMOVE_INPROGRESS =
//       "You already have a survey in Survey InProgress, do you want to delete the old survey and make a new one?";

//   //end home_page()
//   //surveys_in_progress_page()
//   static String _LIST_SURVEYS_INPROGRESS = "List of surveys temporarily saved";
//   static String _GROUP_USING = "Group in use: {typeUser}";
//   static String _NO_SAVE_DRAFT = "Currently no save draft found";
//   static String _EDIT_AND_REMOVE_NOTICE =
//       "(*) A user can only modify or delete a survey when he or she has changed the user group corresponding to that survey";
//   static String _VILLAGE_NAME = "Village Name {villageName}";
//   static String _NUMBER_OF_MAIN_QUESTION =
//       "Number of main questions: {mainQuestion}";
//   static String _NUMBER_OF_MAIN_ANSWER = "Number of main answers: {mainAnswer}";
//   static String _NUMBER_IMAGE = "Number of photos: {numberImage}";
//   static String _TYPE_SURVEY = "Survey type: {typeSurvey}";
//   static String _CONTINUE_SURVEY = "Continue to survey";
//   static String _CONTINUE_SURVEY_NOTICE =
//       "Do you want to continue this survey or not?";
//   static String _REMOVE_SURVEY = "Deleted successfully";
//   static String _REMOVE_SURVEY_NOTICE =
//       "Are you sure you want to delete this survey?";
//   static String _REMOVE =
//       "Remove";
//   //end surveys_in_progress_page()

//   //surveys_completed_page()
//   static String _LIST_SURVEYS_COMPLETED = "List of completed surveys";
//   static String _NO_COMPLETED = "No completed survey is currently found";
//   //end surveys_completed_page()

//   //details_user_page()
//   static String _DETAIL_USER = "User information";
//   static String _USERNAME = "Username";
//   static String _LASTNAME = "Lastname";
//   static String _FIRSTNAME = "Firstname";
//   static String _PHONE_NUMBER = "Phone Number";
//   static String _BIRTHDAY = "Birthday";
//   static String _EMAIL = "Email";
//   static String _CONFIRMED_EMAIL = "(*) Email has been confirmed";
//   static String _UNCONFIRMED_EMAIL =
//       "(*) The email is not confirmed, so the user type cannot be changed, click here to confirm the email";
//   static String _UPDATING = "Updating..";
//   static String _CONFIRMED_UPDATE = "Update successful";
//   static String _INFO = "Information";
//   static String _ACTIVE_CODE_NOTICE = "Active code";
//   static String _ACTIVE = "Active";
//   static String _WRONG_CODE = "Wrong code";
//   static String _UPDATE = "Update";
//   static String _CONTINUE = "Continue";
//   //end details_user_page()

//   //craft_page()
//   static String _INPUT_INFO = "Production and inputs";
//   static String _WAITING = "Loading content";
//   static String _SUBMIT = "Submit";
//   static String _WAITING_2 = "Loading .. wait";
//   static String _ADD_MORE_INFO = "Please enter more information";
//   static String _COMPLETED_INFO =
//       "The survey has been saved successfully. You can review the survey results in the Completed survey.";
//   static String _SAVE_DRAFT = "Save Draft";
//   static String _SAVE_DRAFT_INFO =
//       "The current survey has been saved temporarily. You can review and continue the survey in the InProgress section.";
//   static String _WARNING_SUBMIT =
//       "Please fill out the general information of the craft village";
//   static String _SUGGESTION =
//       "(*) If you take pictures, the information below will be suggested.";
//   static String _CURRENT_GROUP = "Group in use: {typeUser}";
//   static String _GENERAL_INFO = "General information (*)";
//   static String _PICK_PROVINCE = "Pick Province";
//   static String _PICK_DISTRICT = "Pick District";
//   static String _PICK_WARD = "Pick Ward";
//   static String _PICK_VILLAGE = "Pick Village";
//   static String _INVESTIGATED = "This craft village has surveyed";
//   static String _DESCRIPTION_VILLAGE = "Craft village description";
//   static String _OPTION = "Selection";
//   static String _TAKE_PHOTO = "Take a Photo";
//   static String _SUGGESTION_VILLAGE =
//       "Found the nearest craft village in the system, would you like to suggest?";
//   static String _ADD_VILLAGE = "Add a village";
//   static String _WARNING_REMOVE_IMAGE = "Error when deleting picture";
//   static String _REMOVE_IMAGE = "Are you sure you want to delete this picture?";
//   static String _LOADING_GMAP = "Loading maps ...";
//   static String _LATITUDE = "Latitude";
//   static String _LONGTITUDE = "Longtitude";
//   static String _CURRENT_POSITION = "Current position";
//   static String _PICK_VILLAGE_FROM_MAP =
//       "Would you like to select the craft village {villageName}?";
//   static String _SUGGEST_POSITION_NOTICE = "Please select photos with positioning enabled";
//   static String _PICK = "Pick";
//   //end craft_page()

//   //change_password_page()

//   static String _CHANGE_PASSWORD = "Change password";
//   static String _OLD_PASSWORD = "Enter old password";
//   static String _NEW_PASSWORD = "Enter new password";
//   static String _RE_PASSWORD = "Enter the password";
//   static String _CHANGE_PASSWORD_INFO = "Password changed successfully";

//   //end change_password_page()

//   //help_custom()

//   static String _LOGOUT = "Logout";

//   //end help_custom()
//   LanguageConfig(String languageName, Excel excel) {
//     for (var table in excel.tables.keys) {
//       // print(table); //sheet Name
//       // print(excel.tables[table].maxCols);
//       // print(excel.tables[table].maxRows);

//       var rowTable = excel.tables[table].rows[0];
//       int indexLanguageCode;
//       for (int i = 0; i < rowTable.length; i++) {
//         if (rowTable[i] == languageName) {
//           indexLanguageCode = i;
//           break;
//         }
//       }
//       for (int i = 1; i < excel.tables[table].rows.length; i++) {
//         var row = excel.tables[table].rows[i];
//         if (row[0].value == "notice") _NOTICE = row[indexLanguageCode];
//         if (row[0].value == "relogin") _RELOGIN = row[indexLanguageCode];
//         if (row[0].value == "ok") _OK = row[indexLanguageCode];
//         if (row[0].value == "house_hold") _HOUSE_HOLD = row[indexLanguageCode];
//         if (row[0].value == "local_authority")
//           _LOCAL_AUTHORITY = row[indexLanguageCode];
//         if (row[0].value == "private_person")
//           _PRIVATE_PERSON = row[indexLanguageCode];
//         if (row[0].value == "my_tasks") _MY_TASKS = row[indexLanguageCode];
//         if (row[0].value == "loading") _LOADING = row[indexLanguageCode];
//         if (row[0].value == "new_survey") _NEW_SURVEY = row[indexLanguageCode];
//         if (row[0].value == "new_survey_title")
//           _NEW_SURVEY_TITLE = row[indexLanguageCode];
//         if (row[0].value == "in_progress") _IN_PROGRESS = row[indexLanguageCode];
//         if (row[0].value == "in_progress_title")
//           _IN_PROGRESS_TITLE = row[indexLanguageCode];
//         if (row[0].value == "completed") _COMPLETED = row[indexLanguageCode];
//         if (row[0].value == "completed_title")
//           _COMPLETED_TITLE = row[indexLanguageCode];

//         if (row[0].value == "achievement") _ACHIEVEMENT = row[indexLanguageCode];
//         if (row[0].value == "new_survey_subtitle")
//           _NEW_SURVEY_SUBTITLE = row[indexLanguageCode];
//         if (row[0].value == "achievement_subtitle")
//           _ACHIEVEMENT_SUBTITLE = row[indexLanguageCode];
//         if (row[0].value == "no_internet") _NO_INTERNET = row[indexLanguageCode];
//         if (row[0].value == "no_internet_tooltip")
//           _NO_INTERNET_TOOLTIP = row[indexLanguageCode];
//         if (row[0].value == "cancel") _CANCEL = row[indexLanguageCode];
//         if (row[0].value == "change_group") _CHANGE_GROUP = row[indexLanguageCode];
//         if (row[0].value == "skip_and_survey")
//           _SKIP_AND_SURVEY = row[indexLanguageCode];
//         if (row[0].value == "processing") _PROCESSING = row[indexLanguageCode];
//         if (row[0].value == "notice_change_group")
//           _NOTICE_CHANGE_GROUP = row[indexLanguageCode];
//         if (row[0].value == "in_progress_surveys")
//           _IN_PROGRESS_SURVEYS = row[indexLanguageCode];
//         if (row[0].value == "come_inprogress")
//           _COME_INPROGRESS = row[indexLanguageCode];
//         if (row[0].value == "remove_inprogress")
//           _REMOVE_INPROGRESS = row[indexLanguageCode];
//         //end

//         if (row[0].value == "list_surveys_inprogress")
//           _LIST_SURVEYS_INPROGRESS = row[indexLanguageCode];
//         if (row[0].value == "group_using") _GROUP_USING = row[indexLanguageCode];
//         if (row[0].value == "no_save_draft") _NO_SAVE_DRAFT = row[indexLanguageCode];
//         if (row[0].value == "edit_and_remove_notice")
//           _EDIT_AND_REMOVE_NOTICE = row[indexLanguageCode];
//         if (row[0].value == "village_name") _VILLAGE_NAME = row[indexLanguageCode];
//         if (row[0].value == "number_of_main_question")
//           _NUMBER_OF_MAIN_QUESTION = row[indexLanguageCode];
//         if (row[0].value == "number_of_main_answer")
//           _NUMBER_OF_MAIN_ANSWER = row[indexLanguageCode];
//         if (row[0].value == "number_image") _NUMBER_IMAGE = row[indexLanguageCode];
//         if (row[0].value == "type_survey") _TYPE_SURVEY = row[indexLanguageCode];
//         if (row[0].value == "continue_survey")
//           _CONTINUE_SURVEY = row[indexLanguageCode];
//         if (row[0].value == "continue_survey_notice")
//           _CONTINUE_SURVEY_NOTICE = row[indexLanguageCode];
//         if (row[0].value == "remove_survey") _REMOVE_SURVEY = row[indexLanguageCode];
//         if (row[0].value == "remove_survey_notice")
//           _REMOVE_SURVEY_NOTICE = row[indexLanguageCode];
//         if (row[0].value == "remove")
//           _REMOVE = row[indexLanguageCode];

//         //end

//         if (row[0].value == "list_surveys_completed")
//           _LIST_SURVEYS_COMPLETED = row[indexLanguageCode];
//         if (row[0].value == "no_completed")
//           _NO_COMPLETED = row[indexLanguageCode];

//         //end

//         if (row[0].value == "detail_user")
//           _DETAIL_USER = row[indexLanguageCode];
//         if (row[0].value == "username")
//           _USERNAME = row[indexLanguageCode];
//         if (row[0].value == "lastname")
//           _LASTNAME = row[indexLanguageCode];
//         if (row[0].value == "firstname")
//           _FIRSTNAME = row[indexLanguageCode];
//         if (row[0].value == "phone_number")
//           _PHONE_NUMBER = row[indexLanguageCode];
//         if (row[0].value == "birthday")
//           _BIRTHDAY = row[indexLanguageCode];
//         if (row[0].value == "email")
//           _EMAIL = row[indexLanguageCode];
//         if (row[0].value == "confirmed_email")
//           _CONFIRMED_EMAIL = row[indexLanguageCode];
//         if (row[0].value == "unconfirmed_email")
//           _UNCONFIRMED_EMAIL = row[indexLanguageCode];
//         if (row[0].value == "updating")
//           _UPDATING = row[indexLanguageCode];
//         if (row[0].value == "confirmed_update")
//           _CONFIRMED_UPDATE = row[indexLanguageCode];
//         if (row[0].value == "info")
//           _INFO = row[indexLanguageCode];
//         if (row[0].value == "active_code_notice")
//           _ACTIVE_CODE_NOTICE = row[indexLanguageCode];
//         if (row[0].value == "active")
//           _ACTIVE = row[indexLanguageCode];
//         if (row[0].value == "wrong_code")
//           _WRONG_CODE = row[indexLanguageCode];
//         if (row[0].value == "update")
//           _UPDATE = row[indexLanguageCode];
//         if (row[0].value == "continue")
//           _CONTINUE = row[indexLanguageCode];

//         //end
//         if (row[0].value == "input_info")
//           _INPUT_INFO = row[indexLanguageCode];
//         if (row[0].value == "waiting")
//           _WAITING = row[indexLanguageCode];
//         if (row[0].value == "submit")
//           _SUBMIT = row[indexLanguageCode];
//         if (row[0].value == "waiting_2")
//           _WAITING_2 = row[indexLanguageCode];
//         if (row[0].value == "add_more_info")
//           _ADD_MORE_INFO = row[indexLanguageCode];
//         if (row[0].value == "completed_info")
//           _COMPLETED_INFO = row[indexLanguageCode];
//         if (row[0].value == "save_draft")
//           _SAVE_DRAFT = row[indexLanguageCode];
//         if (row[0].value == "save_draft_info")
//           _SAVE_DRAFT_INFO = row[indexLanguageCode];
//         if (row[0].value == "warning_submit")
//           _WARNING_SUBMIT = row[indexLanguageCode];
//         if (row[0].value == "suggestion")
//           _SUGGESTION = row[indexLanguageCode];
//         if (row[0].value == "current_group")
//           _CURRENT_GROUP = row[indexLanguageCode];
//         if (row[0].value == "general_info")
//           _GENERAL_INFO = row[indexLanguageCode];
//         if (row[0].value == "pick_province")
//           _PICK_PROVINCE = row[indexLanguageCode];
//         if (row[0].value == "pick_district")
//           _PICK_DISTRICT = row[indexLanguageCode];
//         if (row[0].value == "pick_ward")
//           _PICK_WARD = row[indexLanguageCode];
//         if (row[0].value == "pick_village")
//           _PICK_VILLAGE = row[indexLanguageCode];
//         if (row[0].value == "investigated")
//           _INVESTIGATED = row[indexLanguageCode];
//         if (row[0].value == "description_village")
//           _DESCRIPTION_VILLAGE = row[indexLanguageCode];
//         if (row[0].value == "option")
//           _OPTION = row[indexLanguageCode];
//         if (row[0].value == "take_photo")
//           _TAKE_PHOTO = row[indexLanguageCode];
//         if (row[0].value == "suggestion_village")
//           _SUGGESTION_VILLAGE = row[indexLanguageCode];
//         if (row[0].value == "add_village")
//           _ADD_VILLAGE = row[indexLanguageCode];
//         if (row[0].value == "warning_remove_image")
//           _WARNING_REMOVE_IMAGE = row[indexLanguageCode];
//         if (row[0].value == "remove_image")
//           _REMOVE_IMAGE = row[indexLanguageCode];
//         if (row[0].value == "loading_gmap")
//           _LOADING_GMAP = row[indexLanguageCode];
//         if (row[0].value == "latitude")
//           _LATITUDE = row[indexLanguageCode];
//         if (row[0].value == "longtitude")
//           _LONGTITUDE = row[indexLanguageCode];
//         if (row[0].value == "current_position")
//           _CURRENT_POSITION = row[indexLanguageCode];
//         if (row[0].value == "pick_village_from_map")
//           _PICK_VILLAGE_FROM_MAP = row[indexLanguageCode];
//         if (row[0].value == "suggest_position_notice")
//           _SUGGEST_POSITION_NOTICE = row[indexLanguageCode];
//         if (row[0].value == "pick")
//           _PICK = row[indexLanguageCode];

//         if (row[0].value == "change_password")
//           _CHANGE_PASSWORD = row[indexLanguageCode];
//         if (row[0].value == "old_password")
//           _OLD_PASSWORD = row[indexLanguageCode];
//         if (row[0].value == "new_password")
//           _NEW_PASSWORD = row[indexLanguageCode];
//         if (row[0].value == "re_password")
//           _RE_PASSWORD = row[indexLanguageCode];
//         if (row[0].value == "change_password_info")
//           _CHANGE_PASSWORD_INFO = row[indexLanguageCode];
//         if (row[0].value == "logout")
//           _LOGOUT = row[indexLanguageCode];
//         //end
//       }
//       // for (var row in excel.tables[table].rows) {
//       //   print("$row");
//       // }
//     }
//   }
//   static String getNotice() {
//     return _NOTICE;
//   }

//   static String getRelogin() {
//     return _RELOGIN;
//   }

//   static String getOK() {
//     return _OK;
//   }

//   static String getHouseHold() {
//     return _HOUSE_HOLD;
//   }

//   static String getLocalAuthority() {
//     return _LOCAL_AUTHORITY;
//   }

//   static String getPrivatePerson() {
//     return _PRIVATE_PERSON;
//   }

//   static String getMyTasks() {
//     return _MY_TASKS;
//   }

//   static String getLoading() {
//     return _LOADING;
//   }

//   static String getNewSurvey() {
//     return _NEW_SURVEY;
//   }

//   static String getNewSurveyTitle() {
//     return _NEW_SURVEY_TITLE;
//   }

//   static String getInProgress() {
//     return _IN_PROGRESS;
//   }

//   static String getInProgressTile() {
//     return _IN_PROGRESS_TITLE;
//   }

//   static String getCompleted() {
//     return _COMPLETED;
//   }

//   static String getCompletedTitle() {
//     return _COMPLETED_TITLE;
//   }

//   // 30/11/2020
//   static String getAchievement() {
//     return _ACHIEVEMENT;
//   }
//   static String getNewSurveySubtitle() {
//     return _NEW_SURVEY_SUBTITLE;
//   }
//   static String getAchievementSubtitle() {
//     return _ACHIEVEMENT_SUBTITLE;
//   }
//   static String getNoInternet() {
//     return _NO_INTERNET;
//   }
//   static String getNoInternetTooltip() {
//     return _NO_INTERNET_TOOLTIP;
//   }
//   static String getCancel() {
//     return _CANCEL;
//   }
//   static String getChangeGroup() {
//     return _CHANGE_GROUP;
//   }
//   static String getSkipAndSurvey() {
//     return _SKIP_AND_SURVEY;
//   }
//   static String getProcessing() {
//     return _PROCESSING;
//   }
//   static String getNoticeChangeGroup(String type) {
//     return _NOTICE_CHANGE_GROUP.replaceAll("{type}", type);
//   }
//   static String getInProgressSurveys() {
//     return _IN_PROGRESS_SURVEYS;
//   }

//   //end home page()

//   //surveys_in_progress_page()

//   static String getListSurveysInprogress() {
//     return _LIST_SURVEYS_INPROGRESS;
//   }
//   static String getGroupUsing(String typeUser) {
//     return _GROUP_USING.replaceAll("{typeUser}", typeUser);
//   }
//   static String getNoSaveDraft() {
//     return _NO_SAVE_DRAFT;
//   }
//   static String getEditAndRemoveNotice() {
//     return _EDIT_AND_REMOVE_NOTICE;
//   }
//   static String getVillageName(String villageName) {
//     return _VILLAGE_NAME.replaceAll("{villageName}", villageName);
//   }
//   static String getNumberOfMainQuestion(String mainQuestion) {
//     return _NUMBER_OF_MAIN_QUESTION.replaceAll("{mainQuestion}", mainQuestion);
//   }
//   static String getNumberOfMainAnswer(String mainAnswer) {
//     return _NUMBER_OF_MAIN_ANSWER.replaceAll("{mainAnswer}", mainAnswer);
//   }
//   static String getNumberImage(String numberImage) {
//     return _NUMBER_IMAGE.replaceAll("{numberImage}", numberImage);
//   }
//   static String getTypeSurvey(String typeSurvey) {
//     return _TYPE_SURVEY.replaceAll("{typeSurvey}", typeSurvey);
//   }

//   static String getContinueSurvey() {
//     return _CONTINUE_SURVEY;
//   }
//   static String getContinueSurveyNotice() {
//     return _CONTINUE_SURVEY_NOTICE;
//   }
//   static String getRemoveSurvey() {
//     return _REMOVE_SURVEY;
//   }
//   static String getRemoveSurveyNotice() {
//     return _REMOVE_SURVEY_NOTICE;
//   }

//   //end surveys_in_progress_page()

//   //surveys_completed_page()

//   static String getListSurveysCompleted() {
//     return _LIST_SURVEYS_COMPLETED;
//   }
//   static String getNoCompleted() {
//     return _NO_COMPLETED;
//   }

//   //end surveys_completed_page()

//   //details_user_page()

//   static String getDetailUser() {
//     return _DETAIL_USER;
//   }
//   static String getUsername() {
//     return _USERNAME;
//   }
//   static String getLastname() {
//     return _LASTNAME;
//   }
//   static String getFirstname() {
//     return _FIRSTNAME;
//   }
//   static String getPhoneNumber() {
//     return _PHONE_NUMBER;
//   }
//   static String getBirthday() {
//     return _BIRTHDAY;
//   }
//   static String getEmail() {
//     return _EMAIL;
//   }
//   static String getConfirmedEmail() {
//     return _CONFIRMED_EMAIL;
//   }
//   static String getUnconfirmedEmail() {
//     return _UNCONFIRMED_EMAIL;
//   }
//   static String getUpdating() {
//     return _UPDATING;
//   }
//   static String getConfirmedUpdate() {
//     return _CONFIRMED_UPDATE;
//   }
//   static String getInfo() {
//     return _INFO;
//   }
//   static String getActiveCodeNotice() {
//     return _ACTIVE_CODE_NOTICE;
//   }
//   static String getActive() {
//     return _ACTIVE;
//   }
//   static String getWrongCode() {
//     return _WRONG_CODE;
//   }

//   //end details_user_page()

//   //craft_page()

//   static String getInputInfo() {
//     return _INPUT_INFO;
//   }
//   static String getWaiting() {
//     return _WAITING;
//   }
//   static String getSubmit() {
//     return _SUBMIT;
//   }
//   static String getWaiting2() {
//     return _WAITING_2;
//   }
//   static String getAddMoreInfo() {
//     return _ADD_MORE_INFO;
//   }
//   static String getCompletedInfo() {
//     return _COMPLETED_INFO;
//   }
//   static String getSaveDraftInfo() {
//     return _SAVE_DRAFT_INFO;
//   }
//   static String getWarningSubmit() {
//     return _WARNING_SUBMIT;
//   }
//   static String getSuggestion() {
//     return _SUGGESTION;
//   }
//   static String getCurrentGroup(String typeUser) {
//     return _CURRENT_GROUP.replaceAll("{typeUser}", typeUser);
//   }
//   static String getGeneralInfo() {
//     return _GENERAL_INFO;
//   }
//   static String getPickProvince() {
//     return _PICK_PROVINCE;
//   }
//   static String getPickDistrict() {
//     return _PICK_DISTRICT;
//   }
//   static String getPickWard() {
//     return _PICK_WARD;
//   }
//   static String getPickVillage() {
//     return _PICK_VILLAGE;
//   }
//   static String getInvestigated() {
//     return _INVESTIGATED;
//   }
//   static String getDescriptionVillage() {
//     return _DESCRIPTION_VILLAGE;
//   }
//   static String getOption() {
//     return _OPTION;
//   }
//   static String getTakePhoto() {
//     return _TAKE_PHOTO;
//   }
//   static String getSuggestionVillage() {
//     return _SUGGESTION_VILLAGE;
//   }
//   static String getAddVillage() {
//     return _ADD_VILLAGE;
//   }
//   static String getWarningRemoveImage() {
//     return _WARNING_REMOVE_IMAGE;
//   }
//   static String getRemoveImage() {
//     return _REMOVE_IMAGE;
//   }
//   static String getLoadingGmap() {
//     return _LOADING_GMAP;
//   }
//   static String getLatitude() {
//     return _LATITUDE;
//   }
//   static String getLongtitude() {
//     return _LONGTITUDE;
//   }
//   static String getCurrentPosition() {
//     return _CURRENT_POSITION;
//   }
//   static String getPickVillageFromMap(String villageName) {
//     return _PICK_VILLAGE_FROM_MAP.replaceAll("{villageName}", villageName);
//   }

//   static String getRemoveInprogress() {
//     return _REMOVE_INPROGRESS;
//   }

//   static String getComeInprogress() {
//     return _COME_INPROGRESS;
//   }

//   static String getRemove() {
//     return _REMOVE;
//   }

//   static String getUpdate() {
//     return _UPDATE;
//   }

//   static String getContinue() {
//     return _CONTINUE;
//   }

//   static String getSaveDraft() {
//     return _SAVE_DRAFT;
//   }

//   static String getSuggestPositionNotice() {
//     return _SUGGEST_POSITION_NOTICE;
//   }

//   static String getPick() {
//     return _PICK;
//   }

//   //end craft_page()

//   //change_password_page()

//   static String getChangePassword(){
//     return _CHANGE_PASSWORD;
//   }
//   static String getOldPassword(){
//     return _OLD_PASSWORD;
//   }
//   static String getNewPassword(){
//     return _NEW_PASSWORD;
//   }
//   static String getRePassword(){
//     return _RE_PASSWORD;
//   }
//   static String getChangePasswordInfo(){
//     return _CHANGE_PASSWORD_INFO;
//   }
//   static String getLogout(){
//     return _LOGOUT;
//   }

//   //end change_password_page()
// }
