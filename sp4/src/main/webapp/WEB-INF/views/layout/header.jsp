<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<div class="top-bar fixed-top">
	<div class="container flex-center">
		<div class="top-info">
		</div>
		<div class="top-links">
			<c:choose>
				<c:when test="${empty sessionScope.member}">
					<a href="${pageContext.request.contextPath}/" title="로그아웃"></a>
				</c:when>
				<c:otherwise>
					<a href="${pageContext.request.contextPath}/member/logout" title="로그아웃">로그아웃</a>
					<a href="${pageContext.request.contextPath}/member/pwd">정보수정</a>
					<c:if test="${sessionScope.member.membership>50}">
						<a href="${pageContext.request.contextPath}/admin/memberManage/list" title="관리자">관리자</a>
					</c:if>
				</c:otherwise>
			</c:choose>
		</div>
	</div>
</div>

<div class="navbar fixed-top">
	<div class="container flex-center">
		<h1 class="logo"><a href="${pageContext.request.contextPath}/">홈</a></h1>
	</div>
</div>
