package org.zerock.domain;

import java.util.Date;

import lombok.Data;

@Data
public class MyLocVO {

	private String lng;		//경도
	private String lat;		//위도
	private Date inputDate;	//날짜
	private String ip;		//IP
	
	
}
