package org.zerock.task;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.zerock.domain.BoardAttachVO;
import org.zerock.mapper.BoardAttachMapper;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

//Quartz 라는 라이브러리를 이용하여 잘못 첨부된 파일을 주기적으로 체크하여 삭제하기 위해 클래스를 처리했다.

@Log4j
@Component
public class FileCheckTask {
	
	
	@Setter(onMethod_ = @Autowired)
	private BoardAttachMapper attachMapper;
	
	//어제 사용된 파일의 목록을 얻어오자.
	private String getFolderYesterDay() {
		//데이터 날짜 포맷을 맞추자
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		
		// Calendar 객체 이용을 위해서 Calendar.getInstance() 를 설정하면 현재 날짜가 출력된다.
		Calendar cal = Calendar.getInstance();
		cal.add(Calendar.DATE, -1); //여기서 -1 을 하면 어제 날짜가 되고
		
		String str = sdf.format(cal.getTime()); //cal.getTime()을 통해 어제날짜를 가져와서 sdf 변수처럼 포맷을 맞춘다.
		
		return str.replace("-", File.separator);  // - 문자를 File.separator(파일구분자 / 나 \ ) 로 대치한다.
		
	}
	
	
	
	
	/*
	 * @Scheduled 어노테이션 내에는 cron이라는 속성을 부여해서 주기를 제어한다 .
	 * @Scheduled(cron="0 * * * * *") 을 분석하자면, 
	 * @Scheduled(cron="초(0-59) 분(0-59) 시(0-23) 일(1-31) 주(1-7) 년(옵션)") //해당부분은 601 페이지 확인
	 * FileCheckTask가 정상적으로 동작하는지 확인하기 위해서 root-context.xml에 FileCheckTask를 스프링의 빈으로 설정
	 * cron 설정은 위의 경우 매분 0초마다 한 번씩 실행되도록 지정되었으므로, 서버를 실행해 두고 1분에 한 번씩 로그가 기록되는지를 확인한다.
	 * 그리고 가만히 있으면 아래 로그가 기록될 것이다. 
	 */
	@Scheduled(cron="0 0 2 * * *")	//2시간에 한번씩 체크하자
	public void checkFiles()throws Exception{
		log.warn("File Check Task run. . . . . . . . . . . . . .");
		log.warn(new Date());
		
		// 데이터베이스의 파일 리스트
		List<BoardAttachVO> fileList = attachMapper.getOldFiles();
		
		// 데이터파일 리스트와 디렉토리 안의 파일을 체크하자
		List<Path> fileListPaths = fileList.stream().map(vo -> Paths.get("C:\\upload", vo.getUploadPath(), vo.getUuid() + "_" + vo.getFileName()))
																		.collect(Collectors.toList());
		
		//이미지 파일의 썸네일 파일
		fileList.stream().filter(vo -> vo.isFileType() == true).map(vo -> Paths.get("C:\\upload", vo.getUploadPath(), "s_"+ vo.getUuid() + "_" + vo.getFileName()))
																												.forEach(p -> fileListPaths.add(p));
		
		log.warn("==============================================");
		
		fileListPaths.forEach(p -> log.warn(p));
		
		//어제 폴더에 파일
		File targetDir = Paths.get("C:\\upload", getFolderYesterDay()).toFile();
		
		File[] removeFiles = targetDir.listFiles(file -> fileListPaths.contains(file.toPath()) == false);
		
		
		log.warn("==============================================");
		
		// 파일을 삭제한다.
		for(File file : removeFiles) {
			log.warn(file.getAbsolutePath());
			file.delete();
		}
		
	}
	
}
