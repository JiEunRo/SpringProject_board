/**
 * 
 */

console.log("reply Module ...... " );

var replyService = (function(){
	
	//등록처리
	function add(reply, callback, error){	//파라미터로 callback, error 함수로 받는거 체크!
		console.log("add reply.....");
		
		//add 함수는 ajax를 이용해서 post 방식으로 호출하는 코드를 작성하자.
		$.ajax({
			type:"post",
			url : "/replies/new",
			data : JSON.stringify(reply),
			contentType : "application/json; charset=utf-8",	//데이터 전송타입 체크!
			success : function(result, status, xhr){
				if(callback) {
					callback(result);
				}
			},
			error:function (xhr, status, er){
				if(error){
					error(er);
				}
			}
		});
	}
	
	//댓글의 목록처리 - getJSON() 사용하기 
	function getList(param, callback, error){
		//getList()는 param 이라는 객체를 통해 필요한 파라미터를 전달받아서 JSON목록을 호출한다.
		var bno = param.bno;
		var page = param.page || 1;
		
		//JSON 형태가 필요하므로 URL 호출시 확장자를 .json 으로 요구한다.
		$.getJSON("/replies/pages/" + bno + "/" + page + ".json",
		function(data){
			if(callback) {
				//callback(data);	//댓글 목록만 가져오는 경우
				callback(data.replyCnt, data.list);	//댓글수와 목록을 가져오는 경우
			}
		}).fail(function(xhr, status, err){
			if(error){
				error();
			}
		});
	}
	
	
	
	
	//댓글 삭제
	function remove(rno, replyer, callback, error){
		
		$.ajax({
			type:"delete",
			url : "/replies/"+rno,
			
			data : JSON.stringify({rno : rno , replyer : replyer}),
			
			contentType : "application/json; charset=utf-8",
			
			success : function(deleteResult, status, xhr){
				if(callback) {
					callback(deleteResult);
				}
			},
			error:function (xhr, status, er){
				if(error){
					error(er);
				}
			}
		});
	}
	
	
	
	//댓글수정
	function update(reply, callback, error){
		
		console.log("RNO: " + reply.rno);
		
		$.ajax({
			type:"put",
			url : "/replies/"+reply.rno,
			data : JSON.stringify(reply),
			contentType : "application/json; charset=utf-8",
			success : function(result, status, xhr){
				if(callback) {
					callback(result);
				}
			},
			error:function (xhr, status, er){
				if(error){
					error(er);
				}
			}
		});
	}
	
	
	//댓글 조회
	function get(rno, callback, error){
		$.get("/replies/" + rno + ".json", function (result){
			if(callback){
				callback(result);
			}
		}).fail(function(xhr, status, err){
			if(error){
				error();
			}
		});
	}
	
	//시간에 대한 처리 
	function displayTime(timeValue){
		var today = new Date();
		//today.getTime()
		var gap = today.getTime() - timeValue;
		
		var dateObj = new Date(timeValue);
		var str="";
		
		//if(gap < (1000*60*60*24)){
			var yy = dateObj.getFullYear();
			var mm = dateObj.getMonth() + 1;
			var dd = dateObj.getDate();
			
			
			var hh = dateObj.getHours();
			var mi = dateObj.getMinutes();
			var ss = dateObj.getSeconds();
			
		return [yy, '/',(mm > 9?'':'0') + mm, '/', (dd > 9 ? '' : '0') + dd + (hh > 9 ? '' : '0') + hh, ':', (mi > 9 ?'': '0') + mi, ':', (ss > 9 ?'':'0') + ss].join('');
		//} else {
		//	var yy = dateObj.getFullYear();
		//	var mm = dateObj.getMonth() + 1;
		//	var dd = dateObj.getDate();
			
		//	return [yy, '/',(mm > 9?'':'0') + mm, '/', (dd > 9 ? '' : '0') + dd].join('');
		//}
		
	}
	
	
	return {
		add : add,
		getList : getList,
		remove : remove,
		update : update,
		get : get,
		displayTime : displayTime
	};	
	
})();
