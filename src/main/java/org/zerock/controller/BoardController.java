package org.zerock.controller;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.zerock.domain.BoardAttachVO;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;
import org.zerock.domain.PageDTO;
import org.zerock.service.BoardService;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@RequestMapping("/board/*")
@Controller
@Log4j
@AllArgsConstructor
public class BoardController {
	
	private BoardService service;
	
	/*
	@GetMapping("/list")
	public void list(Model model) {
		log.info("list");
		model.addAttribute("list", service.getList());
	}
	*/
	
	@GetMapping("/list")
	public void list(Criteria cri, Model model) {
		log.info("list : " + cri);
		model.addAttribute("list", service.getList(cri));
		//model.addAttribute("pageMaker" , new PageDTO(cri, 123));
		
		int total = service.getTotal(cri);
		
		log.info("total : " + total);
		model.addAttribute("pageMaker", new PageDTO(cri, total));
		model.addAttribute("total", total);
		
	}
	
	
	//등록한 후 화면에서 입력받아야하므로 GET방식으로 입력페이지를 볼 수 있도록 메서드 추가했다.
	@GetMapping("/register") 
	@PreAuthorize("isAuthenticated()")
	public void register() {
		
	}
	
	
	//입력한값이 BoardVO객체에 들어가고, RedirectAttribute 로 이동을 한다.. 
	@PostMapping("/register")
	@PreAuthorize("isAuthenticated()")	//권한별로 접근을 통제하는 어노테이션 - 로그인을 성공한 사람만 기능을 사용할 수 있도록
	public String register(BoardVO board , RedirectAttributes rttr) {
		
		// 6-1. IP 주소 넘겨주기 Homecontroller.java 에서 추가한 코드를 붙여넣는다.
		HttpServletRequest req = ((ServletRequestAttributes)RequestContextHolder.currentRequestAttributes()).getRequest();
		String ip = req.getHeader("X-FORWARDED-FOR");
		if (ip == null)
			ip = req.getRemoteAddr();
		
		board.setIp(ip);	// 6-3. 아이피 값을 set한다
		
		log.info("==================================");		
		log.info("등록 : " + board);	// 6-2. board 에 IP 주소 값은 현재 null 이다.. 어떻게 넣으면 될까?
		
		//첨부파일이 있다면, 데이터가 제대로 수집된지 로그를 통해 확인하자.
		if(board.getAttachList() != null){
			board.getAttachList().forEach(attach -> log.info("첨부파일 데이터 수집 정보 : " + attach));
		}
		
		log.info("==================================");
		
		
		service.register(board);
		
		
		rttr.addFlashAttribute("result", board.getBno()); //새로 게시된 글 번호를 입력 해준다..
		
		return "redirect:/board/list"; //리다이렉트 : 목록으로 돌아가라
	}
	
	//1개의 게시물만 가져온다.
	@GetMapping({"/get", "/modify"})
	public void get (@RequestParam("bno") Long bno, @ModelAttribute("cri") Criteria cri, Model model) {
		log.info("/get or /modify");
		model.addAttribute("board", service.get(bno));
	}
	
	
	
	
	
	@PreAuthorize("principal.member.userName == #board.writer")	
	@PostMapping("/modify")						/*@ModelAttribute("cri") */
	public String modify (BoardVO board, Criteria cri, RedirectAttributes rttr) {	//1. 수정화면에들어가서  VO객체로 던져주면, 
		log.info("Modify : " + board);
		
		if(service.modify(board)) { //modifiy 에서 수정하고.. 
			rttr.addFlashAttribute("result", "success"); //2. Result에 success를 출력하고 
		}
		
		/*
		 // UniComponentsBuilder 는 여러 파라미터를 모아 URL 로 만들어주니까..
		rttr.addAttribute("pageNum", cri.getPageNum());
		rttr.addAttribute("amount", cri.getAmount());
		rttr.addAttribute("type", cri.getType());
		rttr.addAttribute("keyword", cri.getKeyword());
		*/
		return "redirect:/board/list" + cri.getListLink() ;	 //3. 완료되면 목록으로 돌아가게 한다.
	}
	
	
	
	
	
	/*
	 권한별 접근통제 어노테이션이지만, 로그인한 사용자와 현재 파라미터로 전달되는 작성자가 일치하는지 확인하기 위해
	 문자열로 표현식을 지정할 수 있는데 이때, 컨트롤러에 전다로디는 파라미터를 같이 사용할 수 있다.... 파라미터로  writer 를 추가해서 @PreAuthorize 로 검사하도록 하자!
	 */
	//게시물을 삭제하자.
	@PreAuthorize("principal.member.userName == #writer")	
	@PostMapping("/remove")											/*@ModelAttribute("cri") */
	public String remove(@RequestParam("bno") Long bno , Criteria cri, RedirectAttributes rttr, String writer){
		log.info("remove " + bno);
		
		//첨부파일
		List<BoardAttachVO> attachList = service.getAttachList(bno);
		
		if(service.remove(bno)) {
			
			//게시물을 삭제하면 게시물에 등록된 첨부파일도 모두 삭제하자
			deleteFiles(attachList);
						
			rttr.addFlashAttribute("result", "success");
		}
		/*
		rttr.addAttribute("pageNum", cri.getPageNum());
		rttr.addAttribute("amount", cri.getAmount());
		rttr.addAttribute("type", cri.getType());
		rttr.addAttribute("keyword", cri.getKeyword());
		*/
		return "redirect:/board/list" + cri.getListLink() ;
	}
	
	
	
	/*
	 * 특정한 게시물 번호를 이용해서 첨부파일과 관련 데이터를 JSON 으로 변환하여 처리하자. 
	 */
	@GetMapping(value = "/getAttachList" , produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public ResponseEntity<List<BoardAttachVO>> getAttachList(long bno){
		log.info("특정 게시물 번호로 첨부파일데이터를 얻을거야 : " + bno);
		return new ResponseEntity<>(service.getAttachList(bno), HttpStatus.OK);
		
	}
	
	
	
	/*
	 * 첨부파일 삭제를 처리하기위함.
	 * deleteFiles() 를 추가해서 처리할 것이다.
	 */
	private void deleteFiles(List<BoardAttachVO> attachList) {
		
		//첨부파일이 없다면 종료
		if(attachList == null || attachList.size() == 0) {
			return;
		}
		
		log.info("삭제할 파일 리스트 출력 ==========================================");
		log.info(attachList);
		
		attachList.forEach(attach -> {
			
			//삭제하려는 파일의 경로를 얻고
			Path file = Paths.get("C:\\upload\\"+attach.getUploadPath()+"\\"+attach.getUuid()+"_"+attach.getFileName());
			
			try {
				//파일을 삭제하자
				Files.deleteIfExists(file);
				
				//만약 이미지라면 썸네일도 삭제하자!
				if(Files.probeContentType(file).startsWith("image")) {
					Path thumbNail = Paths.get("C:\\upload\\"+attach.getUploadPath()+"\\s_"+attach.getUuid()+"_"+attach.getFileName());
					Files.delete(thumbNail);
				}
				
			} catch (IOException e) {
				log.error("삭제하려는 파일이 에러가 났습니다. " + e.getMessage());
			}
			
		});
		
	}
	
	
	
}
