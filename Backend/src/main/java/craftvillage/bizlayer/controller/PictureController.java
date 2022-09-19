package craftvillage.bizlayer.controller;

import java.io.IOException;
import java.security.Principal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.io.FilenameUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import craftvillage.bizlayer.services.FileService;
import craftvillage.bizlayer.services.MyUserDetailsService;
import craftvillage.corelayer.utilities.ConstantParameter;
import craftvillage.datalayer.entities.SrImg;
import craftvillage.datalayer.entities.UrUser;

@RestController
@CrossOrigin(origins = "http://localhost:4200", maxAge = 3600)
@RequestMapping("/" + ConstantParameter._URL_ROOT + "/" + ConstantParameter._URL_API + "/" + ConstantParameter.ServiceImage._IMAGE_SERVICE)

public class PictureController {
	
	@Autowired
	private MyUserDetailsService userDetailsService;
	@Autowired
	private FileService fileService;
	@Autowired
	private ServletContext sc;
	
	/**
	 * Funciton : downloadFile :lấy ảnh từ cơ sở dữ liệu
	 * 
	 * @param fileName
	 * @param request
	 * @return
	 * @throws IOException 
	 */

	@RequestMapping(value = "/" + ConstantParameter.ServiceImage._IMAGE_GET_PICTURE, method = RequestMethod.POST)
	public Map<String , List<String>> EnCodeBase64(@RequestBody Map<String,List<String>> fileName,
			HttpServletRequest request) throws IOException {
		
		List<String> fileEnCodeBase64 = new ArrayList<String>()  ;
		List<String> fileNamelst = fileName.get("filename");
		Map<String , List<String>> lstFileNameEncodeBase64 = new HashMap<String, List<String>>();
		
		for (String x : fileNamelst) {
		   String filename = x;
		   SrImg srImg = fileService.findByFileName(filename);
		   if (srImg != null )
		   {
			   String path = srImg.getUrImgPath();
			   
			   String realImagePath = sc.getRealPath("/") + path + FilenameUtils.getBaseName(filename) + "_small.jpg";
			   System.out.println(realImagePath);
			   String enCodeBase64 = fileService.base64Encode(realImagePath);
			   fileEnCodeBase64.add(enCodeBase64);
		   }
		   else
		   {
			   fileEnCodeBase64.add(null);			   
		   }
		}
		lstFileNameEncodeBase64.put("fileImg", fileEnCodeBase64);
		return lstFileNameEncodeBase64;
	}
	
	@RequestMapping(value = "/" + ConstantParameter.ServiceImage._IMAGE_DEL_PICTURE, method = RequestMethod.POST)
	public boolean deleteImage(@RequestBody Map<String, String> nameImg, Principal principal)
	{
		String filename = nameImg.get("filename");
		System.out.println(filename);
		SrImg srImg = fileService.findByFileName(filename);
		boolean isSuccess = false;
		if (srImg != null )
		   {
			   String path = srImg.getUrImgPath();			   
			   String realImagePath = sc.getRealPath("/") + path;
			   
			   String account = principal.getName();
			   UrUser user = userDetailsService.getUrUser(account);
				
			   isSuccess = fileService.deleteFile(filename, realImagePath, user, "InProgress");
		   }
		
		return isSuccess;
	}
}
