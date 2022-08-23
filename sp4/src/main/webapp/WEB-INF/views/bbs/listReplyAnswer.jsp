<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:forEach var="vo" items="${listReplyAnswer}">
	<div class='answer-article'>
		<div class='article-header'>
			<div class='article-header-left'>
				<div class='reply-writer'>
					<div class='reply-writer-left'><i class='icofont-user icon'></i></div>
					<div class='reply-writer-right'>
						<div class='name'>${vo.userName}</div>
						<div class='date'>${vo.reg_date}</div>
					</div>
				</div>
			</div>
			<div class='article-header-right'>
				<span class='reply-dropdown'><i class='icofont-bubble-down'></i></span>
				<div class='reply-menu'>
					<c:choose>
						<c:when test="${sessionScope.member.userId == vo.userId}">
							<div class='deleteReplyAnswer reply-menu-item' data-replyNum='${vo.replyNum}' data-answer='${vo.answer}'>삭제</div>
							<div class='hideReplyAnswer reply-menu-item'>숨김</div>
						</c:when>
						<c:when test="${sessionScope.member.membership > 50}">
							<div class='deleteReplyAnswer reply-menu-item' data-replyNum='${vo.replyNum}' data-answer='${vo.answer}'>삭제</div>
							<div class='blockReplyAnswer reply-menu-item'>차단</div>
						</c:when>
						<c:otherwise>
							<div class='notifyReplyAnswer reply-menu-item'>신고</div>
							<div class='blockReplyAnswer reply-menu-item'>차단</div>
						</c:otherwise>
					</c:choose>
				</div>
			</div>
		</div>
		<div class='article-body'>
			${vo.content}
		</div>
	</div>
</c:forEach>