package org.zerock.domain;

import org.springframework.web.util.UriComponentsBuilder;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

//LOMBOK 을 이용해서 getter / setter 를 생성한다.
@Setter	
@Getter
@ToString
public class Criteria { 
	//이 클래스의 용도는 pageNum과 amount 의 갑을 같이 전달하는 용도이지만
	
	private int pageNum;
	private int amount;
	
	//검색조건을 추가하기 위함
	private String type;	//검색조건
	private String keyword;	//검색 키워드

	public Criteria() {	//생성자를 통해 기본값을 1페이지 10개 데이터로 지정해서 처리한다.
		this(1, 10);
	}

	public Criteria(int pageNum, int amount) {
		// TODO Auto-generated constructor stub
		this.pageNum = pageNum;
		this.amount = amount;
	}
	
	// getTypeArr() 은 검색조건이 각 글자(T, W, C)로구성되어 있으므로 검색 조건을 배열로 만들어서 한꺼번에 처리하기 위함이다.
	public String[] getTypeArr() {
		return type==null? new String[] {} : type.split("");
	}
	
	//UriComponentsBuilder 를 이용하는 링크 생성! - 여러개의 파라미터들을 연결해서 URL 로 만들어준다.
	//게시물 삭제 후 페이지번호나 검색조건을 유지하면서 이동하기 위해서 'redirect' 에 필요한 파라미터들을 매번 추가해야하므로 UriComponentsBuilder 로 처리하기
	/*
	 * Criteria cri = new Critera(); 
	 * cir.setPageNum(3); ..... cri.setKeyworkd("TC"); 처럼 값을 입력받는다면, ?pageNum=3&........&keyword=TC 와 같은 값이 나온다.
	 * */
	public String getListLink() {
	//UriComponentsBuilder 는 브라우저에 GET방식 등의 파라미터 전송에 사용되는 문자열(쿼리스트링)을 쉽게 처리할 수있는 클래스이다.
		UriComponentsBuilder builder = UriComponentsBuilder.fromPath("")
				.queryParam("pageNum", this.pageNum)
				.queryParam("amount", this.getAmount())
				.queryParam("type", this.getType())
				.queryParam("keyword", this.getKeyword());
				
		return builder.toUriString();
	}
	
}
