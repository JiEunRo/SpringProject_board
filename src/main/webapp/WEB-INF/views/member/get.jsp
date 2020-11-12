<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!-- 게시물 작성시 로그인한 사용자의 아이디를 출력하기 위함 -->
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>

<%@include file="../includes/header.jsp" %>

<div class="row">
	<div class="col-lg-12">
		<h1 class="page-haeder">Member Detail View</h1>
	</div>
</div>

<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">Member Detail View Page</div>
			<div class="panel-body">
				
				<form role="form" action="/member/register" method="post" id="regiForm" name="regForm">
					<!-- POST 방식의 전송은 반드시!! CSRF 토큰을 사용하도록 해야합니당! -->
					<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
					
					<div class="form-group">
						<label>userid</label>
						<input class="form-control" name="userid" value="<c:out value='${member.userid}' />" />
					</div>
					
					<!-- 
					<div class="form-group">
						<label>userpw</label>
						<input type="password" class="form-control" name="userpw" value="" />
					</div>
					
					<div class="form-group">
						<label>userpw 확인</label>
						<input type="password" class="form-control" name="userpw2" value="" />
					</div>
					 -->
					 
					<div class="form-group">
						<label>userName</label>
						<input class="form-control" name="userName" value="<c:out value='${member.userName}' />" />
					</div>
					
					<div class="form-group">
						<label>Auth</label>
						<input type="text" class="form-control" name="auth" value="<c:out value='' />" />
						
						
							<select name="auth" class="form-control" required>
								<option value="ROLE_USER" ${member.authList[0].auth eq 'ROLE_USER' ? 'selected' : ''} >ROLE_USER</option>
								<option value="ROLE_MEMBER" ${member.authList[0].auth eq 'ROLE_MEMBER' ? 'selected' : ''}>ROLE_MEMBER</option>
								<option value="ROLE_ADMIN" ${member.authList[0].auth eq 'ROLE_ADMIN' ? 'selected' : ''}>ROLE_ADMIN</option>
							</select>
						
						
						
					</div>
					
					<button type="button" data-oper="submit" class="btn btn-success">Submit</button>
					<button type="reset" class="btn btn-default">Reset</button>
					
				</form>
				
			</div>
		</div>
	</div>
</div>


<script type="text/javascript">
	$(document).ready(function(){
		var operForm = $("#regiForm");
		
		
		
	});
</script>

<%@include file="../includes/footer.jsp" %>