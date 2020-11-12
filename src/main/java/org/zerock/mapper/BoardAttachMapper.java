package org.zerock.mapper;

import java.util.List;

import org.zerock.domain.BoardAttachVO;

//첨부파일 정보를 데이터베이스를 이용해서 보관하므로 SQL을 Mapper 인터페이스와 XML처리를 할 것이다.
//첨부파일은 수정이 없으므로, insert() 와 delete() 만 진행하겠다.
public interface BoardAttachMapper {
	
	public void insert(BoardAttachVO vo);
	
	public void delete(String uuid);
	
	public List<BoardAttachVO> findByBno(long bno);	// 특정 게시물의 번호로 첨부파일을 찾는 것이 필요하다.

	// 게시물을 삭제할 때, 첨부파일도 모두 삭제를 해야한다.
	public void deleteAll(long bno);
	
	// 잘못 올라간 파일을 삭제 해야한다.
	public List<BoardAttachVO> getOldFiles();
	
}
