<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>GET방식으로 첨부파일 업로드하는 화면</title>
</head>
<body>

	<!-- 실제 전송은 POST방식으로 uploadFormAction 경로를 이용해서 처리된다. -->
	<form action="uploadFormAction" method="post" enctype="multipart/form-data"><!--  enctype은 첨부파일 시 꼭 넣어줘야함.  -->
		<input type="file" name="uploadFile" multiple /> <!-- multiple 를 지정하면 한번에 여러개의 파일을 업로드할 수 있다. -->
		<button>Submit</button>
	</form>
	
</body>
</html>