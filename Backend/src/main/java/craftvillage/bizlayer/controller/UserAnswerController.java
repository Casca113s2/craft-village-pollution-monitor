package craftvillage.bizlayer.controller;

import java.io.BufferedInputStream;
import java.security.Principal;
import java.util.Calendar;
import java.util.Date;
import java.util.Set;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.drew.imaging.ImageMetadataReader;
import com.drew.metadata.Directory;
import com.drew.metadata.Metadata;
import com.drew.metadata.Tag;

import craftvillage.bizlayer.services.AddressServices;
import craftvillage.bizlayer.services.FileService;
import craftvillage.bizlayer.services.MyUserDetailsService;
import craftvillage.bizlayer.services.SurveyServices;
import craftvillage.corelayer.utilities.ConstantParameter;
import craftvillage.datalayer.entities.SrActive;
import craftvillage.datalayer.entities.SrSurvey;
import craftvillage.datalayer.entities.UrUser;
import craftvillage.datalayer.entities.UserSurvey;
import craftvillage.datalayer.entities.UserSurveyAnswer;
import craftvillage.datalayer.model.AnswerModel;
import craftvillage.datalayer.model.AnswerSubmit;

@RestController
@RequestMapping("/" + ConstantParameter._URL_ROOT + "/" + ConstantParameter._URL_API + "/" + ConstantParameter.ServiceAnswer._ANSWER_SERVICE)
public class UserAnswerController {
	
	@Autowired
	private MyUserDetailsService userDetailsService;
	@Autowired
	private SurveyServices surveyServices;
	@Autowired
	private AddressServices addressService;
	@Autowired
	private FileService fileService;
	@Autowired
	private ServletContext sc;
	
	@RequestMapping(value = "/" + ConstantParameter.ServiceAnswer._ANSWER_GET_ANSWER, method = RequestMethod.GET, produces = "application/json")
	@ResponseBody
	public AnswerModel getUserAnswer(@RequestParam("activeid") int activeId,
			@RequestParam("usersurveyid") int usersurveyId, Principal principal) {

		String username = principal.getName();
		
		SrSurvey survey = surveyServices.getSurveyByActiveId(activeId);

		Set<UserSurveyAnswer> answers = surveyServices.getUserAnswer(usersurveyId);

		SrActive srActive = surveyServices.getSurveyActive(activeId);

		AnswerModel answerModel = new AnswerModel();

		answerModel.setSurveys(survey);
		answerModel.setAnswers(answers);
		answerModel.setSrActiveId(activeId);
		userDetailsService.changeType(username, srActive.getForRole());
		return answerModel;
	}

	/**
	 * Function AddAnswerCompleted : Them Cau tra loi vao survey , trạng thái
	 * Completed
	 * 
	 * @param urAnswer
	 * @param request
	 * @return true/false
	 */
	@RequestMapping(value = "/" + ConstantParameter.ServiceAnswer._ANSWER_GET_COMPLETED, method = RequestMethod.POST, consumes = "application/json")
	public boolean AddAnswerCompleted(@RequestBody AnswerSubmit[] answerSubmit, HttpServletRequest request,
			Principal principal) {
		String account = principal.getName();
		UrUser user = userDetailsService.getUrUser(account);
		UserSurvey userSurvey = surveyServices.getUserSurvey(user, "Active");

		if (userSurvey == null) {
			userSurvey = surveyServices.getUserSurvey(user, "InProgress");

		}

		for (int i = 0; i < answerSubmit.length; i++) {
			surveyServices.addUrAnswer(userSurvey, answerSubmit[i].getQuestionID(), answerSubmit[i].getAnswerContent(),
					answerSubmit[i].getOtherContent(), account);
		}

		Date dateSubmitSurvey = Calendar.getInstance().getTime();

		surveyServices.setDateSubmitSurvey(userSurvey.getId(), dateSubmitSurvey);
		surveyServices.changeStatus(userSurvey.getId(), "Completed");
		surveyServices.addUserSurveyById(account, userSurvey.getSrActive().getId());

		return true;
	}

	/**
	 * Function AddAnswerInProgress : Them Cau tra loi vao survey , trạng thái
	 * Inprogress
	 * 
	 * @param urAnswer
	 * @param request
	 * @return true/false
	 */

	@RequestMapping(value = "/" + ConstantParameter.ServiceAnswer._ANSWER_GET_INPROGRESS, method = RequestMethod.POST, consumes = "application/json")
	public boolean AddAnswerInProgress(@RequestBody AnswerSubmit[] answerSubmit, HttpServletRequest request,
			Principal principal) {
		String account = principal.getName();
		UrUser user = userDetailsService.getUrUser(account);
		UserSurvey userSurvey = surveyServices.getUserSurvey(user, "Active");


		if (userSurvey == null) {
			userSurvey = surveyServices.getUserSurvey(user, "InProgress");
		}
		System.out.println("User Survey Id : " + userSurvey.getId());

		for (int i = 0; i < answerSubmit.length; i++) {
			surveyServices.addUrAnswer(userSurvey, answerSubmit[i].getQuestionID(), answerSubmit[i].getAnswerContent(),
					answerSubmit[i].getOtherContent(), account);
		}

		Date dateSubmitSurvey = Calendar.getInstance().getTime();
		surveyServices.setDateSubmitSurvey(userSurvey.getId(), dateSubmitSurvey);
		surveyServices.changeStatus(userSurvey.getId(), "InProgress");

		return true;
	}

	/**
	 * Function ResetUserSurveyToActive : Xóa Survey InproGress , tạo lại 1 survey
	 * có trạng thái Active
	 * 
	 * @param principal
	 * @return true : thành công false : thất bại
	 */
	@RequestMapping(value = "/" + ConstantParameter.ServiceAnswer._ANSWER_RESET_SURVEY, method = RequestMethod.GET)
	public boolean ResetUserSurveyToActive(Principal principal) {
		String username = principal.getName();
		UrUser user = userDetailsService.getUrUser(username);
		UserSurvey userSurvey = surveyServices.getUserSurvey(user, "InProgress");
		System.out.println("Deleted Answer");
		surveyServices.DeletedAnswer(user, "InProgress");
		surveyServices.DeleteImage(user, "InProgress", sc.getRealPath("/"));
		addressService.DeleteTempVillage(user, "InProgress");
		System.out.println(userSurvey.getId());
		surveyServices.changeStatus(userSurvey.getId(), "Active");
		return true;
	}

	/**
	 * Function UploadFile : upload file
	 * 
	 * @param file
	 * @return Village : trả về thông tin làng nghề được gợi ý
	 * @throws Exception 
	 */

	@RequestMapping(value = "/" + ConstantParameter.ServiceAnswer._ANSWER_UPLOAD_FILE, method = RequestMethod.POST)
	public boolean UploadFile(@RequestBody MultipartFile file, Principal principal)
			throws Exception {
		
		System.out.println("Demo");
		double lat = 0, lon = 0;
		// System.out.println("Test : " + latitude + "Demo: " + longitude);
		String filename = file.getOriginalFilename();
		
		System.out.println("FileName :" + filename);
		
		System.out.println(fileService.findByFileName(filename));
		if (fileService.findByFileName(filename) != null)
		{			
			return false;
		}
		
		String username = principal.getName();
		filename = FileService.createFileName(filename, username);
		
		BufferedInputStream inputStream = new BufferedInputStream(file.getInputStream());
		Metadata metadata = ImageMetadataReader.readMetadata(inputStream, true);
		
		for (Directory directory : metadata.getDirectories()) {
			for (Tag tag : directory.getTags()) {
				String tagName = tag.getTagName();
				String desc = tag.getDescription();
				//System.out.println(tagName + ": " + desc);
				
				if (tagName.equals("GPS Longitude")) {
					String[] t = desc.split(" ");
					t[0] = t[0].substring(0, t[0].length() - 1);
					t[1] = t[1].substring(0, t[1].length() - 1);
					t[2] = t[2].substring(0, t[2].length() - 1);

					lon = addressService.convertCoordinates(Double.parseDouble(t[0]), Double.parseDouble(t[1]),
							Double.parseDouble(t[2]));

				} else if (tagName.equals("GPS Latitude")) {
					String[] t = desc.split(" ");
					t[0] = t[0].substring(0, t[0].length() - 1);
					t[1] = t[1].substring(0, t[1].length() - 1);
					t[2] = t[2].substring(0, t[2].length() - 1);
					lat = addressService.convertCoordinates(Double.parseDouble(t[0]), Double.parseDouble(t[1]),
							Double.parseDouble(t[2]));

				}

			}
		}

		UrUser user = userDetailsService.getUrUser(username);
		UserSurvey userSurvey = surveyServices.getUserSurvey(user, "Active");
		if (userSurvey == null) {
			userSurvey = surveyServices.getUserSurvey(user, "InProgress");
		}
		
		String filePath = fileService.storeFile(file , sc.getRealPath("/") , username, filename);
		System.out.println("FilePath " + filePath);
		Date dateNow = new Date();

		surveyServices.addFilePath(filePath, dateNow, userSurvey, lat, lon, filename);

		return true;
	}

	public MyUserDetailsService getUserDetailsService() {
		return userDetailsService;
	}

	public void setUserDetailsService(MyUserDetailsService userDetailsService) {
		this.userDetailsService = userDetailsService;
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

	public FileService getFileService() {
		return fileService;
	}

	public void setFileService(FileService fileService) {
		this.fileService = fileService;
	}
	
}
