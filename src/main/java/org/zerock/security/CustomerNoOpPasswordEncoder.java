package org.zerock.security;

import org.springframework.security.crypto.password.PasswordEncoder;

import lombok.extern.log4j.Log4j;

@Log4j
public class CustomerNoOpPasswordEncoder implements PasswordEncoder{

	// 비밀번호 인코딩..
	@Override
	public String encode(CharSequence rawPassword) {
		
		log.warn("before encode : " + rawPassword);
		
		return rawPassword.toString();
	}

	//비밀번호가 같은지에 대한 여부 체크
	@Override
	public boolean matches(CharSequence rawPassword, String encodedPassword) {
		
		log.warn("mathches : " + rawPassword + " : " + encodedPassword);
		
		return rawPassword.toString().equals(encodedPassword);
	}

}
