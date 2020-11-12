<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
    
    
<!-- p.671 JSP에서 로그인한 사용자 정보를 보여주자.-->
<%@taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<!-- 
https://to-dy.tistory.com/82?category=720806 에서 로그인한 사용자  id 보여주기 실험해봄
: pringContextHolder 를 사용해서 사용자 정보를 가져왔다.
pringContextHolder를 이용해서 Spring Security 자체적으로 제공하는 방법을 사용했다.
 -->
 <%--
<%@taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ page import="org.springframework.security.core.context.SecurityContextHolder" %>
<%@ page import="org.springframework.security.core.Authentication" %>

<%
	//spring security에서 자체적으로 제공하는 방법..  import 를 꼭 해줘야하낟.
	Authentication auth = SecurityContextHolder.getContext().getAuthentication();
	Object principal = auth.getPrincipal();	
	//auth.getPrincipal(); 함수를 통해 사용자 정보를 가져오고 리턴되는 객체는 2가지
	// 1. 인증하지 않은 상태 anonymousUser 란 문자열이 있는 String객체 리턴 / 2. 인증에 성공한 상태 : 로그인한 사용자의 정보가 담긴 Object 객체 리턴
	
	
	String name = "";
	if(principal != null){
		name = auth.getName();
	}
%>
 --%>
 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h3>/sample/admin page</h3>
	
	<p>principal : <sec:authentication property="principal"/></p>
	<p>MemberVO : <sec:authentication property="principal.member"/></p>
	
	<p>사용자이름 : <sec:authentication property="principal.member.userName"/></p>
	<p>사용자아이디 : <sec:authentication property="principal.member.userid"/></p>
	<p>사용자 권한 리스트 : <sec:authentication property="principal.member.authList"/></p>
	
	<a href="/customLogout">Logout</a>
	<%-- 
	<sec:authorize access="isAnonymous()"> <!-- 인증에 하지 않을 경우 -->
		<a href="/customLogin">로그인</a>
	</sec:authorize>
	<sec:authorize access="isAuthenticated()"> <!-- 인증에 성공했을 때 보이도록 했다. -->
		<a href="/customLogout">Logout</a>
		<p><sec:authentication property="principal.username"/>님, 반갑습니다.</p>
	</sec:authorize>
	 --%>
	 
	 
</body>
</html> 