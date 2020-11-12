<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@taglib uri="http://java.sun.com/jsp/jstl/core"  prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>Login Page</title>

    <!-- Bootstrap Core CSS -->
    <link href="/resources/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">

    <!-- MetisMenu CSS -->
    <link href="/resources/vendor/metisMenu/metisMenu.min.css" rel="stylesheet">

    <!-- Custom CSS -->
    <link href="/resources/dist/css/sb-admin-2.css" rel="stylesheet">

    <!-- Custom Fonts -->
    <link href="/resources/vendor/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
        <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
</head>


<body onload="document.f.username.focus();">	<!-- 문서가 로딩되면 : 문서내 이름이 f인 것 안의 username에 포커스가 가게 해라. -->

<div class="container">
        <div class="row">
            <div class="col-md-4 col-md-offset-4">
                <div class="login-panel panel panel-default">
                    <div class="panel-heading">
                        <h4 class="panel-title">Please Sign In</h4>
                        
                         <c:if test="${param.logout != null}">
					    	<p style="padding-top:5px;">정상적으로 로그아웃 되었습니다.</p>
					    </c:if>
						<c:out value="${error}" /> <%-- <c:out value="${logout}" /> --%>
                    </div>
                    <div class="panel-body">
						<form name="f" role="form" method="post" action="/login"><!-- 실제 로그인 작업은 /login 에서 이루어지므로 action 속성 지정 , 로그인은 반드시 post 방식으로 전송! -->
							<fieldset>
                                <div class="form-group"><input required type="text" class="form-control" placeholder="userid" name="username"  /></div>
                                <div class="form-group"><input required type="password" class="form-control" placeholder="password" name="password"  /></div>
                                <div class="checkbox"><label for="remember-me"><input type="checkbox" name="remember-me" id="remember-me">Remember Me</label></div>
								<!-- <a href="index.html" class="btn-login btn btn-lg  btn-success btn-block">Login</a> -->
								<button class="btn  btn-lg btn-success btn-block" >Login</button><!-- 필수입력 창을 띄우려고.. -->
							</fieldset>
							<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token }" />
							<!--	
								CSRF 토큰값!!!
								${_csrf.parameterName} 으로 처리하는데 이 EL값은 실제 브라우저에서 _csrf 라는 이름으로 처리된다.. 
								브라우저에서 소스보기를 하면 아래와 같은 태그값이 생성된 것을 볼 수 있고.. value 값은 임으로 지정된 값이다. 
								<input type="hidden" name="_csrf" value="a9bb5879-22b8-4138-994c-8c11362c0d06" />
							-->
							
							<!-- 
								** 위 4가지 <input>들은 꼭 있어야하고, 홈페이지 제작시 로그인 화면 페이지 자체는 꼭 있어야한다.(메인에서 작게 로그인폼을 만들더라도!)
								로그인 시 Srping security 를 설정해줘야한다.. 인증을 꼭 하고 들어가야하는 페이지가 있다면 여기로 연결되어야하므로!
							 -->
							
						</form>
					 </div>
                </div>
            </div>
        </div>
    </div>

    <!-- jQuery -->
    <script src="/resources/vendor/jquery/jquery.min.js"></script>

    <!-- Bootstrap Core JavaScript -->
    <script src="/resources/vendor/bootstrap/js/bootstrap.min.js"></script>

    <!-- Metis Menu Plugin JavaScript -->
    <script src="/resources/vendor/metisMenu/metisMenu.min.js"></script>

    <!-- Custom Theme JavaScript -->
    <script src="/resources/dist/js/sb-admin-2.js"></script>
    
    <script>
    	//btn클릭시 form submit 되도록 진행
    	$(".btn-login").on("click", function(e){
    		e.preventDefault();	//앵커태그에 대한 기능을 삭제시키는 것임..
    		$("form").submit();
    	});
    </script>
   


       
   <sec:authorize access='isAuthenticated()'>
   		<c:if test="${param.logout == null}">
			<script>
				$(document).ready(function(){
					//alert("이미 로그인된 사용자입니다.");
					//self.location ="/board/list";
					self.location ="/customLogout";
				});
			</script>
		</c:if>
	</sec:authorize>
	
	
	<c:if test="${param.logout != null || history.status}">
    	<script>
    		$(document).ready(function(){
    			alert("로그아웃 되었습니다.");
    		});
    	</script>
    </c:if>
	
    
   
    
    
     
	
</body>
</html>