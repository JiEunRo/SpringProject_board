package org.zerock.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.zerock.domain.MemberVO;
import org.zerock.domain.AuthVO;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;
import org.zerock.mapper.MemberMapper;

import lombok.AllArgsConstructor;
import lombok.Setter;
import lombok.extern.log4j.Log4j;


@Log4j
@Service
@AllArgsConstructor
public class MemberServiceImpl implements MemberService{

	//spring 4.3 이상에서 자동처리
	@Setter(onMethod_ = @Autowired ) 
	private MemberMapper mapper; 
	
	
	@Override
	public List<MemberVO> getList (Criteria cri){
		
		log.info("getList with Criteria : " + cri);
		
		return mapper.getListWithPaging(cri);		
	}
	
	
	
	@Transactional
	@Override
	public MemberVO get(String userid) {
		log.info("get ===============" + userid);
		
		
		return mapper.read(userid);
	}
	

	
	/*
	 * 회원등록시 권한과 멤버 각각 register() 메소드를 만들어서 작업했지만...
	 * member 와 auth 가 둘다 등록 되어야하므로, 둘 중 하나가 오류가 나면 등록되지 않아야한다.
	 * 회원 등록시 Transactional 을 설정해야한다.
	 */
	//등록
	@Transactional
	@Override
	public void register(MemberVO member, AuthVO auth) {
		log.info("register ===============" + member);
		//등록시 insertSelectKey 를 호출한다... member 객체만 넘겨주면 된다~
		mapper.insertSelectKey(member); // 나중에 생성된 게시물의 번호를 확인할 수 있다.
		mapper.insertAuth(auth);
	}
	/*
	@Override
	public void registerAuth (AuthVO auth) {
		log.info("register ===============" + auth);
		//등록시 insertSelectKey 를 호출한다... member 객체만 넘겨주면 된다~
		mapper.insertAuth(auth); // 나중에 생성된 게시물의 번호를 확인할 수 있다.
	}
	*/
	
	
	@Override
	public boolean modify(MemberVO member) { 
		log.info("modify ===============" + member); 
		return mapper.update(member) == 1; 
	}

	@Override
	public boolean remove(String userid) {
		log.info("remove ===============" + userid);
		return mapper.delete(userid) == 1;
	}

	
	
	
	
	@Override
	public int getTotal (Criteria cri) {
		log.info("get Total Count");
		return mapper.getTotalCount(cri);
	}


	
	
	
	
}
