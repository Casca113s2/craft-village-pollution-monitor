	package craftvillage.bizlayer.controller;

//import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;

import java.security.Principal;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import craftvillage.bizlayer.services.AddressServices;
import craftvillage.bizlayer.services.MyUserDetailsService;
import craftvillage.bizlayer.services.SurveyServices;
import craftvillage.bizlayer.services.VillageServices;
import craftvillage.bizlayer.support_api.location.Coordinate;
import craftvillage.corelayer.utilities.ConstantParameter;
import craftvillage.datalayer.entities.AdWard;
import craftvillage.datalayer.entities.SrSurvey;
import craftvillage.datalayer.entities.TempVillage;
import craftvillage.datalayer.entities.UrUser;
import craftvillage.datalayer.entities.UserSurvey;
import craftvillage.datalayer.entities.UserSurveyAnswer;
import craftvillage.datalayer.entities.Village;
import craftvillage.datalayer.model.AnswerModel;
import craftvillage.datalayer.services.VillageServ;

@RestController
@RequestMapping("/" + ConstantParameter._URL_ROOT + "/" + ConstantParameter._URL_API + "/" + ConstantParameter.ServiceVillage._VILLAGE_SERVICE)
public class VillageController {
	private static final Logger logger = LoggerFactory.getLogger(VillageController.class);
	@Autowired
	private MyUserDetailsService userDeailsService;
	@Autowired
	private SurveyServices surveyServices;
	@Autowired
	private AddressServices addressService;
	@Autowired
	private VillageServices villageService;
	/**
	 * Function : VillageInfoSubmit : Submit thông tin làng nghề
	 * 
	 * @param VillageInfoForm
	 * @param principal
	 * @return true : submit thành công false : submit thất bại
	 */
	@RequestMapping(value = "/" + ConstantParameter.ServiceVillage._VILLAGE_SUBMIT, method = RequestMethod.POST)
	public boolean VillageInfoSubmit(@RequestBody Map<String, String> VillageInfoForm, Principal principal) {
		System.out.println("VillageInfoSubmit");
		String username = principal.getName();
		String villageName = VillageInfoForm.get("villageName");
		String coordinate = VillageInfoForm.get("coordinate");
		String villageId = VillageInfoForm.get("villageId");
		String totalQuestion = VillageInfoForm.get("totalQuestion");
		String totalAnswer = VillageInfoForm.get("totalAnswer");
		String totalImage = VillageInfoForm.get("totalImage");
		int hasAdded = Integer.parseInt(VillageInfoForm.get("hasAdded"));
		System.out.println("has added value: " + hasAdded);
		if(hasAdded == 0) {
			System.out.println("pick village info submit");
			UrUser user = userDeailsService.getUrUser(username);
			UserSurvey userSurvey = surveyServices.getUserSurvey(user, "Active");
			if (userSurvey == null) {
				userSurvey = surveyServices.getUserSurvey(user, "InProgress");
				System.out.println("VillageInfoSubmit inprogress");
			}
			
			userSurvey.setCraftId(Integer.parseInt(villageId));
			userSurvey.setTotalQuestion(Integer.parseInt(totalQuestion));
			userSurvey.setTotalAnswer(Integer.parseInt(totalAnswer));
			userSurvey.setTotalImage(Integer.parseInt(totalImage));
			surveyServices.addUserSurvey(userSurvey);
			Village village = addressService.getVillageInfo(Integer.parseInt(villageId));
			return addressService.SubmitVillageInfo(villageName, coordinate, userSurvey, village);
		}else {
			System.out.println("add village info submit");
			int adWardId = Integer.parseInt(VillageInfoForm.get("adWardId"));
			String note = VillageInfoForm.get("note");
			//thêm village
			Village newVillage = new Village();
			newVillage.setVillageName(villageName);
			newVillage.setCoordinate(coordinate);
			AdWard adWard = addressService.getAdward(adWardId);
			newVillage.setAdWard(adWard);
			newVillage.setNote(note);
			newVillage.setHasAdded(hasAdded);
			Village.showInfoVillage(newVillage);
			boolean checkAddVillage = villageService.addVillage(newVillage);
			if(checkAddVillage) {
				newVillage = villageService.findVillageByObject(newVillage);
				
				UrUser user = userDeailsService.getUrUser(username);
				UserSurvey userSurvey = surveyServices.getUserSurvey(user, "Active");
				if (userSurvey == null) {
					userSurvey = surveyServices.getUserSurvey(user, "InProgress");
					System.out.println("VillageInfoSubmit inprogress");
				}
				
				userSurvey.setCraftId(newVillage.getVillageId());
				userSurvey.setTotalQuestion(Integer.parseInt(totalQuestion));
				userSurvey.setTotalAnswer(Integer.parseInt(totalAnswer));
				userSurvey.setTotalImage(Integer.parseInt(totalImage));
				surveyServices.addUserSurvey(userSurvey);
				Village village = addressService.getVillageInfo(newVillage.getVillageId());
				return addressService.SubmitVillageInfo(villageName, coordinate, userSurvey, newVillage);
			}else {
				return false;
			}
			
			
		}
		
	}

	/**
	 * Từ khảo sát lấy thông tin làng nghề
	 * 
	 * @param userSurveyId
	 * @param principal
	 * @return
	 */
	@RequestMapping(value = "/" + ConstantParameter.ServiceVillage._VILLAGE_GET_INFOR, method = RequestMethod.GET, produces = "application/json")
	@ResponseBody
	public Map<String, String> getVillageInfo(@RequestParam("id") int userSurveyId, Principal principal) {
		//String username = principal.getName();
		//UrUser user = userDeailsService.getUrUser(username);
		UserSurvey userSurvey = surveyServices.getUserSurveyById(userSurveyId);
		System.out.println("userSurvey ID " + userSurveyId);	
		TempVillage tempVillage = new TempVillage();
		System.out.println("userSurvey TempVillage Size " + userSurvey.getTempVillages().size());
		for (TempVillage x : userSurvey.getTempVillages()) {
			tempVillage = x;
			break;
		}
		
		String villageId = String.valueOf(tempVillage.getVillage().getVillageId());
		Village village = addressService.getVillageInfo(Integer.parseInt(villageId));
		String strHasAdded = String.valueOf(village.getHasAdded());
		String wardId = String.valueOf(tempVillage.getVillage().getAdWard().getWardId());
		String districtId = String.valueOf(tempVillage.getVillage().getAdWard().getAdDistrict().getDistrictId());
		String provinceId = String
				.valueOf(tempVillage.getVillage().getAdWard().getAdDistrict().getAdProvince().getProvinceId());
		String villageNote = tempVillage.getVillage().getNote();
		Map<String, String> villageInfo = new HashMap<>();

		villageInfo.put("villageId", villageId);
		villageInfo.put("hasAdded", strHasAdded);
		villageInfo.put("villageName", village.getVillageName());
		villageInfo.put("coordinate", village.getCoordinate());
		
		villageInfo.put("wardId", wardId);
		villageInfo.put("districtId", districtId);
		villageInfo.put("provinceId", provinceId);
		villageInfo.put("villageNote", villageNote);
		logger.info(villageInfo.toString());	
		return villageInfo;
	}
	
	/**
	 * Dò làng nghề theo tọa độ
	 */
	@RequestMapping(value = "/"+ConstantParameter.ServiceVillage._VILLAGE_DETECT, method = RequestMethod.GET, produces = "application/json")
	public Map<String, Map<String, String>> detectVillage(@RequestParam String latitude, @RequestParam String longitude) {
		
		Coordinate coordinate = new Coordinate(Double.parseDouble(latitude), Double.parseDouble(longitude));
		
		List<Village> villages = villageService.findVillageByCoordinate(coordinate);
		System.out.println("coordinate: " + coordinate.x+" - "+coordinate.y);

		Map<String, Map<String, String>> res = new HashMap<>();
		
		int i=0;
		
		for (Village village : villages) {
			Map<String, String> villageInfo = new HashMap<>();
			
			String villageId = String.valueOf(village.getVillageId());
			String strHasAdded = String.valueOf(village.getHasAdded());
			String wardId = String.valueOf(village.getAdWard().getWardId());
			String districtId = String.valueOf(village.getAdWard().getAdDistrict().getDistrictId());
			String provinceId = String.valueOf(village.getAdWard().getAdDistrict().getAdProvince().getProvinceId());
			String wardName = String.valueOf(village.getAdWard().getWardName());
			String districtName = String.valueOf(village.getAdWard().getAdDistrict().getDistrictName());
			String provinceName = String.valueOf(village.getAdWard().getAdDistrict().getAdProvince().getProvinceName());
			String villageNote = village.getNote();
	
			villageInfo.put("villageId", villageId);
			villageInfo.put("hasAdded", strHasAdded);
			villageInfo.put("villageName", village.getVillageName());
	
			villageInfo.put("wardId", wardId);
			villageInfo.put("wardName", wardName);
			villageInfo.put("districtId", districtId);
			villageInfo.put("districtName", districtName);
			villageInfo.put("provinceId", provinceId);
			villageInfo.put("provinceName", provinceName);
			villageInfo.put("villageNote", villageNote);
			
			String villagecoordinate[] = village.getCoordinate().split(",");
			villageInfo.put("villageLatitude", villagecoordinate[0]);
			villageInfo.put("villageLongitude", villagecoordinate[1]);
			
			res.put("Village_"+i++, villageInfo);
		}
		
		return res;
		
//		System.out.print("Woohoo! I Here!\n");
//		
//		Coordinate coordinate = new Coordinate(Double.parseDouble(longitude), Double.parseDouble(latitude));
//		
//		Village village = villageService.findVillageByCoordinate(coordinate);
//		System.out.println("coordinate: " + coordinate.x+" - "+coordinate.y);	
//		
//		Map<String, String> villageInfo = new HashMap<>();
//		
//		if(village==null)
//		{
//			villageInfo.put("message", "can't detect");
//			return villageInfo;
//		}
//		
//		String villageId = String.valueOf(village.getVillageId());
//		String strHasAdded = String.valueOf(village.getHasAdded());
//		String wardId = String.valueOf(village.getAdWard().getWardId());
//		String districtId = String.valueOf(village.getAdWard().getAdDistrict().getDistrictId());
//		String provinceId = String.valueOf(village.getAdWard().getAdDistrict().getAdProvince().getProvinceId());
//		String wardName = String.valueOf(village.getAdWard().getWardName());
//		String districtName = String.valueOf(village.getAdWard().getAdDistrict().getDistrictName());
//		String provinceName = String.valueOf(village.getAdWard().getAdDistrict().getAdProvince().getProvinceName());
//		String villageNote = village.getNote();
//
//		villageInfo.put("villageId", villageId);
//		villageInfo.put("hasAdded", strHasAdded);
//		villageInfo.put("villageName", village.getVillageName());
//
//		villageInfo.put("wardId", wardId);
//		villageInfo.put("wardName", wardName);
//		villageInfo.put("districtId", districtId);
//		villageInfo.put("districtName", districtName);
//		villageInfo.put("provinceId", provinceId);
//		villageInfo.put("provinceName", provinceName);
//		villageInfo.put("villageNote", villageNote);
//		logger.info(villageInfo.toString());	
//		return villageInfo;	
		
		
	}

	/**
	 * Fake Survey Village
	 * 
	 * @param villageId
	 * @return
	 */
	@RequestMapping(value = "/" + ConstantParameter.ServiceVillage._VILLAGE_GET_SURVEY, method = RequestMethod.GET, produces = "application/json")
	public AnswerModel getVillageSurvey(@RequestParam("id") int villageId) {

		AnswerModel answerModel = new AnswerModel();
		Set<UserSurveyAnswer> answers = new HashSet<>();
		answers.add(new UserSurveyAnswer(219, 28, "50", ""));
		answers.add(new UserSurveyAnswer(231, 36, "68", ""));
		answers.add(new UserSurveyAnswer(243, 55, "19_20_21", ""));

		SrSurvey srSurvey = surveyServices.getSurveyByActiveId(1);
		answerModel.setAnswers(answers);
		answerModel.setSurveys(srSurvey);
		answerModel.setSrActiveId(1);
		logger.info(answerModel.toString());
		return answerModel;
	}

	public MyUserDetailsService getUserDeailsService() {
		return userDeailsService;
	}

	public void setUserDeailsService(MyUserDetailsService userDeailsService) {
		this.userDeailsService = userDeailsService;
	}

	public SurveyServices getSurveyServices() {
		return surveyServices;
	}

	public void setSurveyServices(SurveyServices surveyServices) {
		this.surveyServices = surveyServices;
	}

	public AddressServices getAddressService() {
		return addressService;
	}

	public void setAddressService(AddressServices addressService) {
		this.addressService = addressService;
	}
	
}
