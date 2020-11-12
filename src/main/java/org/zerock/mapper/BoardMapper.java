package org.zerock.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;

/* org.zerock.mapper.BoardMapper 인터페이스 */
public interface BoardMapper {
	
	//@Select("SELECT * FROM tbl_board WHERE bno > 0")
	public List<BoardVO> getList();
	
	/* 페이징 처리  -  Criteria 타입의 파라미터로 사용하는 메서드 */
	public List<BoardVO> getListWithPaging(Criteria cri);
	
	/* create (insert) 처리하기 */
	public void insert(BoardVO board); // insert만 처리되고 생성된 PK값을 알 필요가 없는 경우 / 단순히 시퀀스의 다음 값을 구해서 insert 할 때 사용된다. 
	
	public void insertSelectKey(BoardVO board); //insert문이 실행되고 생성된 PK값을 알아야하는 경우
	
	
	/* READ 처리하기 */
	// insert 가 된 데이터를 조회하는 작업은 PK를 이용해서 처리하므로, BoardMapper 의 파라미터 역시 BoardVO클래스의 bno 타입 정보를 이용해서 처리
	public BoardVO read(long bno);
	
	/* DELETE 처리하기 */
	// 특정 데이터를 삭제 할 경우, pk값을 이용하므로 조회와 유사한 작업을 한다 / 몇건의 데이터가 삭제하는 지를 반환하므로 int
	public int delete(long bno);
	
	/* UPDATE 처리하기 */
	// update는 제목/내용/작성자를 수정한다.. 최종 수정시간은 현재 시간으로 수정하고, 몇개의 데이터가 수정했는가를 처리하기위해 int타입으로 설계
	public int update(BoardVO board);
	
	
	/* 데이터베이스에 있는 실제 모든 게시물의 수(total) 구하기 */
	public int getTotalCount(Criteria cri);
	
	
	/* 2. 댓글 수 처리를 위한 추상메서드 추가 - 해당 댓글의 게시물번호(bno) 와 증가나 감소를 의미하는 amount 변수 파라미터로 진행 
	 * 2개 이상의 파라미터 처리를 위해 @Param 어노테이션 이용 */
	public void updateReplyCnt(@Param("bno") long bno, @Param("amount") int amount);
	
	/* 2. HIT 조회수 처리하기 */
	public void updateHitCnt(long bno);
	
	
	
	
}
