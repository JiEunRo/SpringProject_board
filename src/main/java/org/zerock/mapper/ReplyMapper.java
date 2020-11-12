package org.zerock.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.zerock.domain.Criteria;
import org.zerock.domain.ReplyVO;

public interface ReplyMapper {
	
	//외래키를 사용하는 등록작업 처리
	public int insert(ReplyVO vo);
	
	//조회
	public ReplyVO read(Long bno);
	
	//삭제 - 특정 댓글의 삭제는 댓글의 번호(rno) 만으로 처리 가능합니다.
	public int delete(long tergetRno);	
	
	//수정
	public int update(ReplyVO reply);
	
	
	//댓글 목록과 페이징처리하기 : 게시물 페이징처리와 비슷하지만 게시물의 번호가 추가적으로 필요하다. MyBatis에서 2개 이상의 파라미터 처리를 위해 @Param  을 이ㅛㅇ한다.
	public List<ReplyVO> getListWithPaging(
		@Param("cri") Criteria cri,
		@Param("bno") Long bno);
	
	/*  댓글 페이징처리를 하기 위해 해당 게시물의 전체 댓글 수를 파악하기 위해 추상메서드를 만들었다... */
	public int getCountByBno(long bno);
	
}
