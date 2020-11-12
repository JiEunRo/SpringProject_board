<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h3>/sample/member page</h3>
	
	<sec:authorize access="isAnonymous()"> <!-- 인증에 하지 않을 경우 -->
		<a href="/customLogin">로그인</a>
	</sec:authorize>
	
	<sec:authorize access="isAuthenticated()"> <!-- 인증에 성공했을 때 보이도록 했다. -->
		<a href="/customLogout">Logout</a>
		<p><sec:authentication property="principal.member.userName"/>님, 반갑습니다.</p>
	</sec:authorize>
	
</body>
</html>