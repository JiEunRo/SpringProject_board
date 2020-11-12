package org.zerock.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.zerock.domain.Criteria;
import org.zerock.domain.ReplyPageDTO;
import org.zerock.domain.ReplyVO;
import org.zerock.mapper.BoardMapper;
import org.zerock.mapper.ReplyMapper;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Service
@Log4j
public class ReplyServiceImpl implements ReplyService{
	
	@Setter(onMethod_ = @Autowired) 
	private ReplyMapper mapper; 
	
	/* 5. 댓글 수 처리를 위해 BoardMapper 도 같이 사용하게 되었다. */
	@Setter(onMethod_ = @Autowired) 
	private BoardMapper boardMapper;  
	

	@Override
	public int register(ReplyVO vo) { 
		log.info("register ==================================" + vo); 
		
		boardMapper.updateReplyCnt(vo.getBno(), 1);	 /* 6. 댓글 수 처리를 위해 등록시 파라미터 값으로 받은 vo에 bno 값이 있으니 이를 통해  bno 의 값을 얻고, amount 에 1더함 */
		
		return mapper.insert(vo);
	}
	
	@Transactional
	@Override
	public ReplyVO get(long rno) {
		log.info("get ==================================" + rno);
		
		return mapper.read(rno);
	}

	@Override
	public int modify(ReplyVO vo) {
		log.info("ReplyVO ==================================" + vo);
		return mapper.update(vo);
	}

	@Transactional
	@Override
	public int remove(long rno) {
		log.info("remove ==================================" + rno);
		
		ReplyVO vo = mapper.read(rno);		/*  7. 댓글 수 처리를 위해 삭제시 파라미터가 rno 값만 받으므로 해당 댓글의 게시물 번호를 알아야한다..  */
		boardMapper.updateReplyCnt(vo.getBno(), -1);
				
		return mapper.delete(rno);
	}

	@Override
	public List<ReplyVO> getList(Criteria cri, long bno) {
		log.info("GET REPLY LIST OF A BOARD  ==================================" + bno);
		return mapper.getListWithPaging(cri, bno);
	}

	@Override
	public ReplyPageDTO getListPage(Criteria cri, long bno) {
		
		return new ReplyPageDTO(
				mapper.getCountByBno(bno),
				mapper.getListWithPaging(cri, bno));
	}
	
	
	
}
