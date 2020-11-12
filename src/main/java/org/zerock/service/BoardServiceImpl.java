package org.zerock.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.zerock.domain.BoardAttachVO;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;
import org.zerock.mapper.BoardAttachMapper;
import org.zerock.mapper.BoardMapper;

import lombok.AllArgsConstructor;
import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
@Service
@AllArgsConstructor
public class BoardServiceImpl implements BoardService {

	//spring 4.3 이상에서 자동처리
	@Setter(onMethod_ = @Autowired ) 
	private BoardMapper mapper; 
	
	//첨부파일 처리를 위해 .. 2개의 Mapper를 처리해야하므로 자동주입보다는 setter 를 이용한다.
	@Setter(onMethod_ = @Autowired )
	private BoardAttachMapper attachMapper;
	
	
	//등록
	@Transactional //tbl_boar 와 tbl_attach 테이블 모두 insert 되야하므로 트랜젝션 처리를 해줘야한다!
	@Override
	public void register(BoardVO board) {
		log.info("등록하자아아 ===============" + board);
		//등록시 insertSelectKey 를 호출한다... board 객체만 넘겨주면 된다~
		
		
		// 게시물 등록하자
		mapper.insertSelectKey(board); // 나중에 생성된 게시물의 번호를 확인할 수 있다.
		
		//만약 첨부파일 이 없다면 종료하고..있다면 아래 코드 수행
		if(board.getAttachList() == null || board.getAttachList().size() <= 0) {
			log.info("첨부파일이 없습니다");
			return;
		}
		
		// 첨부파일 등록하자
		board.getAttachList().forEach(attach -> {
			log.info("첨부파일 등록할게!!");
			// 첨부파일은 생성된 게시물의 번호를 셋팅하고
			attach.setBno(board.getBno());
			//tbl_attach 테이블에 데이터 추가하자.
			attachMapper.insert(attach);
		});
		
	}
	
	/* 4. HIT 처리하기 : get() 메소드에서 @transactional 주고 / mapper.upadetHitCnt(bno); 주기 */
	@Transactional
	@Override
	public BoardVO get(Long bno) {
		log.info("get ===============" + bno);
		
		mapper.updateHitCnt(bno);
		
		return mapper.read(bno);
	}
	
	@Transactional
	@Override
	public boolean modify(BoardVO board) { 
		log.info("게시물 수정 ===============" + board);
		
		//첨부파일도 수정하자.
		//먼저, 기존의 첨부파일 데이터를 다 지우고
		attachMapper.deleteAll(board.getBno());
		
		// 다시 첨부파일을 추가한다.
		boolean modifyResult = mapper.update(board) == 1;
		
		if(modifyResult && board.getAttachList() != null && board.getAttachList().size() > 0) {
			board.getAttachList().forEach(attach -> {
				attach.setBno(board.getBno());
				attachMapper.insert(attach);
			});
		}
		
		return mapper.update(board) == 1; 
	}

	@Transactional // 2개의 테이블에 모두 삭제를 해야하므로 .. ( 게시물 삭제시 첨부파일도 모두 삭제 )
	@Override
	public boolean remove(Long bno) {
		log.info("게시물 삭제하기 ==================== " + bno);
		
		attachMapper.deleteAll(bno);  // 해당 게시물 번호의 첨부파일도 삭제한다.
		
		return mapper.delete(bno) == 1;
	}

	/*
	@Override
	public List<BoardVO> getList() {
		log.info("getList ===============");
		return mapper.getList();
	}
	*/
	
	@Override
	public List<BoardVO> getList (Criteria cri){
		
		log.info("getList with Criteria : " + cri);
		
		return mapper.getListWithPaging(cri);		
	}
	
	
	@Override
	public int getTotal (Criteria cri) {
		log.info("get Total Count");
		return mapper.getTotalCount(cri);
	}
	
	
	
	
	//게시물의 첨부파일들의 목록을 가져오는 메서드를 구현하자.
	@Override 
	public List<BoardAttachVO> getAttachList(long bno) { 
		
		log.info("첨부파일 리스트를 가져오기 위한 게시물 번호 : " + bno); 
		
		return attachMapper.findByBno(bno); 
	}
	
	
	
	
	
	
}
