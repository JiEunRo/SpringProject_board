package org.zerock.domain;

import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
public class PageDTO {
	
	private int startPage;
	private int endPage;
	private boolean prev, next;
	
	private int total;
	private Criteria cri;	//페이지에서 보여주는 데이터수 (amount)와 현재 페이지번호(pageNum)를 가지고 있음!
	
	
	//생성자를 정의하고, Criteria와 전체데이터수(total)를 파라미터로 지정한다.
	
	public PageDTO(Criteria cri, int total) {
		
		this.cri = cri;
		this.total = total;
		
		//끝페이지 번호 구하기
		this.endPage = (int)( Math.ceil ( cri.getPageNum() / 10.0 ) ) *10;
		
		//시작페이지 번호 구하기
		this.startPage = this.endPage - 9;
		
		//진짜 끝페이지 번호 구하기
		int realEnd = (int) (Math.ceil ( ( total * 1.0 ) / cri.getAmount() ) );
		
		// 진짜 끝페이지가 구해둔 끝번호보다 작다면 끝번호는 작은 값이 되어야한다.
		if(realEnd < this.endPage) {	
			this.endPage = realEnd;
		}
		
		//이전페이지  
		this.prev = this.startPage > 1;
		
		//다음페이지
		this.next = this.endPage < realEnd;
	}
	
	
}
