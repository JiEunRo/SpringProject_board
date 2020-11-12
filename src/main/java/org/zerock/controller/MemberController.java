package org.zerock.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.zerock.domain.MemberVO;
import org.zerock.domain.AuthVO;
import org.zerock.domain.Criteria;
import org.zerock.domain.PageDTO;
import org.zerock.service.MemberService;

import lombok.AllArgsConstructor;
import lombok.Setter;
import lombok.extern.log4j.Log4j;

@RequestMapping("/member/*")
@Controller
@Log4j
@AllArgsConstructor
public class MemberController {
	
	private MemberService service;
	
	//비밀번호 암호화를 위한 인코딩
	@Setter(onMethod_ = @Autowired)
	private PasswordEncoder pwencoder;
	
	
	
	
	@GetMapping("/list")
	public void list(Criteria cri, Model model) {
		log.info("list : " + cri);
		model.addAttribute("list", service.getList(cri));
		
		// 멤버리스트에 pageNum , amount 를 쓰기위해서 cri 를 보냈다.
		model.addAttribute("cri" , cri);
		
		int total = service.getTotal(cri);
		
		log.info("total : " + total);
		model.addAttribute("pageMaker", new PageDTO(cri, total));
		model.addAttribute("total", total);
		
	}
	
	
	//등록한 후 화면에서 입력받아야하므로 GET방식으로 입력페이지를 볼 수 있도록 메서드 추가했다.
	@GetMapping("/register") 
	//@PreAuthorize("isAuthenticated()")
	public void register() {
		
	}
	
	
	@PostMapping("/register")
	//@PreAuthorize("isAuthenticated()")
	public String register(MemberVO member , AuthVO auth, RedirectAttributes rttr) {
		
		
		log.info("==================================");		
		log.info("REGISTER : " + member);	
		log.info("REGISTER : " + auth);	
		
		log.info("==================================");
		
		//비밀번호 암호화를 위한 인코딩 
		member.setUserpw( pwencoder.encode(member.getUserpw())  ); 		
		
		service.register(member , auth); //회원정보 및 권한 등록
		
		rttr.addFlashAttribute("result", member.getUserid()); // 새로 등록된 회원아이디 추가
		
		return "redirect:/member/list";
	}
	
	
	// 1명의 회원정보만 가져온다   -  수정/조회시 사용  / @RequestParam로 userid 를 보내줬다.
	@GetMapping({"/get", "/modify"})
	public void get (@RequestParam("userid") String userid, @ModelAttribute("cri") Criteria cri, Model model) {
		
		log.info("/get or /modify");
		
		model.addAttribute("member", service.get(userid));
		
		
	}
	
	
	
	/*
	 권한별 접근통제 어노테이션이지만, 로그인한 사용자와 현재 파라미터로 전달되는 작성자가 일치하는지 확인하기 위해
	 문자열로 표현식을 지정할 수 있는데 이때, 컨트롤러에 전다로디는 파라미터를 같이 사용할 수 있다.... 파라미터로  writer 를 추가해서 @PreAuthorize 로 검사하도록 하자!
	 */
	/*@PreAuthorize("principal.member.userName == #member.writer")*/	
	@PostMapping("/modify")	
	public String modify (MemberVO member, Criteria cri, RedirectAttributes rttr) {	//1. 수정화면에들어가서  VO객체로 던져주면, 
		log.info("Modify : " + member);
		
		if(service.modify(member)) { //modifiy 에서 수정하고.. 
			rttr.addFlashAttribute("result", "success"); //2. Result에 success를 출력하고 
		}
		
		return "redirect:/member/list" + cri.getListLink() ;	 //3. 완료되면 목록으로 돌아가게 한다.
	}
	
	
	
	
	/* @PreAuthorize("principal.member.userName == #writer") */
	@PostMapping("/remove")
	public String remove(@RequestParam("userid") String userid , Criteria cri, RedirectAttributes rttr, String writer){
		log.info("remove " + userid);
		
		if(service.remove(userid)) {
			rttr.addFlashAttribute("result", "success");
		}
		
		return "redirect:/member/list" + cri.getListLink() ;
	}
	
	
	
	
}
