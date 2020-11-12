package org.zerock.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.zerock.domain.MyLocVO;
import org.zerock.mapper.MyLocMapper;

import lombok.AllArgsConstructor;
import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Log4j
@Service
@AllArgsConstructor
public class MyLocServiceImpl implements MyLocService{

	
	@Setter(onMethod_ = @Autowired ) 
	private MyLocMapper mapper;

	@Override
	public List<MyLocVO> viewLoc() {
		
		log.info("리스트를 읽자 ===============");
		
		return mapper.viewLoc();
	} 
	
	
	
	
	
	
	
	

}
