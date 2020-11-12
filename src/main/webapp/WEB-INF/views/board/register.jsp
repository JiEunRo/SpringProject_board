<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!-- 게시물 작성시 로그인한 사용자의 아이디를 출력하기 위함 -->
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>

<%@include file="../includes/header.jsp" %>


<div class="row">
	<div class="col-lg-12">
		<h1 class="page-haeder">Board Register</h1>
	</div>
</div>

<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">Board List Page</div>
			<div class="panel-body">
				
				<form role="form" action="/board/register" method="post">
					<!-- POST 방식의 전송은 반드시!! CSRF 토큰을 사용하도록 해야합니당! -->
					<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
					
					<div class="form-group">
						<label>Title</label>
						<input class="form-control" name="title" />
					</div>
					
					<div class="form-group">
						<label>Test area</label>
						<textarea style="resize: vertical;"  class="form-control" rows="3" name="content"></textarea>
					</div>
					
					
					<div class="form-group">
						<label>Writer</label>
						<input class="form-control" name="writer" value="<sec:authentication property='principal.member.userName' />" readonly="readonly" />
					</div>
					
					<button type="submit" class="btn btn-default">Submit</button>
					<button type="reset" class="btn btn-default">Reset</button>
					
				
				</form>
				
			</div>
		</div>
	</div>
</div>


<!-- 첨부파일 등록 -->
<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">Board List Page</div>
			<div class="panel-body">
				
				<div class="form-group uploadDiv">
					<input type="file" name="uploadFile" multiple />
				</div>
				
				<!-- 첨부파일 업로드 결과 출력 -->
				<div class="uploadResult">
					<ul>
					
					</ul>
				</div>
				<!-- 첨부파일 업로드 결과 출력 -->
				
			</div>
		</div>
	</div>
</div>
<!-- 첨부파일 등록 -->

<style>
	.uploadResult{width:100%; background:#f9f9f9;}
	.uploadResult ul{display:flex; flex-flow:row; justify-content:center; align-items:center;}
	.uploadResult ul li{list-style:none; padding:10px;}
	.uploadResult ul li img.fileimg{width:20px; }
	
	.bigPictureWrapper {position:absolute; display:none; justify-content:center; align-items:center; top:0; width:100%; height:100%; background-color:gray; z-index:100; background:rgba(255,255,255,0.5); }
	.bigPicture {position:relative; display:flex; justify-content:center; align-items:center;}
	.bigPicture img{width:600px;}
</style>



<script>
	$(document).ready(function(){
		
		
		
		//파일의 확장자와 크기를 검사해보자.
		var regex = new RegExp("(.*?\.(exe|sh|zip|alz)$)"); //파일의 확장자 설정
		var maxSize = 5242880; // 파일의 크기 설정 5MB
		
		//파일의 확장자와 크기를 검사하는 함수
		function checkExtension(fileName, fileSize){
			if(fileSize >= maxSize){
				alert("파일 사이즈 초과");
				return false;
			}
			if(regex.test(fileName)){
				alert("해당 종류의 파일은 업로드할 수 없습니다.");
				return false;
			}
			return true;
		}
		
		
		
		
		
		
		
		
		// 첨부된 파일 목록을 보여주도록 함수처리하자.
		
		function showUploadedResult(uploadResultArr){
			if(!uploadResultArr || uploadResultArr.length == 0) {return ;}
			
			var uploadResult = $(".uploadResult ul");
			var str = "";
			
			$(uploadResultArr).each(function(i, obj){
				
				if(obj.image){
					//첨부파일의 경로를 설정했다. (공백,한글문제를 해결해주는 메서드)
					var fileCallPath = encodeURIComponent (obj.uploadPath + "/s_" + obj.uuid + "_" + obj.fileName);
					
					
					str += "<li data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.image+"' >";
					str += "<div>";
					str += "<span>"+obj.fileName+"</span>";
					str += "<button type='button' data-file=\'"+fileCallPath+"\' data-type='image' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br />";
					str += "<img src='/display?fileName="+fileCallPath+"' />";
					str += "</div>";
					str += "</li>";
					
					
				}else{
					 
					var fileCallPath = encodeURIComponent (obj.uploadPath + "/" + obj.uuid + "_" + obj.fileName); 
					var fileLink = fileCallPath.replace(new RegExp(/\\/g), "/");
					
					str += "<li data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.image+"' >";
					str += "<div>";
					str += "<span>"+obj.fileName+"</span>";
					str += "<button type='button'  data-file=\'"+fileCallPath+"\' data-type='file' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br />";
					str += "<img class='fileimg' src='/resources/img/attach.png' />";
					str += "</div>";
					str += "</li>";
				}					
			});				
			uploadResult.append(str);
		}
		
		
		
		
		
		
		
		//스프링 시큐리티가 적용되고 난 뒤 파일첨부가 정상적으로 작동이 되지 않을 수 있다. 이는 게시물 등록이 POST 방식이기 때문인데
		var csrfHeaderName = "${_csrf.headerName}";
		var csrfTokenValue = "${_csrf.token}";
		
		//$("input[type='file']").on("click", function(e){
		$("input[type='file']").change(function(e){
			
			// jQuery를 이용하는 경우 파일업로드는 FormData 객체를 이용한다.
			var formData = new FormData();
			var inputFile = $("input[name='uploadFile']");
			var files = inputFile[0].files;
			
			console.log(files);
			
			// Ajax를 이용하는 파일 업로드는 FormData를 이용해서 필요한 파라미터를 담아서 전송하는 방식이다.
			//파일데이터 추가하기
			for(var i = 0 ; i<files.length ; i++){
				//파일 업로드 전 파일의 확장자와 사이즈를 함수로 체크한다
				if(!checkExtension(files[i].name , files[i].size )){
					return false;
				}
				
				formData.append("uploadFile", files[i]);
			}
			
			//Ajax를 이용해서 첨부파일을 전송하는 경우 가장 중요한 객체는 FormData 타입의 객체에 각 데이터를 추가하는 것이다.
			// 첨부파일 데이터는 formData에 추가한 뒤, Ajax를 통해서 formData 자체를 전송한다.
			// processData , contentType 가 false 여야 전송되므로 이건 확인**
			$.ajax({
				url : '/uploadAjaxActionList' , // AttachFileDTO 를 만들어 정보를 LIST형식으로 담아 브라우저에 첨부파일의 정보를 출력할 것
				processData : false,
				contentType : false ,
				beforeSend : function(xhr){
					xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
				} ,
				data : formData,
					type : 'POST',
					datatype : 'json' , //Ajax를 호출했을 때 결과타입은 JSON으로 변경하고 결과를 console에 찍을것임. 그래야 브라우저에 출력할 수 있음..ㅠㅜ
					success : function(result){
						console.log(result);						
						showUploadedResult(result);
					}
			});
			
		});	
		
		
		
		//첨부파일 삭제를 위해 ⓧ버튼을 클릭시에 대한 이벤트를 처리하자.
		$('.uploadResult').on("click", "button", function(e){
			console.log("선택한 파일을 삭제합니다.");
			
			var targetFile = $(this).data("file");
			var type = $(this).data("type");
			
			var targetLi = $(this).closest("li");
			
			//$(this).text("삭제되었습니다.");
			//$(this).parent().hide();
			
			$.ajax({
				url : '/deleteFile' , 
				data : {fileName:targetFile , type:type} ,
				beforeSend : function(xhr){
					xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
				},
				dataType : 'text' , 
				type : 'POST' ,
					success : function(result){
						alert(result);
						targetLi.remove();
					}
			}); 
			
		});
		
		
		
		var formObj = $("form[role='form']");
		
		$("button[type='submit']").on("click", function(e){
			e.preventDefault();
			console.log("게시판 등록 버튼을 클릭했습니다. ");
			
			var str="";
			// 562p > 게시물의 등록과 첨부파일의 데이터베이스 처리를 위하여 게시판이 <form>으로 되어 있으니 <input type='hidden'> 으로 첨부파일의 정보를 별도로 생성해서 보내자.
			// 이렇게 <input type='hidden'> 으로 생성된 첨부파일의 정보는 BoardVO 로 수집된다. BoardVO 에서 attachList 라는 변수로 List타입으로 정보를 수집하므로 name 은 attachList[인덱스번호]로 넣어준다..  
			$(".uploadResult ul li").each(function(i , obj){
				var jobj = $(obj);
				console.dir(jobj);
				
				str += "<input type='hidden' name='attachList["+i+"].fileName' value='"+jobj.data("filename")+"' />";
				str += "<input type='hidden' name='attachList["+i+"].uuid' value='"+jobj.data("uuid")+"' />";
				str += "<input type='hidden' name='attachList["+i+"].uploadPath' value='"+jobj.data("path")+"' />";
				str += "<input type='hidden' name='attachList["+i+"].fileType' value='"+jobj.data("type")+"' />";
			});
			formObj.append(str).submit();
		});
		
		
		
	});
</script>


<%@include file="../includes/footer.jsp" %>