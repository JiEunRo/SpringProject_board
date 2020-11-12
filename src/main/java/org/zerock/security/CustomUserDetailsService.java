package org.zerock.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.zerock.domain.MemberVO;
import org.zerock.mapper.MemberMapper;
import org.zerock.security.domain.CustomUser;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

/*
	우리는 지금까지 MemberVO 와같이 회원처리 부분을 작업했다.
	스프링시큐리티의 UserDetailsService를 구현하는 클래스를 작업하자.. 
	MemberMapper타입의 인스턴스를 주입받아서 실제 기능을 구현하자..!
 */

@Log4j
public class CustomUserDetailsService implements UserDetailsService{

	@Setter(onMethod_ = @Autowired)
	private MemberMapper memberMapper;	
	
	@Override
	public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
		log.warn("Load User By UserName : " + username);
		
		//userName meas userid
		MemberVO vo = memberMapper.read(username);
		
		log.warn("queried by member mapper : " + vo);
		
		return vo == null ? null : new CustomUser(vo);
	}
	
}
