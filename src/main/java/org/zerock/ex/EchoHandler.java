package org.zerock.ex;

import java.util.ArrayList;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;


/* TextWebSocketHandler를 상속받아서 사용하고
 * 클라이언트 접속 할 때, 메세지 보낼때, 접속 끊었을 때 각각 override 된 메서드 동작
 *  */


@RequestMapping("/ex")
public class EchoHandler  extends TextWebSocketHandler{
	
	//세션리스트
	private List<WebSocketSession> sessionList = new ArrayList<WebSocketSession>();
	
	private static Logger logger = LoggerFactory.getLogger(EchoHandler.class);
	
	
	//클라이언트가 연결되었을 때 실행
	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception{
		sessionList.add(session);
		logger.info("{} 연결됨", session.getId() );
	}
	
	//클라이언트가 웹소캣 서버로 메세지를 전송했을 때 실행
	@Override
	public void handleTextMessage(WebSocketSession session , TextMessage message) throws Exception{
		logger.info("{}로부터 {} 받음" , session.getId(), message.getPayload() );
		for(WebSocketSession sess : sessionList) {
			sess.sendMessage(new TextMessage(message.getPayload()));
		}
	}
	
	//클라이언트 연결을 끊었을 때 실행
	@Override
	public void afterConnectionClosed(WebSocketSession session , CloseStatus status) throws Exception{
		sessionList.remove(session);
		logger.info("{} 연결 종료" , session.getId() );
	}
}
