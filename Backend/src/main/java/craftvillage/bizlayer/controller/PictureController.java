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
	


}
