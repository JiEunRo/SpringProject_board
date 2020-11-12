package org.zerock.domain;

import java.util.Date;
import java.util.List;

import lombok.Data;

@Data
public class BoardVO {

	private long bno;
	private String title;
	private String content;
	private String writer;
	private Date regdate;
	private Date updatedate;
	
	/* 1. 댓글 수 처리를 위한 컬럼 추가*/
	private int replycnt;
	
	/* 첨부파일을 위해 추가 */
	private List<BoardAttachVO> attachList;
	
	/* 1. Hit 컬럼 추가 */
	private long hit;
	
	/* 4. IP 컬럼 추가 */
	private String ip;

    
}
