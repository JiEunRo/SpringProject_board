package org.zerock.service;

import java.util.List;

import org.zerock.domain.MemberVO;
import org.zerock.domain.AuthVO;
import org.zerock.domain.Criteria;

public interface MemberService {

	
	//Create
	public void register (MemberVO member, AuthVO auth); 
	//public void registerAuth (AuthVO auth); 
	
	//Read
	public MemberVO get(String userid);
	
	//Update
	public boolean modify (MemberVO member);
	
	//Delete
	public boolean remove (String userid);
	
	//Read
	//public List<MemberVO> getList();
	
	//전체목록을 읽는데, 페이징 처리를 하기 위해 criteria 클래스를 파라미터로 처리했다.
	public List<MemberVO> getList(Criteria cir);
	
	//실제DB에 있는 모든 게시물 수 구하기
	public int getTotal(Criteria cri);
	
}
