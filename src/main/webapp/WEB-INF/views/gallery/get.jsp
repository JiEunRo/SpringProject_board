<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!-- 로그인한 사용자만 글을 수정할 수 있도록 하려고한다. -->
<%@taglib uri="http://www.springframework.org/security/tags"  prefix="sec"%>

<%@include file="../includes/header.jsp" %>

<div class="row">
	<div class="col-lg-12">
		<h1 class="page-haeder">Board Read</h1>
	</div>
</div>

<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">Board Read Page</div>
			<div class="panel-body">
			
					<div class="form-group">
						<label>Bno</label>
						<input class="form-control" name="bno" value='<c:out value="${board.bno}" />' readonly />
					</div>
					
					<div class="form-group">
						<label>IP</label>
						<input class="form-control" name="ip" value='<c:out value="${board.ip}" />' readonly />
					</div>
				
					<div class="form-group">
						<label>Title</label>
						<input class="form-control" name="title" value='<c:out value="${board.title}" />' readonly />
					</div>
					
					<div class="form-group">
						<label>Test area</label>
						<textarea class="form-control" rows="3" name="content" readonly="readonly"><c:out value="${board.content}" /></textarea>
					</div>
					
					<div class="form-group">
						<label>Writer</label>
						<input class="form-control" name="writer" value='<c:out value="${board.writer}" />' readonly />
					</div>
					
					<!-- 
					<button data-oper="modify" class="btn btn-default" onclick="location.href='/board/modify?bno=<c:out value="${board.bno}" />'">Modify</button>
					<button data-oper="list" class="btn btn-info" onclick="location.href='/board/list'">list</button>
					 -->
					 
					 <!-- 인증된 사용자의 정보를 principal 로 저장을 했고 변수명을 pinfo 로 지정했다... -->
					<sec:authentication property="principal" var="pinfo" />
					
					
					<!-- 로그인한 사용자만 이 버튼을 출력할 수 있도록 지정했다.. 이때, if문으로 pinfo의 userName 과 board.writer 의 이름이 같을때 출력한다! -->
					<sec:authorize access="isAuthenticated()">
						<c:if test="${pinfo.member.userName eq board.writer}">
							<button data-oper="modify" class="btn btn-default" >Modify</button>
						</c:if>
					</sec:authorize>
					
					
				 	
					<button data-oper="list" class="btn btn-info" >list</button>
					
					
					<br><br>					
					
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
					
					
					<!-- 댓글처리 -->
					<div class="row">
						<div class="col-lg-12">
							
							<div class="panel panel-default"><!-- panel -->
								<div class="panel-heading">
									<i class="fa fa-comments fa-fw"></i>Reply
									
									<!-- 로그인한 사용자만 댓글을 달 수 있도록 지정 -->
									<sec:authorize access="isAuthenticated()">
								 		<button id="addReplyBtn" class="btn btn-primary btn-xs pull-right">New Reply</button>
								 	</sec:authorize>
									
								</div>
							
								<div class="panel-body"> <!-- panel-body -->
									<ul class="chat">
										<!-- 
										<li class="left clearfix" data-rno="12">
											<div>
												<div class="header">
													<strong class="primary-font">user00</strong>
													<small class="pull-right text-mute">2018-01-01 13:13</small>
												</div>
												<p>Good Job!</p>
											</div>
										</li>
										 -->
									</ul>
								</div><!-- panel-body -->
								
								<div class="panel-footer" style="padding:0; border:0;">
								
								</div>
								
							</div><!-- panel -->
							
						</div>
					</div>
					<!-- // 댓글처리 -->
					
					
					<!-- 새 댓글 모달 -->
		            <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		                <div class="modal-dialog">
		                    <div class="modal-content">
		                        <div class="modal-header">
		                            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
		                            <h4 class="modal-title" id="myModalLabel">REPLY MODAL</h4>
		                        </div>
		                        <div class="modal-body">
		                            <div class="form-group">
										<label>Reply</label>
										<input class="form-control" name="reply" >
		                            </div>
		                            <div class="form-group">
										<label>Replyer</label>
										<input class="form-control" name="replyer" readonly>
		                            </div>
		                            <div class="form-group">
										<label>Reply Date</label>
										<input class="form-control" name="replyDate" >
		                            </div>
		                        </div>
		                        <div class="modal-footer">
		                            <button id="modalModBtn" type="button" class="btn btn-warning">Modify</button>
		                            <button id="modalRemoveBtn" type="button" class="btn btn-danger">Remove</button>
		                            <button id="modalRegisterBtn" type="button" class="btn btn-info">Register</button>
		                            <button id="modalCloseBtn" type="button" class="btn btn-default" data-dismiss="modal">Close</button>                            
		                        </div>
		                    </div>
		                    <!-- /.modal-content -->
		                </div>
		                <!-- /.modal-dialog -->
		            </div>
		            <!-- // 새 댓글 모달 -->
		            
		           

					<!-- 게시물 조회페이지에서 수정과 삭제가 피룡한 페이지로 링크를 처리해야하므로 <form>태그를 이용해서 처리해본다. -->
					<form id="operForm" action="/board/modify" method="get">
						<input type="hidden" id="bno" name="bno" value="<c:out value='${board.bno}' />" />
						<input type="hidden" id="pageNum" name="pageNum" value="<c:out value='${cri.pageNum}' />" />
						<input type="hidden" id="amount" name="amount" value="<c:out value='${cri.amount}' />" />
						<input type="hidden" id="keyword" name="keyword" value="<c:out value='${cri.keyword}' />" />
						<input type="hidden" id="type" name="type" value="<c:out value='${cri.type}' />" />
					</form>
				
			</div>
		</div>
	</div>
</div>




<!-- 첨부파일 출력 -->
<link href="/resources/dist/css/attach.css"  rel="stylesheet">
<script type="text/javascript" src="/resources/js/reply.js"></script>



<!-- 첨부파일 출력하기 -->
<script>
	// 문서가 로딩되기 전에 첨부파일의 데이터를 가져오는 부분을 실행하고
	$(document).ready(function(){
		//첨부파일이 추가된 게시물을 선택하면 콘솔창에 해당 게시물의 첨부파일 목록을 볼 수 있따.
		(function(){
			var bno = '<c:out value="${board.bno}" />';
			
			$.getJSON("/board/getAttachList" , {bno:bno} , function(arr){
					
					
					//  JSON으로 가져온 데이터를 <div>안에 보여주도록 처리해야하고, 전달된 JSON 데이터는 BoardAttachVO 객체이다.
					// 화면에 보여주는 부분을 처리하자.
					var str = "";
					
					$(arr).each(function(i, attach){
						//이미지 타입
						if(attach.fileType){
							
							var fileCallPath = encodeURIComponent (attach.uploadPath + "/s_" + attach.uuid + "_" + attach.fileName);
							
							str += "<li data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"' >";
							str += "<div>";
							str += "<img src='/display?fileName="+fileCallPath+"' />";
							str += "</div>";
							str += "</li>";
						} else {
							
							//var fileCallPath = encodeURIComponent (attach.uploadPath + "/" + attach.uuid + "_" + attach.fileName); 
							//var fileLink = fileCallPath.replace(new RegExp(/\\/g), "/");
							
							str += "<li data-path='"+attach.uploadPath+"' data-uuid='"+attach.uuid+"' data-filename='"+attach.fileName+"' data-type='"+attach.fileType+"' >";
							str += "<div>";
							str += "<span>"+attach.fileName+"</span>";
							str += "<img class='fileimg' src='/resources/img/attach.png' />";
							str += "</div>";
							str += "</li>";
							
						}
					});
					
					$(".uploadResult ul").html(str);
					
			});
			
		})();
		
		
		$(".uploadResult").on("click", "li", function(e){
			console.log("이미지 보기");
			
			var liObj = $(this);
			
			var path  = encodeURIComponent (liObj.data("path") + "/" + liObj.data("uuid") + "_" + liObj.data("filename"));
			
			if(liObj.data("type")){ // liObj.data("type") 은 boolean 이므로 true 면 image이다.
				showImage(path.replace(new RegExp(/\\/g), "/"));
			}else{
				self.location = "/download?fileName="+path;
			}
		});
		
		function showImage(fileCallPath){
			//alert(fileCallPath);
			$(".bigPictureWrapper").css("display" , "flex").show();
			$(".bigPicture").html("<img src='/display?fileName="+fileCallPath+"'>").animate({width:'100%' , height:'100%'}, 1000);
		}
		
		$(".bigPictureWrapper").on("click", function(e){
			$(".bigPicture").animate({width:"0%", heihgt: "0%"}, 1000);
			setTimeout (function(){
				$('.bigPictureWrapper').hide();					
			}, 1000);	
		});
		
	});
</script>



<script>
	//이벤트 처리 - 게시글의 조회 페이지가 열리며 자동으로 댓글 목록을 가져와서 <li>태그를 구성해야한다. 

	$(document).ready(function(){
		/* bnoValue 게시물번호 */
		var bnoValue = '<c:out value="${board.bno}"/>';
		var replyUL = $(".chat");
		
		
		showList(1);
	
		/* 댓글리스트 출력함수 */
		function showList(page){
			
			/*
			댓글 페이지 계싼 과 출력을 위해 reply.js getList() 에서 callback 함수에 replyCnt, list 를 전달하도록 했고...
			파라미터로 전달되는 page 변수를 이용해서 원하는 댓글 페이지를 가져온다. 
			page가 -1로 전달되면 마지막 페이지를 찾아서 다시 호출한다.
			사용자가 새로운 댓글을 추가하면 showList(-1); 을 호출하여 우선 전체 댓글의 숫자를 파악하고, 이후 다시 마지마가 페잊를 호출해서 이동하는 방식으로 동작한다.
			*/			
			console.log("페이지수 " + page);	 
			
			replyService.getList({bno:bnoValue, page:page||1}, function(replyCnt, list){
				
				console.log("댓글수 : " + replyCnt);
				console.log("리스트 : " + list);
				console.log(list);
				
				if(page == -1){
					pageNum = Math.ceil(replyCnt/10.0);
					showList(pageNum);
					return;
				}
				
				var str=" ";
				
				if(list == null || list.length == 0){
					replyUL.html("댓글이 없습니다.");
					return;
				}
				
				for(var i = 0 , len = list.length||0 ; i < len ; i++){
					str += "<li class='left clearfix' data-rno='" + list[i].rno +"'>";
					str += "<div>";
					str += "<div class='header'>";
					str += "<strong class='primary-font'>" + list[i].replyer +"</strong>";
					str += "<small class='pull-right text-muted'> 댓글 등록일 : " + replyService.displayTime(list[i].replyDate) +"</small>"; //displayTime 은 reply.js 에서 수정하면됨
					if(list[i].replyDate < list[i].updateDate ){
						//str += "<small class='pull-right text-muted'> 수정됨</small>";
						str += "<br><small class='pull-right text-muted'> 최근 수정일 : " + replyService.displayTime(list[i].updateDate) +"</small>";
					}
					str += "</div>";
					str += "<p>" + list[i].reply +"</p>";
					str += "</div>";
					str += "</li>";
				}
				
				replyUL.html(str);
				
				showReplyPage(replyCnt);
				
			});
		}
		
		
		
		/* CRUD를 위한 Modal창 */
		var modal = $(".modal");
		var modalInputReply = modal.find("input[name='reply']");
		var modalInputReplyer = modal.find("input[name='replyer']");
		var modalInputReplyDate = modal.find("input[name='replyDate']");

		var modalModBtn = $("#modalModBtn");
		var modalRemoveBtn = $("#modalRemoveBtn");
		var modalRegisterBtn = $("#modalRegisterBtn");
		
		
		//댓글 등돌시 CSRF 토큰을 전송해야하고, 수정/삭제시 댓글의 작성자를 같이 전송해야한다(이유는 댓글작성자와 로그인한 사용자가 같은지 서버에서 비교하기위해..)
		var replyer = null;
		
		
		<sec:authorize access="isAuthenticated()">
			replyer = '<sec:authentication property="principal.username" />';
		</sec:authorize>
		
		//토큰처리는 csrfHeaderName , csrfTokenValue 로 처리한다는 것!
		var csrfHeaderName = "${_csrf.headerName}";
		var csrfTokenValue="${_csrf.token}";
		
		
		
		/* 글내용보기에서 댓글등록버튼을 눌렸을때 */
		$("#addReplyBtn").on("click", function(e){
			modal.find("input").val("");
			modal.find("input[name='replyer']").val(replyer);	//댓글 등록시 로그인한 사용자만 할 것이므로 게시자 현재 로그인한 사용자 이름은 고정!
			modalInputReplyDate.closest("div").hide();
			modal.find("button[id != 'modalCloseBtn']").hide();
			
			modalRegisterBtn.show();
			//modalInputReplyer.attr("readonly", false);
			
			$(".modal").modal("show");
		});
		
		

		//Ajax Spring security Header
		// jQuery 를 이용해서 Ajax로 CSRF 토큰을 전송하는 방식은 첨부파일의 경우 beforeSend 를 이용했지만..
		// 기본 설정으로 지정해서 사용하는것이 더 편하므로.. 아래와 같이 코드를 쓴다.
		$(document).ajaxSend(function(e, xhr, options){
			xhr.setRequestHeader(csrfHeaderName, csrfTokenValue);
		});
		
		
		
		
		//특정 댓글 클릭시 모달창이 열리며 세부정보를 볼 수 있는 이벤트 
		$(".chat").on("click", "li", function(e){
			var rno = $(this).data("rno");
			//console.log(rno); //rno 를 콘솔에 출력
			
			replyService.get(rno, function(reply){
				modalInputReply.val(reply.reply);
				modalInputReplyer.val(reply.replyer);
				modalInputReplyDate.val(replyService.displayTime(reply.replyDate)).attr("readonly", "readonly");
				modal.data("rno", reply.rno);
				
				modal.find("button[id != 'modalCloseBtn']").hide();
				modalModBtn.show();
				modalRemoveBtn.show();
				
				$(".modal").modal("show");
				
			});
		});
		
		
		
		
		
		
		/* 새로운 댓글 추가 처리 */
		modalRegisterBtn.on("click", function(e){
			var reply={
					reply:modalInputReply.val(),
					replyer:modalInputReplyer.val(),
					bno:bnoValue
			};
			
			replyService.add(reply, function(result){
				alert(result);
				
				modal.find("input").val("");
				modal.modal("hide");
				
				//댓글목록 갱신하기
				//showList(1);
				showList(-1); //page가 -1이 전달되면 전체 댓글 숫자를 파악하여 다시 마지막 페이지를 호출해서 이동시키는 방식으로 동작
			});
		});
		
		
		
		
		
		
		
		
		//댓글 페이지 번호 출력을 하기 위한 함수
		var pageNum = 1;	
		var replyPageFooter = $(".panel-footer");
		
		
		function showReplyPage(replyCnt){
			var endNum = Math.ceil(pageNum / 10.0) * 10;
			var startNum = endNum - 9;
			
			var prev = startNum != 1;
			var next = false;
			
			if(endNum * 10 >= replyCnt){
				endNum = Math.ceil(replyCnt/10.0);
			}
			
			if(endNum * 10 < replyCnt){
				next = true;
			}
			
			var str = "<ul class='pagination pull-right'>";

			if(prev){
				str += "<li class='page-item'><a class='page-link' href='"+(startNum-1)+"'>Previous</a></li>";
			}

			for(var i = startNum; i <= endNum ; i++){
				var active = pageNum == i? "active":"";
				
				str += "<li class='page-item "+active+"'><a class='page-link' href='"+i+"'>"+i+"</a></li>";
			}
			
			if(next){
				str += "<li class='page-item'><a class='page-link' href='"+(endNum+1)+"'>Next</a></li>";
			}
			
			str += "</ul></div>";
			
			console.log(str);
			
			replyPageFooter.html(str);
		}
		
		//페이지 번호를 클릭했을 때 새로운 댓글을 가져오도록 처리한다.
		replyPageFooter.on("click","li a",function(e){
			e.preventDefault();
			
			var targetPageNum = $(this).attr("href");
			
			pageNum = targetPageNum;
			
			showList(pageNum);
		});
		
		
		
		
		//댓글 수정하기
		modalModBtn.on("click", function(e){
			
			var originalReplyer = modalInputReplyer.val();
			
			var reply = {
				rno:modal.data("rno"),
				reply : modalInputReply.val(),
				replyer : originalReplyer
			};
			
			if(!replyer){
				alert("로그인 후 수정이 가능합니다");
				modal.modal("hide");
				return;
			}
			
			console.log("원래 댓글 작성자 : "  + originalReplyer);	//댓글의 원래 작성자
			
			if(replyer != originalReplyer){
				alert("자신이 작성한 댓글만 수정가능합니다.");
				modal.modal("hide");
				return
			}
			
			replyService.update(reply, function(result){
				alert(result);
				modal.modal("hide");
				showList(pageNum);
			});
		});
		
		
		
		//댓글 삭제하기
		modalRemoveBtn.on("click", function(e){
			
			var rno = modal.data("rno");
			
			console.log("댓글 번호 : " + rno);
			console.log("현재 작성자 : " + replyer);
			
			if(!replyer){
				alert("로그인 후 삭제 가능합니다.");
				modal.modal("hide");
				return;
			}
			
			var originalReplyer = modalInputReplyer.val();
			
			console.log("원래 댓글 작성자 : "  + originalReplyer);	//댓글의 원래 작성자
			
			if(replyer != originalReplyer){
				alert("자신이 작성한 댓글만 가능하도록 가능합니다.");
				modal.modal("hide");
				return
			}
			
			replyService.remove(rno, originalReplyer, function(result){
				alert(result);
				modal.modal("hide");
				showList(pageNum);
			});
		});
		
		
		
		
	});
</script>

<script type="text/javascript">
	/*
	//js 적용한지 확인하기
	$(document).ready(function(){
		console.log(replyService);
	});
	*/
	
	/*
	//JS CRUD 테스트
	console.log("====================");
	console.log("JS TEST");
	
	var bnoValue= '<c:out value="${board.bno}" />';
	
	
	//add() 테스트하기
	replyService.add(
		{reply:"JS TEST" , replyer : "tester", bno:bnoValue},
		function(result){
			alert("RESULT : " + result);
		}
	);

	
	//getList()테스트하기
	replyService.getList({bno:bnoValue, page:1}, function(list){
		for(var i = 0 , len = list.length||0 ; i < len ; i++){
			console.log(list[i]);
		}
	});
	
	
	//댓글 삭제 테스트
	replyService.remove(6, function(count){
		console.log(count);
		if(count === "success"){
			alert("REMOVED SUCCESS!!!");
		}
	}, function(err){
		alert("REMOVED ERROR ... ");	
	});
	
	//수정 테스트
	replyService.update({
		rno : 21,
		bno : bnoValue,
		reply : "Modified Reply ....."
	}, function(result){
		alert("수정완료");
	});
	
	
	//댓글 조회 테스트
	replyService.get(16, function(data){
		console.log(data);
	});
	*/
</script>





<script type="text/javascript">
	$(document).ready(function(){
		var operForm = $("#operForm");
		
		$("button[data-oper='modify']").on("click", function(e){
			console.log("여기"); //클릭시 테스트를 진행한다.
			operForm.attr("action", "/board/modify").submit();
		});
			
		$("button[data-oper='list']").on("click", function(e){
			operForm.find("#bno").remove();
			operForm.attr("action", "/board/list");
			operForm.submit();
		});
		
	});
</script>



<%@include file="../includes/footer.jsp" %>