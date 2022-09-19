package craftvillage.corelayer.utilities;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.function.Function;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.MalformedJwtException;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.SignatureException;
import io.jsonwebtoken.UnsupportedJwtException;
 
@Service
public class JwtUtil {
	
	private String SECRET_KEY = "secret";
	//lay username tu token từ claims
	public String extractUsername(String token)
	{
		return extractClaim(token, Claims::getSubject);
	}
	//trích xuất th�?i hạn token từ claims
	public Date extractExpiration(String token)
	{
		return extractClaim(token, Claims::getExpiration);
	}
	//trích xuất thông tin token
	//Claim là nơi chứa tất cả thông tin của token
	public <T> T extractClaim(String token , Function<Claims, T> claimsResolver)
	{
		final Claims claims = extractAllClaims(token);
		
		return claimsResolver.apply(claims);
	}
	//trích xuất tất cả thông tin của token
	private Claims extractAllClaims(String token) {
		return Jwts.parser().setSigningKey(SECRET_KEY).parseClaimsJws(token).getBody();
	}
	//kiểm tra token đã hết hạn hay chưa ?
	public Boolean isTokenExpired(String token)
	{
		return extractExpiration(token).before(new Date());
	}
	//tạo nơi chứa thông tin token
	public String generateToken(UserDetails userDetails , String sessionid) {
		Map<String, Object> claims = new HashMap<>();
		
		return createToken(claims, userDetails.getUsername(),sessionid);
	}
	//tạo ra token
	private String createToken(Map<String,Object> claims , String subject,String sessionid)
	{ 
		return Jwts.builder().setClaims(claims).setSubject(subject).setIssuedAt(new Date(System.currentTimeMillis()))
				.setExpiration(new Date(System.currentTimeMillis() + 1000*60*60*24*365)).claim("sessionID", sessionid)
				.signWith(SignatureAlgorithm.HS256, SECRET_KEY).compact();
	}
	//xác thực token
	public Boolean validateToken(String token , UserDetails userDetails)
	{	
		final String username = extractUsername(token);
		if ((username.equals(userDetails.getUsername())&& checktoken(token)==0))
				return true;
		return false;
		
	}
	public int checktoken(String token)
	{
		try {
            Jwts.parser().setSigningKey(SECRET_KEY).parseClaimsJws(token);
            return 0;
        } catch (MalformedJwtException ex) {
        	return 1;
        } catch (ExpiredJwtException ex) {
        	return 2;
        } catch (UnsupportedJwtException ex) {
        	return 3;
        } catch (IllegalArgumentException ex) {
        	return 4;
        }catch (SignatureException ex) {
			return 5;
		}
        
	}

}
