<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class='reply-info'>
	<span class='reply-count'>댓글 ${replyCount}개</span>
	<span>[목록, ${pageNo}/${total_page} 페이지]</span>
</div>

<table class='table reply-list'>
	<c:forEach var="vo" items="${listReply}">
		<tr class='list-header'>
			<td width='50%'>
				<div class='reply-writer'>
					<div class='reply-writer-left'><i class='icofont-user icon'></i></div>
					<div class='reply-writer-right'>
						<div class='name'>${vo.userName}</div>
						<div class='date'>${vo.reg_date}</div>
					</div>
				</div>
			</td>
			<td width='50%' align='right'>
				<span class='reply-dropdown'><i class='icofont-bubble-down'></i></span>
				<div class="reply-menu">
					<c:choose>
						<c:when test="${sessionScope.member.userId==vo.userId}">
							<div class='deleteReply reply-menu-item' data-replyNum='${vo.replyNum}' data-pageNo='${pageNo}'>삭제</div>
						</c:when>
						<c:when test="${sessionScope.member.membership > 50}">
							<div class='deleteReply reply-menu-item' data-replyNum='${vo.replyNum}' data-pageNo='${pageNo}'>삭제</div>
						</c:when>
						<c:otherwise>
						</c:otherwise>
					</c:choose>
				</div>
			</td>
		</tr>
		<tr>
			<td colspan='2' valign='top'>${vo.content}</td>
		</tr>

		<tr>
			<td>
				<button type='button' class='btn btnReplyAnswerLayout' data-replyNum='${vo.replyNum}'>답글 <span id="answerCount${vo.replyNum}">${vo.answerCount}</span></button>
			</td>
			<td align='right'>
				<button type='button' class='btn btnSendReplyLike' data-replyNum='${vo.replyNum}' data-replyLike='1' title="좋아요"><i class="icofont-thumbs-up"></i> <span>${vo.likeCount}</span></button>
				<button type='button' class='btn btnSendReplyLike' data-replyNum='${vo.replyNum}' data-replyLike='0' title="싫어요"><i class="icofont-thumbs-down"></i> <span>${vo.disLikeCount}</span></button>	        
			</td>
		</tr>
	
	    <tr class='reply-answer'>
	        <td colspan='2'>
				<div class='answer-body'>
					<div id='listReplyAnswer${vo.replyNum}' class='answer-list'></div>
					<div class="answer-form">
						<textarea class='form-control'></textarea>
					</div>
					 <div class='answer-footer'>
						<button type='button' class='btn btnSendReplyAnswer' data-replyNum='${vo.replyNum}'>답글 등록</button>
					</div>
				</div>
			</td>
	    </tr>
	</c:forEach>
</table>

<div class="page-box">
	${paging}
</div>			
