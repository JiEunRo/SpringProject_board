package org.zerock.service;

import java.util.List;

import org.zerock.domain.BoardAttachVO;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;

public interface BoardService {
	/* 게시판을 하려면 이 5가지의 메소드가 구현되어야한다. */
	
	//Create
	public void register (BoardVO board); // 인터페이스는 추상메서드만 있으므로.. abstract  생략가능함..
	
	//Read
	public BoardVO get(Long bno);
	
	//Update
	public boolean modify (BoardVO board);
	
	//Delete
	public boolean remove (Long bno);
	
	//Read
	//public List<BoardVO> getList();
	
	//전체목록을 읽는데, 페이징 처리를 하기 위해 criteria 클래스를 파라미터로 처리했다.
	public List<BoardVO> getList(Criteria cir);
	
	//실제DB에 있는 모든 게시물 수 구하기
	public int getTotal(Criteria cri);
	
	// 게시물 조회시 Ajax 로 처리하기로 했고, 서버측에서 JSON 데이터를 만들어서 화면에 올바르게 전송하는 작업을 먼저 처리해야한다.
	// BoardAttachMapper 에서 게시물 번호를 이용해서 BoardAttachVO 타입으로변환하는 메서드 findByBno() 메서드가 완성됐으니
	// 첨부파일 목록을 가져오는 메서드를 만들어야한다.
	public List<BoardAttachVO> getAttachList(long bno);
	
}
