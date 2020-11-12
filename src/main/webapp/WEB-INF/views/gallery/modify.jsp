<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!-- 로그인한 사용자의 게시물일 때 수정/삭제 가능하도록 -->
<%@taglib uri="http://www.springframework.org/security/tags"  prefix="sec"%>

<%@include file="../includes/header.jsp" %>

<div class="row">
	<div class="col-lg-12">
		<h1 class="page-haeder">Board Modify</h1>
	</div>
</div>

<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">Board Modify Page</div>
			<div class="panel-body">
			
				<form role="form" action="/board/modify" method="post">
					
					<!-- CSRF 토큰을 전송해야한다.. POST 전송방식일 경우!! -->
					<input type="hidden" name="${_csrf.parameterName }" value="${_csrf.token }" />
				
					<input type='hidden'  name="pageNum" value='<c:out value="${cri.pageNum}" />' />
					<input type='hidden'  name="amount" value='<c:out value="${cri.amount}" />' />
					<input type='hidden'  name="type" value='<c:out value="${cri.type}" />' />
					<input type='hidden'  name="keyword" value='<c:out value="${cri.keyword}" />' />
					
					<div class="form-group">
						<label>Bno</label>
						<input class="form-control" name="bno" value='<c:out value="${board.bno}" />' readonly />
					</div>
				
					<div class="form-group">
						<label>Title</label>
						<input class="form-control" name="title" value='<c:out value="${board.title}" />' />
					</div>
					
					<div class="form-group">
						<label>Test area</label>
						<textarea class="form-control" rows="3" name="content" ><c:out value="${board.content}" /></textarea>
					</div>
					
					<div class="form-group">
						<label>Writer</label>
						<input class="form-control" name="writer" value='<c:out value="${board.writer}" />' readonly />
					</div>
					
					<div class="form-group">
						<label>RegDate</label>
						<input class="form-control" name="regDate" value='<fmt:formatDate pattern="yyyy/MM/dd" value="${board.regdate}" />' readonly />
					</div>
					
					<div class="form-group">
						<label>updateDate</label>
						<input class="form-control" name="updatedate" value='<fmt:formatDate pattern="yyyy/MM/dd" value="${board.updatedate}" />' readonly />
					</div>
					
					
					
					<!-- 첨부파일 출력 -->
					
					<div class="bigPictureWrapper">
						<div class="bigPicture">
							<!-- 원본이미지를 보여주는 영역 -->
						</div>
					</div>	
				
					<div class="row">
						<div class="col-lg-12">
							<div class="panel panel-default"><!-- panel -->
								<div class="panel-heading">Files</div>
									<div class="panel-body">
										
										<!-- 첨부파일 수정시 파일 교체나 추가 첨부를 위해 <input type='file'>을 추가하자 -->
										<div class="form-group uploadDiv">
											<input type="file" name="uploadFile" multiple />
										</div>
										
										<!-- 첨부파일의 목록을 보여주는 영역 -->
										<div class="uploadResult">
											<ul>
											</ul>
										</div>
										
									</div>
								</div>
					     	</div>	            	
					    </div>
					
					<!-- 첨부파일 출력 -->
					
					
					
					<!-- 로그인한 사용자가 게시자와 같을 경우 수정/삭제할 수 있도록 한다. -->
					<sec:authentication property="principal" var="pinfo" />
					<sec:authorize access="isAuthenticated()">
						<c:if test="${pinfo.member.userName eq board.writer }">
							<button data-oper="modify" type="submit" class="btn btn-default">Modify</button>
							<button data-oper="remove" type="submit" class="btn btn-default">Remove</button>
						</c:if>
					</sec:authorize>
					
					<button data-oper="list" type="submit"  class="btn btn-info">list</button>
					
				</form>
				
			</div>
		</div>
	</div>
</div>

<!-- 첨부파일 출력 -->
<link href="/resources/dist/css/attach.css"  rel="stylesheet">

<!-- 게시물 수정/등록/리스트 버튼을 클릭했을 때! -->
<script type="text/javascript">
	$(document).ready(function(){

		var formObj = $("form[role='form']");
		
		$("button").on("click", function(e){
			e.preventDefault();
			
			var operation = $(this).data("oper");
			console.log(operation);
			
			if(operation == "remove"){
				formObj.attr("action", "/board/remove");
			}else if(operation == "list"){
				//move to list
				//self.location = "/board/list";
				//return;
				
				//formObj.attr("action", "/board/list").attr("method", "get");
				formObj.attr("action", "/board/list").attr("method", "get");
				var pageNumTag = $("input[name='pageNum']").clone();	// .clone() 잠시 복사하는 메서드
				var amountTag = $("input[name='amount']").clone();
				var keywordTag = $("input[name='keyword']").clone();
				var typeTag = $("input[name='type']").clone();
								
				formObj.empty();	//<form>태그 내의 모든 내용 삭제
				
				formObj.append(pageNumTag);	//삭제 이후 필요한 태그 추가
				formObj.append(amountTag);
				formObj.append(keywordTag);
				formObj.append(typeTag);
				
			} else if(operation === "modify") {
				console.log("submit 버튼을 클릭했습니다.");
				//게시물수정시 첨부파일에 대한 정보를 <input type='hidden'> 으로 첨부파일의 정보를 보낸다.
				var str ="";
				$(".uploadResult ul li").each(function(i, obj){
					var jobj = $(obj);
					console.dir(jobj);
					
					str += "<input type='hidden' name='attachList["+i+"].fileName' value='"+jobj.data("filename")+"' />";
					str += "<input type='hidden' name='attachList["+i+"].uuid' value='"+jobj.data("uuid")+"' />";
					str += "<input type='hidden' name='attachList["+i+"].uploadPath' value='"+jobj.data("path")+"' />";
					str += "<input type='hidden' name='attachList["+i+"].fileType' value='"+jobj.data("type")+"' />";
				});
				formObj.append(str).submit();
				
			}
			
			formObj.submit();
			
		});
		
	});
	
	
	
</script>
<!-- 게시물 수정/등록/리스트 버튼을 클릭했을 때! -->


<!-- 첨부파일을 처리하자 -->
<script>

	// 문서가 로딩되기 전에 첨부파일의 데이터를 가져오는 부분을 실행하고
	$(document).ready(function(){
		
		
		
		/************* 게시물을 클릭하면 해당 게시판 번호의 첨부파일 목록을 출력한다. **************/
		(function(){
			var bno = '<c:out value="${board.bno}" />';
			
			$.getJSON("/board/getAttachList" , {bno:bno} , function(arr){
					
					console.log(arr);
					
					//  JSON으로 가져온 데이터를 <div>안에 보여주도록 처리해야하고, 전달된 JSON 데이터는 BoardAttachVO 객체이다.
					// 화면에 보여주는 부분을 처리하자.
					var str = "";
					
					$(arr).each(function(i, attach){
						
						//이미지 타입
						if(attach.fileType){
							
							var fileCallPath = encodeURIComponent (attach.uploadPath + "/s_" + attach.uuid + "_" + attach.fileName);
							
							str += "<li data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"' >";
							str += "<div>";
							str += "<span>"+attach.fileName+"</span>";
							str += "<button type='button' data-file=\'"+fileCallPath+"\' data-type='image' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br />";
							str += "<img src='/display?fileName="+fileCallPath+"' />";
							str += "</div>";
							str += "</li>";
						} else {
							
							//var fileCallPath = encodeURIComponent (attach.uploadPath + "/" + attach.uuid + "_" + attach.fileName); 
							//var fileLink = fileCallPath.replace(new RegExp(/\\/g), "/");
							
							str += "<li data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"' >";
							str += "<div>";
							str += "<span>"+attach.fileName+"</span>";
							str += "<button type='button' data-file=\'"+fileCallPath+"\' data-type='file' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br />";
							str += "<img class='fileimg' src='/resources/img/attach.png' />";
							str += "</div>";
							str += "</li>";
							
						}
					});
					
					$(".uploadResult ul").html(str);
					
			});
			
		})();
		
		
		
		/************* 첨부파일 X버튼을 클릭하면 삭제할 것인지 확인한다. **************/
		$('.uploadResult').on("click", "button", function(e){
			console.log("파일을 삭제하자!");
			
			//화면에서 이 파일을 삭제할 건지 aler창을 띄운 뒤 확인을 누르면 삭제된다.
			if(confirm("해당 파일을 삭제하시겠습니까?")){
				var targetLi = $(this).closest("li");
				targetLi.remove();
			}
			
		});
		
		
	

		
		
		/************* 첨부 할 파일의 확장자와 크기 유효성 검사를 한다. **************/
		var regex = new RegExp("(.*?\.(exe|sh|zip|alz)$)"); //파일의 확장자 설정
		var maxSize = 5242880; // 파일의 크기 설정 5MB
		
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
		
		
		
		/************* 첨부파일의 리스트를 출력하자 **************/
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
		
		
		
		/************* 첨부파일 버튼을 클릭하고 난 뒤 파일 데이터를 추가하고, 서버로 전송하기위해 ajax 를 처리했다  **************/
		//스프링 시큐리티가 적용되고 난 뒤 파일첨부가 정상적으로 작동이 되지 않을 수 있다. 이는 게시물 등록이 POST 방식이기 때문인데
		var csrfHeaderName = "${_csrf.headerName}";
		var csrfTokenValue = "${_csrf.token}";
		
		
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
		

		
	});
</script>
<!-- 첨부파일을 처리하자 -->


<%@include file="../includes/footer.jsp" %>