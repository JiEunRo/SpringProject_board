package org.zerock.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.zerock.domain.MemberVO;
import org.zerock.domain.AuthVO;
import org.zerock.domain.Criteria;


public interface MemberMapper {
	
	
	/* 멤버의 리스트를 출력한다. */
	//@Select("SELECT * FROM tbl_member WHERE bno > 0")
	public List<MemberVO> getList();
	
	/* 멤버 리스트 페이징 처리  -  Criteria 타입의 파라미터로 사용하는 메서드 */
	public List<MemberVO> getListWithPaging(Criteria cri);
	
	
	
	/* 멤버등록하기 - PK값을 알 필요가 없는 경우 , 단순히 시퀀스 다음 값을 구해서 insert 할때 사용 */
	public void insert(MemberVO member);
	
	/* 멤버등록하기 - insert문 실행되고, PK값을 알아야 할 경우  */
	public void insertSelectKey(MemberVO member);
	
	public void insertAuth(AuthVO auth);
	
	
	
	/*데이터 조회하기 - PK 이용 */
	public MemberVO read(String userid);	
	
	/* 데이터 삭제하기 - PK 이용 , 몇 건의 데이터를 삭제하는지 int형 리턴 */
	public int delete(String userid);
	
	/* 데이터 수정하기 - PK 이용 */
	public int update(MemberVO member);
	
	
	
	/* 회원의 전체 수 구하기 */
	public int getTotalCount(Criteria cri);
	
	
}
