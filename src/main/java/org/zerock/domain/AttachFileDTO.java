package org.zerock.domain;

import lombok.Data;

// 이미지 파일의 정보를 저장하는 DTO 클래스를 작성하자
@Data
public class AttachFileDTO {
	
	private String fileName;		//파일이름
	private String uploadPath;	//파일경로
	private String uuid;				//중복방지를 위한 임의코드
	private boolean image;		//썸네일 생성을 위해 이미지파일인지 체크 (이미지여부)
	
}
