package org.zerock.security;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.web.access.AccessDeniedHandler;

import lombok.extern.log4j.Log4j;

/* 
 * security-context.xml 에서 <security:access-denied-handler> 를 설정했고 ..
접근제한이 된 경우 다양한 처리를 하고싶다면 인터페이스를 직접 구현하는게 좋다.

우리는 이걸로 접근제한이 걸리면 리다이렉트하는 방식으로 동작하도록 지정했다.

인터페이스를 구현하고 난뒤, security-context.xml 에서 access-denied-handler 를 ref 로 구현해주자
*/

@Log4j
public class CustomAccessDeinedHandler implements AccessDeniedHandler{

	@Override
	public void handle(HttpServletRequest request, HttpServletResponse response,
			AccessDeniedException accessDeniedException) throws IOException, ServletException {
		
		log.error("Access Denied Handler");
		
		log.error("Redirect ..... ");
		
		response.sendRedirect("/accessError");
		
	}

}
