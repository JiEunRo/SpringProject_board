<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!-- 게시물 작성시 로그인한 사용자의 아이디를 출력하기 위함 -->
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>

<%@include file="../includes/header.jsp" %>

<div class="row">
	<div class="col-lg-12">
		<h1 class="page-haeder">Member Register</h1>
	</div>
</div>

<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">Member Register Page</div>
			<div class="panel-body">
				
				<form role="form" action="/member/register" method="post" id="regiForm" name="regForm">
					<!-- POST 방식의 전송은 반드시!! CSRF 토큰을 사용하도록 해야합니당! -->
					<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
					
					<div class="form-group">
						<label>userid</label>
						<input class="form-control" name="userid" required />
					</div>
					
					<div class="form-group">
						<label>userpw</label>
						<input type="password" class="form-control" name="userpw" required />
					</div>
					
					<div class="form-group">
						<label>userpw 확인</label>
						<input type="password" class="form-control" name="userpw2" required />
					</div>
					
					<div class="form-group">
						<label>userName</label>
						<input class="form-control" name="userName" required />
					</div>
					
					<div class="form-group">
						<label>Auth</label>
						<select name="auth" class="form-control" required>
							<option value="ROLE_USER">ROLE_USER</option>
							<option value="ROLE_MEMBER">ROLE_MEMBER</option>
							<option value="ROLE_ADMIN">ROLE_ADMIN</option>
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
		
		
		
		
		$("button[data-oper='submit']").on("click", function(e){
			e.preventDefault();
			
			var userid = $("input[name='userid']").val();
			var userName = $("input[name='userName']").val();
			var userpw = $("input[name='userpw']").val();
			var userpw2 = $("input[name='userpw2']").val();
			
			console.log("여기" + (userpw == userpw2) + userpw.length ); //클릭시 테스트를 진행한다.
			
			if(userid.length == 0 || userid.length == null){
				alert("아이디를 입력해주세요");
				setTimeout(function(){
					$("input[name='userid']").focus();
				});	
				return;
			}
			
			if(userpw.length < 4 || userpw2.length < 4) {
				alert("비밀번호 길이를 4글자 이상 적어주세요.");
				if(userpw.length < 4){
					setTimeout(function(){ $("input[name='userpw']").focus(); });
				}else if(userpw2.length < 4){
					setTimeout(function(){ $("input[name='userpw2']").focus(); });
				}
				return;
			}
			
			if(userpw != userpw2){
				alert("비밀번호가 일치하지 않습니다.");
				setTimeout(function(){ $("input[name='userpw']").focus(); });
				return;
			}
				
			operForm.submit();
		});
		
	});
</script>

<%@include file="../includes/footer.jsp" %>