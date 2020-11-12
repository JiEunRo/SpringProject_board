<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Ajax를 이용한 파일첨부</title>
</head>
<style>
	.uploadResult{width:100%; background:#f9f9f9;}
	.uploadResult ul{display:flex; flex-flow:row; justify-content:center; align-items:center;}
	.uploadResult ul li{list-style:none; padding:10px;}
	.uploadResult ul li img.fileimg{width:20px; }
	
	.bigPictureWrapper {position:absolute; display:none; justify-content:center; align-items:center; top:0; width:100%; height:100%; background-color:gray; z-index:100; background:rgba(255,255,255,0.5); }
	.bigPicture {position:relative; display:flex; justify-content:center; align-items:center;}
	.bigPicture img{width:600px;}
</style>
<body>
	
	<b>Upload with Ajax</b><br><br>
	
	<div class="uploadDiv">
		<input type="file" name="uploadFile" multiple />
	</div>
	
	<!-- 첨부파일 업로드 결과 출력 -->
	<div class="uploadResult">
		<ul>
		
		</ul>
	</div>
	<!-- 첨부파일 업로드 결과 출력 -->
	
	<!-- 첨부파일이 이미지라면 클릭시 원본 이미지 출력 -->
	<div class="bigPictureWrapper">
		<div class="bigPicture"></div>
	</div>
	<!-- 첨부파일이 이미지라면 클릭시 원본 이미지 출력 -->
	
	<button id="uploadBtn">Upload</button>
	
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
	<script>
		
		// 첨부파일이 이미지라면, 썸네일 파일을 클릭하면 원본이미지를 보여주는 <div>를 처리하자.
		// 이 함수를 $(document).. 바깥에 지정한 이유는 나중에 <a>태그 클릭시 직접 showImage() 를 호출하기 위해서이다.
		function showImage(fileCallPath){
			//alert(fileCallPath);
			$(".bigPictureWrapper").css("display" , "flex").show();
			$(".bigPicture").html("<img src='/display?fileName="+encodeURI(fileCallPath)+"'>").animate({width:'100%' , height:'100%'}, 1000);
			
		}
		
		$(document).ready(function(){
			
			
			//첨부파일이 이미지라면 클릭시 원본이미지가 출력되는데, 이것을 한번더 클릭하면 사라지도록 처리하자.
			$('.bigPictureWrapper').on("click", function(){
				$(".bigPicture").animate({width:"0%", heihgt: "0%"}, 1000);
				/*
				setTimeout ( () => {
					$(this).hide();
				}, 1000);
				*/
				//익스에서 화살표함수가 잘 안되서 일반 함수처리함
				setTimeout (function(){
					$('.bigPictureWrapper').hide();					
				}, 1000);
			});
			
			
			// 첨부된 파일 목록을 보여주도록 함수처리하자.
			var uploadResult = $(".uploadResult ul");
			
			function showUploadedFile(uploadResultArr){
				var str = "";
				
				$(uploadResultArr).each(function(i, obj){
					
					if(!obj.image){
						//첨부파일의 경로를 설정했다. (공백,한글문제를 해결해주는 메서드)
						var fileCallPath = encodeURIComponent (obj.uploadPath + "/" + obj.uuid + "_" + obj.fileName);
						
						var fileLink = fileCallPath.replace(new RegExp(/\\/g), "/");
						
						//첨부파일 이미지를 클릭하면 다운로드 되도록 한다.
						str += "<li><a href='/download?fileName="+fileCallPath+"'><img class='fileimg' src='/resources/img/attach.png' />" + obj.fileName + "</a>"
									+"<span data-file=\'"+ fileCallPath+"\' data-type='file' >ⓧ</span></li>";
									//첨부파일 삭제를 위해 ⓧ버튼을 넣어주었다.
					}else{
						//str += "<li>" + obj.fileName + "</li>";
						
						//이미지 파일 보여주기
						// encodeURIComponent() 메서드는 GET방식으로 첨부파일의 이름을 사용할 때 항상 파일의 이름에 포함된 공백이나 한글이 문제될 수 있어 문제 해결을 위해 쓴다. 
						var fileCallPath = encodeURIComponent (obj.uploadPath + "/s_" + obj.uuid + "_" + obj.fileName); //썸네일 이미지가 업로드된 경로
						
						var originPath = obj.uploadPath + "\\" + obj.uuid + "_" + obj.fileName;
						originPath = originPath.replace(new RegExp(/\\/g), "/");
						
						// 만약 첨부파일이 이미지라면, 원본을 보여주도록 한다.
						str += "<li><b>"+obj.fileName+"</b><br><a href=\"javascript:showImage(\'" + originPath+ "\') \"><img src='/display?fileName="+fileCallPath+"'></a>"
								+"<span data-file=\'"+ fileCallPath+"\' data-type='image' >ⓧ</span></li>";;
									//첨부파일 삭제를 위해 ⓧ버튼을 넣어주었다.
					}					
				});				
				uploadResult.append(str);
			}
			
			
			//첨부파일 삭제를 위해 ⓧ버튼을 클릭시에 대한 이벤트를 처리하자.
			$('.uploadResult').on("click", "span", function(e){
				var targetFile = $(this).data("file");
				var type = $(this).data("type");
				console.log(targetFile);
				
				//$(this).text("삭제되었습니다.");
				$(this).parent().hide();
				
				$.ajax({
					url : '/deleteFile' , 
					data : {fileName:targetFile , type:type} , 
					dataType : 'text' , 
					type : 'POST' ,
						success : function(result){
							alert(result);
						}
				});
			});
			
			
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
			
			
			
			
			
			
			// 첨부하기를 누른뒤 새로고침 없이 파일첨부를 진행하기 위해 <input type="file"> 이 포함된 div를 복사한다.
			var cloneObj = $(".uploadDiv").clone();
			
			
			$("#uploadBtn").on("click", function(e){
				
				// jQuery를 이용하는 경우 파일업로드는 FormData 객체를 이용한다.
				var formData = new FormData();
				var inputFile = $("input[name='uploadFile']");
				var files = inputFile[0].files;
				
				console.log(files);
				
				// Ajax를 이용하는 파일 업로드는 FormData를 이용해서 필요한 파라미터를 담아서 전송하는 방식이다.
				//파일데이터 추가하기
				for(var i = 0; i<files.length; i++){
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
					//url : '/uploadAjaxAction' ,// AttachFileDTO 를 만들어 정보를 LIST형식으로 담아 브라우저에 첨부파일의 정보를 출력할것이므로 이거는 삭제
					url : '/uploadAjaxActionList' ,
					processData : false,
					contentType : false,
					data : formData,
						type : 'POST',
						datatype : 'json' , //Ajax를 호출했을 때 결과타입은 JSON으로 변경하고 결과를 console에 찍을것임. 그래야 브라우저에 출력할 수 있음..ㅠㅜ
						success : function(result){
							//alert("Uploaded!");
							console.log(result);
							
							showUploadedFile(result);
							
							$(".uploadDiv").html(cloneObj.html()); //이렇게 해줌으로써, 첨부하기 버튼 클릭 후 새로고침하지 않아도 다시 첨부할 수 있도록 버튼이 변경됨
						}
				});
				
			});			
		});
	</script>
</body>
</html>