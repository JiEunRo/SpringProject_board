package org.zerock.service;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.zerock.domain.Criteria;
import org.zerock.domain.ReplyPageDTO;
import org.zerock.domain.ReplyVO;

/* 서비스영역과 Controller 처리는 BoardService 와 동일하게 처리된다.. */
public interface ReplyService {
	
	public int register(ReplyVO vo);
	
	public ReplyVO get(long rno);
	
	public int modify(ReplyVO vo);
	
	public int remove(long rno);
	
	public List<ReplyVO> getList(Criteria cri, long bno);
	
	/* ReplyDTO 를 반환하는 메서드 추가  */
	public ReplyPageDTO getListPage(Criteria cri, long bno);
	
}
