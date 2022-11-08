package craftvillage.corelayer.config;

import java.io.IOException;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import craftvillage.bizlayer.services.JwtService;
import craftvillage.bizlayer.services.MyUserDetailsService;
import craftvillage.corelayer.utilities.JwtUtil;




@Component
public class JwtRequestFilter extends OncePerRequestFilter {
	
	
	@Autowired 
	private MyUserDetailsService userDetailsService;
	@Autowired
	private JwtUtil jwtUtil;
	@Autowired
	JwtService JwtService;
	@Override
	protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
			throws ServletException, IOException{
		
		String username = null;
		String jwt = null;
		String requestBearer = "";
		try{
			requestBearer = request.getHeader("Authorization");
		}
		catch(Exception e){
			System.out.println("Token is null");
		};
		if(requestBearer == null) {
			Cookie[] cookies = request.getCookies();
	        if (cookies != null) {
	            for (Cookie cookie : cookies) {
	                if (cookie.getName().equals("token")) {
	                	requestBearer = cookie.getValue();
	                	
	                    break;
	                }
	            }
	        }
		}
			if (requestBearer!=null  && requestBearer.startsWith("Bearer"))
			{
				jwt = requestBearer.substring(7);
				username =jwtUtil.extractUsername(jwt);
				if (username !=null && JwtService.checkToken(jwt)== true && SecurityContextHolder.getContext().getAuthentication() == null)
				{
					UserDetails userDetails = userDetailsService.loadUserByUsername(username);
					if (jwtUtil.validateToken(jwt, userDetails))
					{
						// kiểm tra xem token có hợp lệ ko , nếu có thì đưa thông tin vào security context
						
						UsernamePasswordAuthenticationToken usernamePasswordAuthenticationToken = new UsernamePasswordAuthenticationToken(
								userDetails.getUsername(),userDetails.getPassword(),userDetails.getAuthorities());
						
						
						usernamePasswordAuthenticationToken.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
						//set tất cả thông tin cho Seturity Context
						SecurityContextHolder.getContext().setAuthentication(usernamePasswordAuthenticationToken);
		 			}
				}
			}
		
		//Exception t = 
		filterChain.doFilter(request, response);
	}
	

}
