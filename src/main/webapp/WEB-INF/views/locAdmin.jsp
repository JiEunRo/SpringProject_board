<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<%@include file="includes/header.jsp" %>

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
                        	검색
                        	<button id="regBtn" type="button" class="btn btn-xs btn-primary pull-right">Regsiter New Board</button>
                        </div>
                        <!-- /.panel-heading -->
                        <div class="panel-body">
                            <table class="table table-striped table-bordered table-hover" id="dataTables-example" style="width:100%">
                                <thead>
                                    <tr>
                                        <th>#번호</th>
                                        <th>경도</th>
                                        <th>위도</th>
                                        <th>입력일</th>
                                        <th>IP</th>
                                        <th>나의 위치 바로가기</th>
                                    </tr>
                                </thead>
                                <tbody>
                                
	                                <c:forEach items="${list}" var="loc">
	                                	<c:set var="lat" value="${fn:trim(loc.lat)}" />
	                               		<c:set var="lng" value="${fn:trim(loc.lng)}" />
	                               		
	                               		</tr>
	                               			<td></td>
	                               			<td><c:out value="${loc.lat}" /></td>
	                               			<td><c:out value="${loc.lng}" /></td>
	                               			<td><fmt:formatDate pattern="yyyy-MM-dd" value="${loc.inputDate}" /></td>
	                               			<td><c:out value="${loc.ip}" /></td>
	                               			
	                               			<td><a href="https://www.google.com/maps/place/?q=${lat} ${lng}" target="_blank" class="btn btn-default">해당 IP 위치 접속하기</a></td>
	                               		</tr>
	                               	</c:forEach>
	                               
                                </tbody>
                            </table>
                            <!-- /.table-responsive -->
                            
                        </div>
                        <!-- /.panel-body -->
                    </div>
                    <!-- /.panel -->
                </div>
                <!-- /.col-lg-12 -->
            </div>
            <!-- /.row -->
            
            
<%@include file="includes/footer.jsp" %>

