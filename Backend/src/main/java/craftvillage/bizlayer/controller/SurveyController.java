package craftvillage.bizlayer.controller;

import java.security.Principal;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import craftvillage.bizlayer.services.AddressServices;
import craftvillage.bizlayer.services.MyUserDetailsService;
import craftvillage.bizlayer.services.SurveyServices;
import craftvillage.corelayer.utilities.ConstantParameter;
import craftvillage.datalayer.entities.SrActive;
import craftvillage.datalayer.entities.SrSurvey;
import craftvillage.datalayer.entities.UrUser;
import craftvillage.datalayer.entities.UserSurvey;
import craftvillage.datalayer.entities.Village;
import craftvillage.datalayer.model.SrActiveInfo;

@RestController
@RequestMapping("/" + ConstantParameter._URL_ROOT + "/" + ConstantParameter._URL_API + "/" + ConstantParameter.ServiceSurvey._SURVEY_SERVICE)
public class SurveyController {
	@Autowired
	private SurveyServices surveyServices;
	@Autowired 
	private MyUserDetailsService userDetailsService;
	@Autowired
	private AddressServices addressService;

	/**
	 * Function getAllSurveyActive : Lấy Survey từ db
	 * 
	 * @param principal
	 * @param request
	 * @return SrSurvey : Trả về tất cả survey của user
	 * @throws JSONException
	 */
	@RequestMapping(value = "/" + ConstantParameter.ServiceSurvey._SURVEY_GET_ALL_SURVEY, method = RequestMethod.GET, produces = "application/json")
	@ResponseBody
	public Set<SrSurvey> getAllSurveyActive(HttpServletRequest request, Principal principal) throws JSONException {
		String account = principal.getName();

		Set<SrSurvey> srSurvey = surveyServices.getUserSurvey(account);

		return srSurvey;
	}
	
	
	/**
	 * Function getSurveyByStatus : get all survey của user theo status
	 * 
	 * @param request
	 * @param principal
	 * @param status
	 * @return Set<SrActive>
	 */
	@RequestMapping(value = "/" + ConstantParameter.ServiceSurvey._SURVEY_GET_SURVEY_BYSTATUS, method = RequestMethod.GET, produces = "application/json")
	@ResponseBody
	public Set<SrActive> getSurveyByStatus(HttpServletRequest request, Principal principal,
			@RequestParam("status") String status) {
		String account = principal.getName();
		UrUser user = userDetailsService.getUrUser(account);
		Set<SrActive> srSurveyStatus = surveyServices.getSrActiveInfo(account, status, user.getType());
		return srSurveyStatus;
	}

	/**
	 * Function : getSurveyActiveInfo : Trả về thông tin survey của user theo status
	 * 
	 * @param request
	 * @param principal
	 * @param status
	 * @return ArrayList<SrActiveInfo>
	 */
//	@RequestMapping(value = "/" + ConstantParameter.ServiceSurvey._SURVEY_GET_ACTIVE_INFOR, method = RequestMethod.GET, produces = "application/json")
//	@ResponseBody
//	public ArrayList<SrActiveInfo> getSurveyActiveInfo(HttpServletRequest request, Principal principal,
//			@RequestParam("status") String status) {
//		String account = principal.getName();
//		UrUser user = userDetailsService.getUrUser(account);
//		List<UserSurvey> userSurvey = surveyServices.getSrActiveInfoByStatus(user , status );
//		ArrayList<SrActiveInfo> srActiveInfos = new ArrayList<>();
//		for (UserSurvey i : userSurvey) {
//			SrActiveInfo srActiveInfo = new SrActiveInfo();
//			Village village = addressService.getVillageInfo(i.getVillage().getVillageId());
//			srActiveInfo.setUserSurveyId(i.getId());
//			System.out.println(i.getId());
//			srActiveInfo.setSurveyActiveID(i.getSrActive().getId());
//			srActiveInfo.setDateActive(i.getSrActive().getDateActive());
//			srActiveInfo.setDateEnd(i.getSrActive().getDateEnd());
//			srActiveInfo.setSurveyName(i.getSrActive().getSrSurvey().getCampainName());
//			srActiveInfo.setSurveyId(i.getSrActive().getSrSurvey().getId());
//			srActiveInfo.setVillageName(village.getVillageName());
//			srActiveInfo.setTypeSurvey(i.getSrActive().getForRole());
//			DateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
//			String dateSubmitSurvey = dateFormat.format(i.getDateSubmitSurvey());
//			srActiveInfo.setDateSubmitSurvey(dateSubmitSurvey);
//			srActiveInfos.add(srActiveInfo);
//			
//		}
////		System.out.println(Calendar.getInstance().getTime());
////		Collections.sort(srActiveInfos, new Comparator<SrActiveInfo>() {
////			@Override
////            public int compare(SrActiveInfo x, SrActiveInfo y) {
////                return -x.getDateSubmitSurvey().compareTo(y.getDateSubmitSurvey());
////            }
////		});
//		return srActiveInfos;
//	}

	/**
	 * Function : getSurvey
	 * 
	 * @param surveyID
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "/" + ConstantParameter.ServiceSurvey._SURVEY_GET_SURVEY_BYID, method = RequestMethod.GET, produces = "application/json")
	@ResponseBody
	public SrSurvey getSurvey(@RequestParam("id") int activeId, HttpServletRequest request) {
		String jwt = null;

		String requestBearer = request.getHeader("Authorization");
		if (StringUtils.hasText(requestBearer) && requestBearer.startsWith("Bearer ")) {
			jwt = requestBearer.substring(7);
		}

		if (jwt == null) {
			return null;
		}
		return surveyServices.getSurveyByActiveId(activeId);
	}
	
	/**
	 * Function : getstatus : Trả về trạng thái của survey
	 * @param activeId
	 * @param principal
	 * @return String 
	 */
	@RequestMapping(value="/" + ConstantParameter.ServiceSurvey._SURVEY_GET_STATUS_SURVEY, method=RequestMethod.GET)
	public String getStatus(@RequestParam("id") int activeId , Principal principal)
	{
		String account = principal.getName();
		return surveyServices.getStatus(account, activeId);
	}

	public SurveyServices getSurveyServices() {
		return surveyServices;
	}

	public void setSurveyServices(SurveyServices surveyServices) {
		this.surveyServices = surveyServices;
	}

	public MyUserDetailsService getUserDetailsService() {
		return userDetailsService;
	}

	public void setUserDetailsService(MyUserDetailsService _userDetailsService) {
		this.userDetailsService = _userDetailsService;
	}

	public AddressServices getAddressService() {
		return addressService;
	}

	public void setAddressService(AddressServices addressService) {
		this.addressService = addressService;
	}		
}
