package org.zerock.controller;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import lombok.extern.log4j.Log4j;


@Controller
@Log4j
public class CommonController {

	/*/accessError 를 처리하도록 지정  */
	@GetMapping({"/accessError", "/sample/accessError"})
	public void accessDenied(Authentication auth, Model model) {
		log.info("access Denied : " + auth);
		
		model.addAttribute("msg", "Access Denied");
	}
	
	
	/* 사용자가 직접 만드는 로그인 페이지... GET 방식으로 접근하도록 지정 / 에러메세지와 로그아웃 메세지를 파라미터로 지정했다. */
	@GetMapping("/customLogin")
	public void loginInput(String error, String logout, Model model) {
		log.info("Error : " + error);
		log.info("Logout : " + logout);
		
		if(error != null) {
			model.addAttribute("error", "Login Error Check Your Account");
		}
		
		if(logout != null) {
			model.addAttribute("logout", "Logout!!");
		}
	}
	
	
	/* 로그아웃을 결정하는 페이지에 대한 메서드 처리 */
	@GetMapping("/customLogout")
	public void logoutGET() {
		log.info("custom logout");
	}
	
	@PostMapping("/customLogout")
	public void logoutPost() {
		log.info("post custom logout");
	}
	
	
}
