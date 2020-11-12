<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%-- <%@taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
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
%> --%>

<!-- p.671 JSP에서 로그인한 사용자 정보를 보여주자.-->
<%@taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h3>/sample/all page</h3>
	
<!-- 	
hasRole('role1') -  권한(role1)을 가지고 있는 경우
hasAnyRole('role1', 'role2') -  권한들(role1, role2) 하나라도 가지고 있을 경우 (갯수는 제한없다)
pemitAll -  권한 있든 말든 모두 접근 가능하다.
denyAll -  권한 있든 말든 모두 접근 불가능하다
isAnonymous() -  Anonymous 사용자일 경우 (인증을 하지 않은 사용자)
isRememberMe()  -  Remember-me 기능으로 로그인한 사용자일 경우
isAuthenticated() -  Anonymous 사용자가 아닐 경우 (인증을 한 사용자)
isFullyAuthenticated() -  Anonymous 사용자가 아니고 Remember-me 기능으로 로그인 하지 않은 사용자 일 경우
  -->
	
	<sec:authorize access="isAnonymous()"> <!-- 인증에 하지 않을 경우 -->
		<a href="/customLogin">로그인</a>
	</sec:authorize>
	
	<sec:authorize access="isAuthenticated()"> <!-- 인증에 성공했을 때 보이도록 했다. -->
		<a href="/customLogout">Logout</a>
		<p><sec:authentication property="principal.member.userName"/>님, 반갑습니다.</p>
	</sec:authorize>
	
</body>
</html>