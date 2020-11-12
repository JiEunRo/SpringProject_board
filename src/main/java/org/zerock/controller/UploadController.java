package org.zerock.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import javax.xml.ws.Response;

import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.stereotype.Repository;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.zerock.domain.AttachFileDTO;

import lombok.extern.log4j.Log4j;
import net.coobird.thumbnailator.Thumbnailator;

//여기가 컨트롤러임을 알려 스프링에서 관리하는 클래스로 지정한다 -> 자동으로 스프링 객체(빈)등록
//servlet-context.xml에서 <context:component-scan>태그를 통해 해당 패키지를 스캔하도록 설정..
@Controller 
@Log4j
public class UploadController {
	// GET방식으로 첨부파일을 첨부할 수 있는 화면을 처리하는 메서드와 POST방식으로 첨부파일 업로드를 처리하는 메서드를 추가하자.
	
	/******************************* <form>태그를 이용한 방식 ***********************************/
	// GET방식으로 첨부파일을 첨부할 수 있는 화면 처리
	@GetMapping("/uploadForm")
	public void uploadForm() {
		log.info("upload form");
	}
	
	// POST방식으로 파일 업로드를 처리하는 메서드
	// 파일처리는 스프링에서 제공하는 MultipartFile 타입을 이용하고, 첨부파일을 여러개 선택가능하므로 배열타입으로 설정한다.
	@PostMapping("/uploadFormAction")
	public void uploadFormAction(MultipartFile[] uploadFile, Model model) {
		
		String uploadFolder = "C:\\upload";
		
		for(MultipartFile multipartFile : uploadFile) {
			log.info("=======================================");
			log.info("업로드 파일 이름 : " + multipartFile.getOriginalFilename() );
			log.info("업로드 파일 사이즈  : " + multipartFile.getSize());
			
			//java.io.File 의 객체를 지정했다..  File(String s1,String s2) >> s1폴더경로의 s2라는 파일에 대한 File 객체 생성
			File saveFile = new File(uploadFolder, multipartFile.getOriginalFilename());
			
			try {
				multipartFile.transferTo(saveFile);
			} catch (Exception e) {
				log.error(e.getMessage());
			} //End catch
			
		}//End for
		
	}//End uploadFormAction
	
	
	
	
	/****************************************** Ajax를 이용한 파일 업로드방법  ********************************************/
	
	@GetMapping("/uploadAjax")
	public void uploadAjax() {
		log.info("upload Ajax");
	}
	
	
	// 한 폴더 내에 너무 많은 파일이 생성되는 것을 막기 위해 java.io.File 의 mkdir()을 이용하여 "년/월/일 폴더의 생성" 을 진행한다.
	// 오늘 날짜의 경로를 문자열로 생성하자
	private String getFolder() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date date = new Date();
		String str = sdf.format(date);
		return str.replace("-", File.separator); //  File.separator는 \, /같은 파일의 경로를 분리해주는 메소드이다.  참고로 File.pathSeparator는 ; 로 구분
																	// 그러니까 - 대신에 /로 경로를 만들어준다. 예시로 2020-10-05 이면 2020폴더 > 10폴더 > 05폴더 를 만든다.
	}
	
	
	//이미지 첨부파일을 등록시 썸네일 생성되어야하므로 라이브러리 추가 후 1. 이미지파일인지 체크 2.이미지파일이면 썸네일 생성 후 저장한다.
	// 특정파일이 이미지 파일인지 검사하는 함수 만들기
	private boolean checkImageType(File file) {
		
		try {
			String contentType = Files.probeContentType(file.toPath()); // toPath()는 java.io.file.Path 객체로 변환 , probeContentType() 메서드는 파일의 확장자를 이용해서 마입타입 확인한다.
			return contentType.startsWith("image"); //startWith() 메서드는 특정 문자나 문자열로 시작하는지 체크하는 메서드이다.
			
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return false;
	}
		
	
	/*** 아작스로 파일 업로드하기 ***/
	@PostMapping("/uploadAjaxAction")
	public void uploadAjaxAction(MultipartFile[] uploadFile) {
		
		log.info("UPDATE AJAX POST ============================");
		
		String uploadFolder = "C:\\upload";
		
		//폴더 만들기
		File uploadPath = new File(uploadFolder, getFolder()); // File(File f, String s)는 f객체 폴더의 s라는 파일에 대한 File 객체를 생성한다.
		log.info("업로드 경로 : " + uploadPath);
		
		//yyyy-MM-dd 폴더를 만들자
		if(uploadPath.exists() == false) { // exists() 는 해당 파일이 있으면 True를 반환하고, 그렇지 않으면 False를 반환한다.
			uploadPath.mkdirs(); // 같은 이름의 파일이 없으면 디렉토리를 만들어라!
		}
		
		
		for(MultipartFile multipartFile : uploadFile) {
			log.info("=======================================");
			log.info("업로드 파일 이름 : " + multipartFile.getOriginalFilename() );
			log.info("업로드 파일 사이즈  : " + multipartFile.getSize());
			
			String uploadFileName = multipartFile.getOriginalFilename();
			
			//익스에서 경로까지 출력되므로, 경로빼고 파일명만 나오도록 하기 위함.. 마지막 \을 기준으로 잘라낸 문자열이 실제 파일이름!
			uploadFileName = uploadFileName.substring(uploadFileName.lastIndexOf("\\") +1);
			log.info("only file name : " + uploadFileName);
			
			
			//파일 이름 생성시, 동일한 이름의 파일이 올라가면 기존파일이 지워지므로 이를 위해서 java.util.UUID값을 이용해보자.
			UUID uuid = UUID.randomUUID(); //randomUUID() 를 통해서 임의의 값(난수번호) 생성
			uploadFileName = uuid.toString() + "_" + uploadFileName;	//파일이름 = 임의의값_파일이름 으로 구분하기 위해 넣기
			
			
			try {
				//java.io.File 의 객체를 지정했다..  File(String s1,String s2) >> s1폴더경로의 s2라는 파일에 대한 File 객체 생성
				// File saveFile = new File(uploadFolder, uploadFileName); // 경로를 uploadFolder 로 해버리면 그냥 /upload 에 저장되니까, 
				File saveFile = new File(uploadPath, uploadFileName); //위에서 만든 yyyy-MM-dd폴더에 저장하기위해 uploadPath 로 지정한다
				
				multipartFile.transferTo(saveFile); //transferTo () 메서드는 업로드한 File Data를 지정한 File(saveFile)에 저장한다.
				
				//checkImageType() 함수를 통해 해당 경로의 파일이 이미지 파일인지 체크한다.
				if(checkImageType(saveFile)) {
					
					 // FileOutputStream - 데이터를 파일에 바이트스트림으로 저장하기 위해 사용한다.
					FileOutputStream thumbnail = 
							new FileOutputStream(new File(uploadPath, "s_" + uploadFileName));
							// FileOutputStream(File f) > 주어진 File 객체가 가리키는 파일을 쓰기 위한 객체를 생성. 기존의 파일이 존재할 때는 그 내용을 지우고 새로운 파일을 생성.
							// 그러니까, uploadPath (경로)에 s_파일이름 으로 새로운 파일을 만든다는 뜻!
					
					Thumbnailator.createThumbnail(multipartFile.getInputStream(), thumbnail, 100, 100);
					// 썸네일 생성 - createThumbnail(InputStream, File객체의  가로, 세로) 썸네일 생성 메서드
					
					thumbnail.close(); //꼭 달아주기
				}
				
			} catch (Exception e) {
				log.error(e.getMessage());
			} //End catch
			
		}//End for
		
	}//End uploadAjaxAction
	
	
	
	/********************** AttachFileDTO 의 리스트를 반환하는 구조로 변경하자 ********************************/
	@PreAuthorize("isAuthenticated()")
	@PostMapping(value = "/uploadAjaxActionList" , produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public ResponseEntity<List<AttachFileDTO>> uploadAjaxPost (MultipartFile[] uploadFile){
		
		log.info("파일을 업로드하자==========================");
		
		List<AttachFileDTO> list = new ArrayList<>();
		String uploadFolder = "c:\\upload";
		
		String uploadFolderPath = getFolder();
		
		//폴더를 만들자.
		File uploadPath = new File(uploadFolder, uploadFolderPath);
		
		// uploadPath에 해당파일이 없다면! 파일을 만들자
		if(uploadPath.exists() == false) {
			uploadPath.mkdirs();
		}
		
		// yyyy/MM/dd 폴더를 만들자!
		for(MultipartFile multipartFile : uploadFile) {
			AttachFileDTO attachDTO = new AttachFileDTO();
			
			String uploadFileName = multipartFile.getOriginalFilename();
			
			// 익스에서 경로가 쭉 나오니까 파일명만 추출할꺼야
			uploadFileName = uploadFileName.substring(uploadFileName.lastIndexOf("\\") +1);
			log.info("파일이름만  : " + uploadFileName);
			attachDTO.setFileName(uploadFileName);//파일이름 지정
			
			// 중복되는 파일명을 없애기 위해 uuid 를 넣자
			UUID uuid = UUID.randomUUID();
			uploadFileName = uuid.toString() + "_" + uploadFileName;
			
			
			
			try {
				
				// File(File f , String s) 로 F폴더(경로)에 S라는 파일에 대한 객체를 만든다.
				File saveFile = new File(uploadPath, uploadFileName);
				// transferTo()로업로드한 파일을 지정한 파일에 저장하자.
				multipartFile.transferTo(saveFile);
				
				attachDTO.setUuid(uuid.toString());			// 난수번호 설정
				attachDTO.setUploadPath(uploadFolderPath);	//파일 경로 설정
				
				//파일이 이미지인지 체크하자.
				if(checkImageType(saveFile)) {
					attachDTO.setImage(true);
					
					//썸네일을 만들거야, 먼저, FileOutputStream타입의 thumnail에 주어진 File객체가 가르키는 파일을 쓰기위해 객체를 생성하고, 기존 파일이 존재하면 내용을 지우고 새로운 파일을 생성할꺼야. (s_파일이름)
					FileOutputStream thumbnail = new FileOutputStream(new File(uploadPath, "s_"+uploadFileName));
					
					//썸네일을 만들자, 인풋스트림(multipartFile 을 읽는다)을 만들고, 썸네일에 100*100 사이즈로 만들자
					Thumbnailator.createThumbnail(multipartFile.getInputStream(), thumbnail, 100 , 100);
					
					//제일 중요함.. 꼭 close()
					thumbnail.close();					
				}
				
				//AttachDTO 리스트에 담자!
				list.add(attachDTO);
				
			} catch (IllegalStateException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
		}
		
		
		
		return new ResponseEntity<> (list, HttpStatus.OK); 
	}
	
	
	
	
	/********************** 썸네일 데이터 전송하기 - GET방식, URI/경로/UUID/이미지태그처리 ********************************/
	/*
	 * ResponseEntity
	 * Spring Framework에서 제공하는 클래스 중 HttpEntity라는 클래스가 존재한다.
	 * 이는 HTTP요청(Request) , 응답(Response)에 해당하는 HttpHeader , HttpBody 를 포함하는 클래스이다.
	 * HttpEntity라는 클래스를 상속받아 구현한 클래스가 RequestEntity , ResponseEntity 이다
	 * 
	 *  ResponseEntity는 당연히 사용자의 HttpRequest에 대한 응답 데이터를 포함하는 클래스이다.
	 *  HttpStatus , HttpHeader, HttpBody 를 포함한다.
	 *  우리는 ResponseEntity를 이용하여 FileDownload를 제공하는 응답을 만들어낸다.
	 */
	
	
	@GetMapping("/display")  //썸네일 데이터 호출은 /display?fileName=년/월/일/파일이름 으로 호출해서 볼 수 있다.
	@ResponseBody
	public ResponseEntity<byte[]> getFile(String fileName){
		
		log.info("파일이름 출력 : " + fileName);  //파일 이름 로그 출력
		
		File file = new File("C:\\upload\\"+fileName); //file 변수 에 경로를 추가한다.
		log.info("파일 경로 출력하기 : " + file); //경로 로그 출력
		
		ResponseEntity<byte[]> result = null;
		
		//HttpHeaders >> HTTP 요청 또는 응답 헤더를 나타내는 데이터 구조로, 문자열 헤더 이름을 문자열 값 목록에 매핑하고 공통 애플리케이션 수준 데이터 유형에 대한 접근자를 제공합니다.
		HttpHeaders header = new HttpHeaders(); 
		
		try {
			//add() > 헤더 이름의 값 목록에 헤더 값을 추가합니다.
			//Content-Type > 클라이언트에게 반환된 컨텐츠의 컨텐츠 유형이 무엇인지 알려주기 위함
			// File 의 probeContentType() 을 통해 파일의 확장자를 이용해서  적절한 MIME타입을 확인 후 데이터를 Http헤더 메세지에 포함할 수 있도록 처리 / 
			// toPath()는 java.io.file.Path 객체로 변환 
			header.add("Content-Type", Files.probeContentType(file.toPath()));  //Content-Type: image/png 를 헤더에서 볼 수 있다.
								
								//ResponseEntity<> (body, headers, statuscode); 
			result = new ResponseEntity<>(FileCopyUtils.copyToByteArray(file), header, HttpStatus.OK);
								//FileCopyUtils 는 파일 및 스트림 복사를 위한 유틸리티 메소드 집합체이다. 
								// copyToByteArray(file) 메서드는 지정한 input인 File의 내용을 새로운 Byte[] 로 복사한다 리턴값으 copy된 새로운 byte[]이다.
			
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return result;		
	}
	
	
	
	
	/********************** 첨부파일 다운로드 ********************************/
	@GetMapping(value="/download" , produces = MediaType.APPLICATION_OCTET_STREAM_VALUE)
	@ResponseBody				
																				//IE에서 한글파일의 이름이 깨져서 보이므로 HTTP헤더메세지 중 디바이스 헤더 정보를 알 수 있는 userAgent 값을 이용하자
	public ResponseEntity<Resource> downloadFile(@RequestHeader("User-Agent") String userAgent, String fileName){
		// 파일이름 출력
		log.info("다운로드할 파일 이름 : " + fileName);
		
		// org.springframework.core.io.Resource 타입 >> 스프링에서 Resource 접근/생성/관리하도록 해주는 것? 같다.
		// org.springframework.core.io.FileSystemResource 클래스를 통해 파일시스템의 특정 파일로부터 정보를 읽어오는 클래스이다.
		Resource resource = new FileSystemResource("C:\\upload\\" + fileName);
		log.info("다운로드 파일 리소스 : " + resource);
		
		// resource.exists 는 해당 파일이 없으면 false 를 출력하므로, 찾을 수 없다는 상태메세지를 출력한다.
		if(resource.exists() == false) {
			log.info("다운로드할 파일을 찾을 수 없습니다.");
			return new ResponseEntity<Resource>(HttpStatus.NOT_FOUND);
		}
		
		// 파일이름 변수에 저장
		String resourceName = resource.getFilename();
		
		//첨부파일 다운로드시 UUID 를 지우고 다운로드 해야하므로 이에 대한 처리를 해주자
		// uploadFileName 에서 우리가 uuid 를 넣을 때 구분을 위해 _ 를 넣었으니까  _ 를 찾아서 짤라주자. 이것이 uuid 를 제외한 파일이름!
		String resourceOriginalName = resourceName.substring(resourceName.indexOf("_") + 1);
		
		HttpHeaders headers = new HttpHeaders();
		
		try {
			
			String downloadName = null;
			
			//브라우저별로 첨부파일을 처리해줘야한다. 
			if(userAgent.contains("MSIE") || userAgent.contains("Trident")) { //익스11부터는 브라우저 이름이 Trident 로 바꼇음..
				log.info(" IE Browser ");
				downloadName = URLEncoder.encode(resourceOriginalName,"UTF-8").replaceAll("\\+", " ");
			}else if(userAgent.contains("Edge")) {
				log.info("Edge Browser");
				downloadName = URLEncoder.encode(resourceOriginalName, "UTF-8");
				log.info("Edge Name : " + downloadName);
			} else {
				log.info("Chrome Browser");
				downloadName = new String(resourceOriginalName.getBytes("UTF-8"), "ISO-8859-1");
			}
			
			log.info("다운로드한 파일 이름 : " + downloadName);
			
			
			//headers.add("Content-Disposition", "attachment; filename="+new String(resourceName.getBytes("UTF-8"), "ISO-8859-1"));
			//위에서 if 문으로 엣지/익스/크롬별로 파일 이름을 설정했으니까 아래처럼 변경
			headers.add("Content-Disposition", "attachment; filename="+downloadName);
			
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return new ResponseEntity<Resource>(resource, headers, HttpStatus.OK);
		
	}
	
	
	
	/********************** 첨부파일 삭제 ********************************/
	@PreAuthorize("isAuthenticated()")
	@PostMapping("/deleteFile")
	@ResponseBody
	public ResponseEntity<String> deleteFile(String fileName, String type){
		//삭제할 파일 이름 확인
		log.info("삭제할 파일은 : " + fileName);
		
		//파일 객체 생성
		File file;
		
		try {
			// 파일 경로와 파일이름을 인토딩 시켜준다.
			file = new File("C:\\upload\\" + URLDecoder.decode(fileName, "UTF-8"));
			
			
			if( file.exists() ){
				if(file.delete()){
					log.info("파일삭제 성공");
				}else{ 
					log.info("파일삭제 실패"); 
				} 
			}else{ 
				log.info("파일이 존재하지 않습니다.");
			}
			
			//만약 파일 타입이 이미지라면
			if(type.equals("image")) {
				//썸네일 말고 업로드한 이미지도 삭제해줘야하니까
				String largetFileName = file.getAbsolutePath().replace("s_", "");
				log.info("원본 파일 이름 : " + largetFileName);
				
				file = new File(largetFileName);
				
				if( file.exists() ){
					if(file.delete()){
						log.info("파일삭제 성공");
					}else{ 
						log.info("파일삭제 실패"); 
					} 
				}else{ 
					log.info("파일이 존재하지 않습니다.");
				}
			}
			
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
		return new ResponseEntity<String>("deleted" , HttpStatus.OK);
	}
	
	
}
