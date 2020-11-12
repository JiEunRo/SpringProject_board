package org.zerock.security;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;

import lombok.extern.log4j.Log4j;

/* 로그인 성공 이후 특정한 동작을 제어하고 싶을 때 AuthenticationSuccessHandler 라는 인터페이스를 구현해서 사용한다.
 * ex) admin/admin 로그인 시 어떤 페이지에서 로그인하더라도 무조건 /sample/admin 으로 접속되게하라!
 * */

@Log4j
public class CustomLoginSuccessHandler implements AuthenticationSuccessHandler{

	@Override
	public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
			Authentication auth) throws IOException, ServletException {
		
		log.warn("Login Success");
		
		List<String> roleNames = new ArrayList<>();
		
		auth.getAuthorities().forEach(authority -> {
			roleNames.add(authority.getAuthority());
		});
		
		log.warn("ROLE NAMES : " + roleNames);
		if(roleNames.contains("ROLE_ADMIN")) {
			response.sendRedirect("/sample/admin");
			return;
		}
		
		if(roleNames.contains("ROLE_MEMBER")) {
			response.sendRedirect("/sample/member");
			return;
		}
		
		if(roleNames.contains("ROLE_MANAGER")) {
			response.sendRedirect("/sample/member");
			return;
		}
		
		response.sendRedirect("/");
		
	}
	
}
