package org.zerock.domain;

import java.util.Date;
import java.util.List;

import lombok.Data;

//tbl_member 테이블을 MyBatis를 이용하는 코드로 처리
@Data
public class MemberVO {
	
	private String userid;
	private String userpw;
	private String userName;
	private boolean enabled;
	
	private Date regDate;
	private Date updateDate;
	
	private List<AuthVO> authList; //사용자 권한 항목 1+N 관계 (왜 List 인가? admin 은 ROLE_MEMBER , ROLE_ADMIN 2개를 가지니까)
	
}
