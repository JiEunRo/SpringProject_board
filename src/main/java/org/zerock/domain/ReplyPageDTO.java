package org.zerock.domain;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;

/* 
단순히 댓글 전체를 보여주는 방식과 달리 댓글을 페이징처리하는 경우 댓글 목록과 함께 전체 댓글의 수를 같이 전달해야한다.
ReplyService 인터페이스와 구현 클래스인 ReplyServiceImpl은 List<ReplyVO> 와 댓글수를 같이 전달 할 수 잇는 구조로 변경한다. 
*/

@Data
@AllArgsConstructor	/* ReplyDTO 객체 생성시 편하도록 replyCnt, list를 생성자의 파라미터로 정한다.*/
@Getter
public class ReplyPageDTO {
	
	private int replyCnt;
	private List<ReplyVO> list;
	
	
}
