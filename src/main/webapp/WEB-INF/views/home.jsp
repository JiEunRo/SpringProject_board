<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<html>
<head>
	<title>Home</title>
</head>
<body>
<h1>
	Hello world!   ${clientIP}
	<!-- HomController.java 에서 clientIP 를 추가했고, localhost:8080 접속시 자기자신인 0:0:0:0:0:0:0:1 로 나오고 다른 IP주소로 접속하면 http://203.228.62.31:8080/ 내 IP가 나온다 -->
</h1>

<P>  The time on the server is ${serverTime}. </P>


<script type="text/javascript">
	self.location ="/board/list";
	//location.href="/board/list";
	//location.replace('/board/list');
</script>


</body>
</html>
