package org.zerock.domain;

import lombok.Data;

// 첨부파일 의 정보를 저장하는 DTO 클래스를 작성하자
@Data
public class BoardAttachVO {
	
	private String uuid;				// uuid가 포함된 이름을 PK로 하는 컬러 
	private String uploadPath;	// 실제 파일이 업로드된 경로
	private String fileName;		// 파일이름
	private boolean fileType;		// 이미지 파일인지 여부
	
	private long bno;					// 해당 게시물 번호 저장
}
