package craftvillage.corelayer.utilities;

public class ConstantParameter {
	
	public final static String _SCHEMA_NAME = "CV_USER";
	public final static String _URL_ROOT = "craftvillage";
	public final static String _URL_API = "api";
	
	public static String _IMAGE_PATH = "image";
	
	public static String getImageRealPath(String rootpath , String username)
	{
		String pathFile = rootpath  + _IMAGE_PATH + "/" + username + "/" ;
		return pathFile;
	}
	
	public static String getImageLogicPath(String username)
	{
		String pathFile = _IMAGE_PATH + "/" + username + "/" ;
		return pathFile;
	}
	
	public final static class ServiceAddress {
		
		public final static String _ADDRESS_SERVICE = "address";
		public final static String _ADDRESS_GET_COUNTRY = "getcountrylist";
		public final static String _ADDRESS_GET_PROVINCE = "getprovincelist";
		public final static String _ADDRESS_GET_DISTRICT = "getdistrictlist";
		public final static String _ADDRESS_GET_WARD = "getwardlist";
		public final static String _ADDRESS_GET_VILLAGE = "getvillage";
		public final static String _ADDRESS_CHECK_VILLAGE = "checkvillage";
		public final static String _ADDRESS_GET_ADDRESS = "getaddress";
	}
	
	public final static class ServiceImage {
		
		public final static String _IMAGE_SERVICE = "image";
		public final static String _IMAGE_GET_PICTURE = "getpicture";
		public final static String _IMAGE_DEL_PICTURE = "deletepicture";
	}
	
	public final static class ServiceSurvey {
		
		public final static String _SURVEY_SERVICE = "survey";
		public final static String _SURVEY_GET_ALL_SURVEY = "allsurvey";
		public final static String _SURVEY_GET_ACTIVE_INFOR = "surveyactiveinfo";
		public final static String _SURVEY_GET_SURVEY_BYSTATUS = "surveystatus";		
		public final static String _SURVEY_GET_SURVEY_BYID = "survey";
		public final static String _SURVEY_GET_STATUS_SURVEY = "getstatus";
	}
	
	public final static class ServiceAnswer {
		
		public final static String _ANSWER_SERVICE = "answer";
		public final static String _ANSWER_GET_ANSWER = "getanswer";
		public final static String _ANSWER_GET_COMPLETED = "answercompleted";
		public final static String _ANSWER_GET_INPROGRESS = "answerinprogress";
		public final static String _ANSWER_RESET_SURVEY = "resetusersurvey";
		public final static String _ANSWER_UPLOAD_FILE = "uploadfile";
	}
	
	public final static class ServiceUser {
		
		public final static String _USER_SERVICE = "user";
		public final static String _USER_LOGOUT_TEST = "logoutapptest";
		public final static String _USER_LOGOUT = "logoutapp";
		public final static String _USER_LOGIN = "loginapp";
		public final static String _USER_REGISTER = "register";
		public final static String _USER_GET_DATA = "data";
		public final static String _USER_CHANGE_PASS = "changepass";
		public final static String _USER_FORGOTTEN_PASS = "forgetpass";
		public final static String _USER_UPDATE_INFOR = "updateuser";
		public final static String _USER_GET_PASSWORD = "getpass";
		public final static String _USER_SEND_EMAIL = "sendmail";
		public final static String _USER_ACTIVATE = "activeuser";
	}
	
	public final static class ServiceVillage {
		
		public final static String _VILLAGE_SERVICE = "village";
		public final static String _VILLAGE_SUBMIT = "submitvillage";
		public final static String _VILLAGE_GET_INFOR = "getvillageinfo";
		public final static String _VILLAGE_GET_SURVEY = "getvillagesurvey";
		public final static String _VILLAGE_DETECT = "detectvillage";
	}
}
