package org.zerock.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.zerock.domain.Criteria;
import org.zerock.domain.PageDTO;
import org.zerock.service.BoardService;
import org.zerock.service.MyLocService;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@AllArgsConstructor
public class MyLocController {


	private MyLocService service;
	
	
	@GetMapping("/locAdmin")
	public String locAdmin(Model model) {
		
		model.addAttribute("list", service.viewLoc());
		
		return "locAdmin";		
	}
	
}
