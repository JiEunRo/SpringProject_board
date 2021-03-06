<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@include file="../includes/header.jsp" %>

            <div class="row">
                <div class="col-lg-12">
                    <h1 class="page-header">Board List</h1>
                </div>
                <!-- /.col-lg-12 -->
            </div>
            <!-- /.row -->
            <div class="row">
                <div class="col-lg-12">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                        	Board List Page
                        	<button id="regBtn" type="button" class="btn btn-xs btn-primary pull-right">Regsiter New Board</button>
                        </div>
                        <!-- /.panel-heading -->
                        <div class="panel-body">
                        	전체 게시물 : ${total} <br>
                            <table class="table table-striped table-bordered table-hover"> <!--  id="dataTables-example" -->
                                <thead>
                                    <tr>
                                        <th>#번호</th>
                                        <th>제목</th>
                                        <th>작성자</th>
                                        <th>작성일</th>
                                        <th>수정일</th>
                                        <th>조회수</th>
                                    </tr>
                                </thead>
                                <tbody>
	                                <c:forEach items="${list}" var="board">
	                                	<tr>
	                                		<td><c:out value="${board.bno}" /></td>
	                                		<td>
	                                			<%-- <a href="/board/get?bno=<c:out value='${board.bno}' />" target="_self"> --%>
	                                			<a class="move" href="<c:out value='${board.bno}' />" target="_self">
	                                				<c:out value="${board.title}" />
	                                				<b>[<c:out value="${board.replycnt}" />]</b>
	                                			</a>
	                                		</td>
	                                		<td><c:out value="${board.writer}" /></td>
	                                		<td><fmt:formatDate pattern="yyyy-MM-dd" value="${board.regdate}" /></td>
	                                		<td><fmt:formatDate pattern="yyyy-MM-dd" value="${board.updatedate}" /></td>
	                                		<td><c:out value="${board.hit}" /></td>
	                                	</tr>	
	                                </c:forEach>
                                </tbody>
                            </table>
                            <!-- /.table-responsive -->
                            
                            <!-- Search -->
                            <div class="row">
                            	<div class="col-lg-12">
                            		<form id="searchForm" action="/board/list" method="get">
										<select name="type">
											<option value="" <c:out value='${pageMaker.cri.type == null? "select" : ""}' />> -- </option>
											<option value="T" <c:out value='${pageMaker.cri.type eq "T" ? "select" : ""}' /> selected> 제목 </option>
											<option value="C" <c:out value='${pageMaker.cri.type eq "C" ? "select" : ""}' />> 내용 </option>
											<option value="W" <c:out value='${pageMaker.cri.type eq "W" ? "select" : ""}' />> 작성자 </option>
											<option value="TC" <c:out value='${pageMaker.cri.type eq "TC" ? "select" : ""}' />> 제목or내용 </option>
											<option value="TW" <c:out value='${pageMaker.cri.type eq "TW" ? "select" : ""}' />> 제목or작성자 </option>
											<option value="TWC" <c:out value='${pageMaker.cri.type eq "TWC" ? "select" : ""}' />> 제목or내용or작성자 </option>
										</select>
										<input type="text" name="keyword" value='<c:out value="${pageMaker.cri.keyword }"/>' />
										<input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum}" />
										<input type="hidden" name="amount" value="${pageMaker.cri.amount}" />
										
										<button class="btn btn-default">Search</button>
									</form>
                            	</div>
                            </div>
                            <!-- /.Search -->
                            
                            
                            
                           	<!-- Paging -->
                           	<div class="row">
                           		<div class="col-lg-12">
		                            <div class="pull-right">
		                            	<ul class="pagination">
		                            		<li class="paginate_button previous"><a href="1">처음</a></li>
		                            		<c:if test="${pageMaker.prev}">
		                            			<li class="paginate_button previous"><a href="${pageMaker.startPage-1}">Previous</a></li>
		                            		</c:if>
		                            		
		                            		<c:forEach var="num" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
		                            			<li class="paginate_button ${pageMaker.cri.pageNum == num ? 'active' : ''}"><a href="${num}">${num}</a></li>	
		                            		</c:forEach>
		                            		<c:if test="${pageMaker.next }">
		                            			<li class="paginate_button next"><a href="${pageMaker.endPage+1}">Next</a></li>
		                            		</c:if>
		                            		<!-- 맨 끝 번호 구하는 방법  -->
		                            		<c:set var="pages" value="${total/pageMaker.cri.amount}" />
		                            		<li class="paginate_button next"><a href="<fmt:formatNumber value='${pages+(1-(pages%1))%1}' />">맨끝</a></li>
										</ul>
		                            </div>
	                            </div>
	                        </div>
                            <!-- /.Paging -->
                            
                            
                            
                            
                            
                            
                            
                            <!-- Modal -->
							<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
							    <div class="modal-dialog">
							        <div class="modal-content">
							            <div class="modal-header">
							                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
							                <h4 class="modal-title" id="myModalLabel">Modal title</h4>
							            </div>
							            <div class="modal-body">처리가 왼료되었습니다.</div>
							            <div class="modal-footer">
							                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
							                <!-- <button type="button" class="btn btn-primary">Save changes</button> -->
							            </div>
							        </div> <!-- /.modal-content -->
							</div><!-- /.modal-dialog -->
							</div><!-- /.modal -->
							
							
							

                        </div>
                        <!-- /.panel-body -->
                    </div>
                    <!-- /.panel -->
                </div>
                <!-- /.col-lg-12 -->
            </div>
            <!-- /.row -->
            
            
            <form id="actionForm" action="/board/list" method="get">
				<input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum}" />
				<input type="hidden" name="amount" value="${pageMaker.cri.amount}" />
				<input type="hidden" name="type" value='<c:out value="${pageMaker.cri.type}" />' />
				<input type="hidden" name="keyword" value='<c:out value="${pageMaker.cri.keyword}" />' />
			</form>
			
			
            
           
            <script type="text/javascript">
            	$(document).ready(function(){ //문서가 다 읽어지고나서 스크립트를 처리하라...
            		
            		/*
            		//부트스트랩의 데이터테이블을 사용하려면..!! , table에 아이디값 추가 후 진행하면 된다.
            		$("#dataTables-example").DataTable({
            				order : [[1, 'desc']].
            				responsive : true
            		});
            		*/
            		
            		/*
            		BoardController 에서 rttr.addFlashAttribute("result", board.getBno()); 코드를 통해
            		addFlashAttribute를 통해 새로 게시된 글 번호를 입력 해준다.. 그래서 ${reault} 로 게시글 번호를 받는다.
            		*/
            		var result = '<c:out value="${result}" />' ;   
            		
            		checkModal(result);
            		
            		history.replaceState({}, null, null);
            		
            		
            		// C언어처럼 절차지향형으로 checkModal() 처럼 함수 사용하지않고
            		// 글을 등록시 모달창을 뜨게 할 수 있다!
            		/*
            		if(result == "" ){
            			//미등록시
            			console.log("true" + result);
            		}else{
            			//등록시
            			console.log("false" + result);
            			if(parsInt(result) > 0) { $(".modal-body").html("게시글" + result + "번이 등록되었습니다."); }
            			$("#myModal").modal("show");
            		}
            		*/
            		
            		function checkModal(result){
            			if(result == '' || history.state){
            				return;	
            			}
            			if(parseInt(result) > 0){
            				$(".modal-body").html("게시글" + parseInt(result) + "번이 등록되었습니다.");
            			}
            			$("#myModal").modal("show");
            		}
            		
            		//등록 버튼을 누르면 등록화면으로 이동하도록 한다.
            		$("#regBtn").on("click", function(){
            			self.location = "/board/register";            			
            		});
            		
            		
            		//paging 부분에 a태그 처리 방법
            		var actionForm = $("#actionForm");
            		
            		$(".paginate_button a").on("click", function(e){
            			e.preventDefault();
            			console.log("click");
            			actionForm.find("input[name='pageNum']").val($(this).attr("href"));
            			actionForm.submit();
            		});
            		
            		
            		
            		//게시물 제목 클릭시 pangeNum 과 amount 를 넘기기 위한 action
            		$(".move").on("click", function(e){
            			e.preventDefault();
            			actionForm.append("<input type='hidden' name='bno' value='" + $(this).attr("href") + "'>");
            			actionForm.attr("action", "/board/get");
            			actionForm.submit();
            		});
            		
            		
            		//검색이벤트
            		var searchForm = $('#searchForm');
            		
            		$("#searchForm button").on("click", function(e){
            			
            			if(!searchForm.find("option:selected").val()){
            				alert("검색 종류를 선택하세요");
            				return false;
            			}
            			
            			if(!searchForm.find("input[name='keyword']").val()){
            				alert("키워드를 입력하세요");
            				return false;
            			}
            			searchForm.find("input[name='pageNum']").val("1");	// 검색시 페이지번호는 1 이 되도록한다.
            			e,preventDefault();
            			
            			searchForm.submit();
            		});
            		
            	});
            </script>
            
<%@include file="../includes/footer.jsp" %>

