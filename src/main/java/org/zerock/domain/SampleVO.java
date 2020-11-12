package org.zerock.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data  // GetXXX, SetXXX 메서드, toString()메서드 , equlas() 메서드 hashCode() 등의 메서드
@AllArgsConstructor //모든 속성을 사용하는 생성자를 만들기 위함	SampleVO (Integer , String, String)
@NoArgsConstructor //비어있는 생성자를 만들기 위함(디폴트생성자)  SampleVO()
public class SampleVO {
	
	private Integer mno;
	private String firstName;
	private String lastName;
	
}
