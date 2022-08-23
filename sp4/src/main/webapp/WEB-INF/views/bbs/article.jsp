<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<style type="text/css">
.body-main {
	max-width: 800px;
}
</style>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/board.css" type="text/css">

<script type="text/javascript">
<c:if test="${dto.userId == sessionScope.member.userId || sessionScope.member.membership>50}">
function deleteBoard() {
	if( confirm('게시글을 삭제 하시겠습니까 ? ')) {
		let query = "num=${dto.num}&${query}";
		let url = "${pageContext.request.contextPath}/bbs/delete?"+query;
		location.href = url;
	}
}
</c:if>
</script>

<script type="text/javascript">
function login() {
	location.href="${pageContext.request.contextPath}/member/login";
}

function ajaxFun(url, method, query, dataType, fn) {
	$.ajax({
		type:method,
		url:url,
		data:query,
		dataType:dataType,
		success:function(data) {
			fn(data);
		},
		beforeSend:function(jqXHR) {
			// 헤더에 AJAX라는 이름에 true 값을 보냄
			jqXHR.setRequestHeader("AJAX", true);
		},
		error:function(jqXHR) {
			if(jqXHR.status === 403) {
				// 로그인 인터셉터에서 AJAX로 요청할 때 로그인되어 있지 않으면 403 에러 코드를 던짐
				login();
				return false;
			} else if(jqXHR.status === 400) { // 파라미터 안 넘겼을 때
				alert("요청 처리가 실패 했습니다.");
				return false;
			}
			
			console.log(jqXHR.responseText);
		}
	});
}

$(function() {
	$(".btnSendBoardLike").click(function() {
		const $i = $(this).find("i");
		let userLiked = $i.css("color") === "rgb(0, 0, 255)";
		let msg = userLiked ? "게시글 공감을 취소하시겠습니까 ? " : "게시글에 공감하십니까 ? ";
		
		if(! confirm(msg) ) {
			return false;
		}
		
		let url = "${pageContext.request.contextPath}/bbs/insertBoardLike";
		let num = "${dto.num}";
		let query = "num="+num+"&userLiked="+userLiked;
		
		const fn = function(data) {
			let state = data.state;
			if(state === "true") {
				let color = "blue";
				if( userLiked ) {
					color = "black";
				}
				$i.css("color", color);
				
				let count = data.boardLikeCount;
				$("#boardLikeCount").text(count);
			} else if(state === "liked") {
				alert("게시글 공감 여부 처리는 한번만 가능합니다.");
			} else {
				alert("게시글 공감 여부 처리가 실패 했습니다.");
			}
		};
		
		ajaxFun(url, "post", query, "json", fn);
		
	});
});

// 댓글 리스트
$(function() {
	listPage(1);
});

function listPage(page) {
	let url = "${pageContext.request.contextPath}/bbs/listReply";
	let query = "num=${dto.num}&pageNo="+page;
	let selector = "#listReply";
	
	const fn = function(data) {
		$(selector).html(data);
	};
	ajaxFun(url, "get", query, "html", fn);
}

// 댓글 등록
$(function() {
	$(".btnSendReply").click(function() {
		let num = "${dto.num}";
		const $tb = $(this).closest("table");
		
		let content = $tb.find("textarea").val().trim();
		if( ! content ) {
			$tb.find("textarea").focus();
			return false;
		}
		content = encodeURIComponent(content);
		
		let url = "${pageContext.request.contextPath}/bbs/insertReply";
		let query = "num="+num+"&content="+content+"&answer=0"; // answer=0 이면 댓글
		
		const fn = function(data) {
			$tb.find("textarea").val("");
			
			let state = data.state;
			if(state === "true") {
				listPage(1);
			} else if(state === "false") {
				alert("댓글을 추가하지 못했습니다.");
			}
		};
		
		ajaxFun(url, "post", query, "json", fn);
	});
});

// 답글 버튼
$(function() {
	$("body").on("click", ".btnReplyAnswerLayout", function() {
		const $tr = $(this).closest("tr").next();
		let isVisible = $tr.is(":visible");
		let replyNum = $(this).attr("data-replyNum");
		
		if(isVisible) {
			$tr.hide();
		} else {
			$tr.show();
			
			// 답글 리스트
			listReplyAnswer(replyNum);
			
			// 답글 개수
			countReplyAnswer(replyNum);
		}
	});
});

// 답글 등록 버튼
$(function() {
	$("body").on("click", ".btnSendReplyAnswer", function() {
		let num = "${dto.num}";
		let replyNum = $(this).attr("data-replyNum");
		const $td = $(this).closest("td");
		
		let content = $td.find("textarea").val().trim();
		if(! content) {
			$td.find("textarea").focus();
			return false;
		}
		
		let url = "${pageContext.request.contextPath}/bbs/insertReply";
		let query = "num="+num+"&content="+encodeURIComponent(content)+"&answer="+replyNum;
		
		const fn = function(data) {
			$td.find("textarea").val("");
			let state = data.state;
			if(state === "true") {
				listReplyAnswer(replyNum);
				countReplyAnswer(replyNum);
			}
		};
		ajaxFun(url, "post", query, "json", fn);
	});
});

// 댓글별 답글 리스트
function listReplyAnswer(answer) {
	let url = "${pageContext.request.contextPath}/bbs/listReplyAnswer";
	let query = "answer="+answer;
	let selector = "#listReplyAnswer"+answer;
	
	const fn = function(data) {
		$(selector).html(data);
	};
	ajaxFun(url, "get", query, "html", fn);
}

// 댓글별 답글 개수
function countReplyAnswer(answer) {
	let url = "${pageContext.request.contextPath}/bbs/countReplyAnswer";
	let query = "answer="+answer;
	
	const fn = function(data) {
		let count = data.count;
		let sid = "#answerCount"+answer;
		$(sid).html(count);
	};
	ajaxFun(url, "post", query, "json", fn);
}

// 삭제, 신고 메뉴
$(function() {
	$("body").on("click", ".reply-dropdown", function() {
		const $menu = $(this).next(".reply-menu");
		if($menu.is(":visible")) {
			$menu.fadeOut(100);
		} else {
			$(".reply-menu").hide();
			$menu.fadeIn(100);
			
			let pos = $(this).offset();
			$menu.offset({left:pos.left-70, top:pos.top+20});
		}
	});
	
	$("body").on("click", function() {
		if($(event.target.parentNode).hasClass("reply-dropdown")) {
			return false;
		}
		
		$(".reply-menu").hide();
	});
});

$(function() {
	// 댓글 삭제
	$("body").on("click", ".deleteReply", function() {
		if(! confirm("댓글을 삭제하시겠습니까 ? ")) {
			return false;
		}
		
		let replyNum = $(this).attr("data-replyNum");
		let pageNo = $(this).attr("data-pageNo");
		let query = "replyNum="+replyNum+"&mode=reply";
		let url = "${pageContext.request.contextPath}/bbs/deleteReply";
		
		const fn = function(data) {
			// let state = data.state;
			listPage(pageNo);
		};
		ajaxFun(url, "post", query, "json", fn);
	});
	
	// 댓글의 답글 삭제
	$("body").on("click", ".deleteReplyAnswer", function() {
		if(! confirm("답글을 삭제하시겠습니까 ? ")) {
			return false;
		}
		
		let replyNum = $(this).attr("data-replyNum");
		let answer = $(this).attr("data-answer");
		let query = "replyNum="+replyNum+"&mode=answer";
		let url = "${pageContext.request.contextPath}/bbs/deleteReply";
		
		const fn = function(data) {
			listReplyAnswer(answer);
			countReplyAnswer(answer);
		};
		ajaxFun(url, "post", query, "json", fn);
	});
});

// 댓글의 좋아요/싫어요
$(function() {
	// 댓글 좋아요
	$("body").on("click", ".btnSendReplyLike", function() {
		let replyNum = $(this).attr("data-replyNum");
		let replyLike = $(this).attr("data-replyLike");
		const $btn = $(this);
		
		var msg = "게시글이 마음에 들지 않으십니까 ? ";
		if(replyLike === "1") {
			msg = "게시글에 공감하십니까 ? ";
		}
		
		if(! confirm(msg)) {
			return false;
		}
		
		var url = "${pageContext.request.contextPath}/bbs/insertReplyLike";
		var query = "replyNum="+replyNum+"&replyLike="+replyLike;
		
		const fn = function(data) {
			let state = data.state;
			if(state === "true") {
				let likeCount = data.likeCount;
				let disLikeCount = data.disLikeCount;
				
				$btn.parent("td").children().eq(0).find("span").html(likeCount);
				$btn.parent("td").children().eq(1).find("span").html(disLikeCount);
				
			} else if(state === "liked") {
				alert("공감 여부는 한번만 가능합니다.")
			} else {
				alert("공감 여부 처리가 실패 했습니다.")
			}
		};
		ajaxFun(url, "post", query, "json", fn);
	});
});


</script>

<div class="container body-container">
    <div class="body-title">
        <h2><i class="icofont-google-talk"></i> 게시판 </h2>
    </div>
    
    <div class="body-main pt-15 mx-auto">
		<table class="table table-border table-article">
			<thead>
				<tr>
					<td colspan="2" align="center">
						${dto.subject}
					</td>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td width="50%" align="left">
						이름 : ${dto.userName}
					</td>
					<td width="50%" align="right">
						${dto.reg_date} | 조회 ${dto.hitCount}
					</td>
				</tr>
				
				<tr style="border: none;">
					<td colspan="2" valign="top" height="200">
						${dto.content}
					</td>
				</tr>
				
				<tr>
					<td colspan="2" align="center" style="padding-bottom: 15px;">
						<button type="button" class="btn btnSendBoardLike" title="좋아요"> <i class="icofont-like" style="color: ${userBoardLiked?'blue':'black'}"></i> <span id="boardLikeCount">${dto.boardLikeCount}</span></button>
					</td>
				</tr>
				
				<tr>
					<td colspan="2">
						첨&nbsp;&nbsp;부 :
						<c:if test="${not empty dto.saveFilename}">
							<a href="${pageContext.request.contextPath}/bbs/download?num=${dto.num}">${dto.originalFilename}</a>
						</c:if>
					</td>
				</tr>
				
				<tr>
					<td colspan="2">
						이전글 :
						<c:if test="${not empty preReadDto}">
							<a href="${pageContext.request.contextPath}/bbs/article?${query}&num=${preReadDto.num}">${preReadDto.subject}</a>
						</c:if>
					</td>
				</tr>
				
				<tr>
					<td colspan="2">
						다음글 :
						<c:if test="${not empty nextReadDto}">
							<a href="${pageContext.request.contextPath}/bbs/article?${query}&num=${nextReadDto.num}">${nextReadDto.subject}</a>
						</c:if>
					</td>
				</tr>
			</tbody>
		</table>
			
		<table class="table">
			<tr>
				<td width="50%">
				<c:choose>
		    		<c:when test="${sessionScope.member.userId == dto.userId}">
		    			<button type="button" class="btn" onclick="location.href='${pageContext.request.contextPath}/bbs/update?num=${dto.num}&page=${page}';">수정</button>
		    		</c:when>
		    		<c:otherwise>
		    			<button type="button" class="btn" disabled="disabled">수정</button>
		    		</c:otherwise>
		    	</c:choose>
		    	
		    	<c:choose>
		    		<c:when test="${sessionScope.member.userId == dto.userId || sessionScope.member.membership>50}">
		    			<button type="button" class="btn" onclick="deleteBoard();">삭제</button>
		    		</c:when>
		    		<c:otherwise>
		    			<button type="button" class="btn" disabled="disabled">삭제</button>
		    		</c:otherwise>
		    	</c:choose>
		    	
				</td>
					
			
				<td align="right">
					<button type="button" class="btn" onclick="location.href='${pageContext.request.contextPath}/?${query}';">리스트</button>
				</td>
			</tr>
		</table>

		<div class="reply">
			<form name="replyForm" method="post">
				<div class='form-header'>
					<span class="bold">댓글쓰기</span><span> - 타인을 비방하거나 개인정보를 유출하는 글의 게시를 삼가해 주세요.</span>
				</div>
				
				<table class="table reply-form">
					<tr>
						<td>
							<textarea class='form-control' name="content"></textarea>
						</td>
					</tr>
					<tr>
					   <td align='right'>
					        <button type='button' class='btn btnSendReply'>댓글 등록</button>
					    </td>
					 </tr>
				</table>
			</form>
			
			<div id="listReply"></div>
		</div>

    </div>
    
</div>
