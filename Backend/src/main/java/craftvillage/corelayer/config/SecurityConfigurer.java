package craftvillage.corelayer.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import craftvillage.bizlayer.services.MyUserDetailsService;
import craftvillage.corelayer.utilities.ConstantParameter;

@Configuration
@EnableWebSecurity
@EnableGlobalMethodSecurity(prePostEnabled = true)
public class SecurityConfigurer extends WebSecurityConfigurerAdapter {
  @Autowired
  private MyUserDetailsService myuserDetailsService;

  @Autowired
  private JwtAuthenticationEntryPoint jwtAuthenticationEntryPoint;

  @Autowired
  private JwtRequestFilter jwtRequestFilter;

  @Autowired
  public void configure(AuthenticationManagerBuilder auth) throws Exception {
    auth.userDetailsService(myuserDetailsService).passwordEncoder(passwordEncoder());
  }

  @Override
  protected void configure(HttpSecurity http) throws Exception {

    String url = "/" + ConstantParameter._URL_ROOT + "/" + ConstantParameter._URL_API + "/";
    String url_address = url + ConstantParameter.ServiceAddress._ADDRESS_SERVICE;
    String url_survey = url + ConstantParameter.ServiceSurvey._SURVEY_SERVICE;
    String url_answer = url + ConstantParameter.ServiceAnswer._ANSWER_SERVICE;
    String url_user = url + ConstantParameter.ServiceUser._USER_SERVICE;
    String url_village = url + ConstantParameter.ServiceVillage._VILLAGE_SERVICE;

    // http.csrf().ignoringAntMatchers("/craftvillage/api/village/newvillage", "/administration/**",
    // "/craftvillage/api/village/newvillage", "/web/household/**", "/web/authority/**", "/report",
    // "/craftvillage/api/survey/answer", "/craftvillage/api/village/update",
    // url_answer + "/" + ConstantParameter.ServiceAnswer._ANSWER_GET_COMPLETED,
    // url_answer + "/" + ConstantParameter.ServiceAnswer._ANSWER_GET_INPROGRESS,
    // url_answer + "/" + ConstantParameter.ServiceAnswer._ANSWER_UPLOAD_FILE,
    // url_user + "/" + ConstantParameter.ServiceUser._USER_LOGIN,
    // url_user + "/" + ConstantParameter.ServiceUser._USER_REGISTER,
    // url_user + "/" + ConstantParameter.ServiceUser._USER_FORGOTTEN_PASS,
    // url_user + "/" + ConstantParameter.ServiceUser._USER_ACTIVATE,
    // url_user + "/" + ConstantParameter.ServiceUser._USER_GET_PASSWORD,
    // url_user + "/" + ConstantParameter.ServiceUser._USER_CHANGE_PASS,
    // url_user + "/" + ConstantParameter.ServiceUser._USER_UPDATE_INFOR,
    // url_village + "/" + ConstantParameter.ServiceVillage._VILLAGE_SUBMIT,
    // url_address + "/" + ConstantParameter.ServiceAddress._ADDRESS_CHECK_VILLAGE);

    http.csrf().disable().authorizeRequests()
        .antMatchers("/web/login", "/web/logout", "/vendor/**", "/css/*", "/fonts/**", "/images/**",
            "/js/**", "/media/**", "/web/forgetpassword", "/craftvillage/api/survey/question",
            "/web/signup", url_user + "/" + ConstantParameter.ServiceUser._USER_LOGIN,
            url_user + "/" + ConstantParameter.ServiceUser._USER_REGISTER,
            url_user + "/" + ConstantParameter.ServiceUser._USER_SEND_EMAIL,
            url_user + "/" + ConstantParameter.ServiceUser._USER_FORGOTTEN_PASS,
            url_user + "/" + ConstantParameter.ServiceUser._USER_GET_PASSWORD,
            url_survey + "/" + ConstantParameter.ServiceSurvey._SURVEY_GET_SURVEY_BYID,
            url_survey + "/" + ConstantParameter.ServiceSurvey._SURVEY_GET_ALL_SURVEY,
            url_address + "/" + ConstantParameter.ServiceAddress._ADDRESS_GET_COUNTRY,
            url_address + "/" + ConstantParameter.ServiceAddress._ADDRESS_GET_PROVINCE,
            url_address + "/" + ConstantParameter.ServiceAddress._ADDRESS_GET_DISTRICT,
            url_address + "/" + ConstantParameter.ServiceAddress._ADDRESS_GET_WARD,
            url_address + "/" + ConstantParameter.ServiceAddress._ADDRESS_GET_VILLAGE,
            "/craftvillage/api/dataSet/getAll")
        .permitAll()
        .antMatchers("/craftvillage/api/village/newvillage",
            url_address + "/" + ConstantParameter.ServiceAddress._ADDRESS_GET_ADDRESS,
            url_address + "/" + ConstantParameter.ServiceAddress._ADDRESS_CHECK_VILLAGE,
            url_user + "/" + ConstantParameter.ServiceUser._USER_GET_DATA,
            url_village + "/" + ConstantParameter.ServiceVillage._VILLAGE_SUBMIT,
            url_village + "/" + ConstantParameter.ServiceVillage._VILLAGE_GET_INFOR,
            url_village + "/" + ConstantParameter.ServiceVillage._VILLAGE_GET_SURVEY,
            url_village + "/" + ConstantParameter.ServiceVillage._VILLAGE_DETECT)
        .hasAuthority("USER")

        .antMatchers("/web/household/**", "/craftvillage/api/survey/answer")
        .hasAuthority("HOUSEHOLD")

        .antMatchers("/web/authority/**", "/craftvillage/api/survey/listImage", "/api/map/**",
            "/craftvillage/api/survey/getImage", "/craftvillage/api/survey/answerHousehold",
            "/craftvillage/api/village/update")
        .hasAuthority("LOCALAUTHORITY").antMatchers("/administration/**").hasAuthority("ADMIN")

        .antMatchers("/web/home").hasAnyAuthority("HOUSEHOLD", "LOCALAUTHORITY", "ADMIN")

        .antMatchers("/web/home", url_user + "/" + ConstantParameter.ServiceUser._USER_CHANGE_PASS,
            url_user + "/" + ConstantParameter.ServiceUser._USER_UPDATE_INFOR, "/report")
        .hasAnyAuthority("HOUSEHOLD", "LOCALAUTHORITY", "ADMIN", "USER")

        .anyRequest().authenticated().and().exceptionHandling()
        .authenticationEntryPoint(jwtAuthenticationEntryPoint).and().sessionManagement()
        .sessionCreationPolicy(SessionCreationPolicy.STATELESS);
    http.addFilterBefore(jwtRequestFilter, UsernamePasswordAuthenticationFilter.class);
  }

  @Override
  @Bean
  public AuthenticationManager authenticationManagerBean() throws Exception {
    return super.authenticationManagerBean();
  }

  @Bean
  public PasswordEncoder passwordEncoder() {
    return new BCryptPasswordEncoder();
  }
}
