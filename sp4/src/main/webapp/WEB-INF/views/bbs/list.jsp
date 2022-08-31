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
function searchList() {
	const f = document.searchForm;
	f.submit();
}
</script>

<div class="container body-container">
	<div class="body-title">
		<h2><i class="icofont-google-talk"></i> 게시판 </h2>
	</div>
    
	<div class="body-main mx-auto">
		<table class="table">
			<tr>
				<td align="left" width="50%">
					${dataCount}개(${page}/${total_page} 페이지)
				</td>
				<td align="right">
					&nbsp;
				</td>
			</tr>
		</table>
		
		<table class="table table-border table-list">
			<thead>
				<tr>
					<th class="wx-60">번호</th>
					<th>제목</th>
					<th class="wx-100">작성자</th>
					<th class="wx-100">작성일</th>
					<th class="wx-70">조회수</th>
					<th class="wx-50">첨부</th>
				</tr>
			</thead>
		 
		 	<tbody>
				<c:forEach var="dto" items="${list}">
					<tr> 
						<td>${dto.listNum}</td>
						<td class="left">
							<!-- /bbs 에서 /는 contextPath -->
							<c:url var="url" value="/bbs/article">
								<!-- 파라미터 : 자동으로 인코딩 -->
								<c:param name="num" value="${dto.num}"/>
								<c:param name="page" value="${page}"/>
								<c:if test="${not empty keyword}">
									<c:param name="condition" value="${condition}"/>
									<c:param name="keyword" value="${keyword}"/>
								</c:if>
							</c:url>
							<a href="${url}">${dto.subject}</a>
						</td>
						<td>${dto.userName}</td>
						<td>${dto.reg_date}</td>
						<td>${dto.hitCount}</td>
						<td>
							<c:if test="${not empty dto.saveFilename}">
								<a href="${pageContext.request.contextPath}/bbs/download?num=${dto.num}"><i class="icofont-file-alt"></i></a>
							</c:if>      
						</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
		 
		<div class="page-box">
			${dataCount == 0 ? "등록된 게시물이 없습니다." : paging}
		</div>
		
		<table class="table">
			<tr>
				<td align="left" width="100">
					<button type="button" class="btn" onclick="location.href='${pageContext.request.contextPath}/';">새로고침</button>
				</td>
				<td align="center">
					<form name="searchForm" action="${pageContext.request.contextPath}/" method="post">
						<select name="condition" class="form-select">
							<option value="all" ${condition=="all"?"selected='selected'":""}>제목+내용</option>
							<option value="userName" ${condition=="userName"?"selected='selected'":""}>작성자</option>
							<option value="reg_date" ${condition=="reg_date"?"selected='selected'":""}>등록일</option>
							<option value="subject" ${condition=="subject"?"selected='selected'":""}>제목</option>
							<option value="content" ${condition=="content"?"selected='selected'":""}>내용</option>
						</select>
						<input type="text" name="keyword" value="${keyword}" class="form-control">
						<button type="button" class="btn" onclick="searchList()">검색</button>
					</form>
				</td>
				<td align="right" width="100">
					<button type="button" class="btn" onclick="location.href='${pageContext.request.contextPath}/bbs/write';">글올리기</button>
				</td>
			</tr>
		</table>
	</div>

</div>