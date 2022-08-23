<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<div class="container body-container">
	<div class="inner-page">
		<div class="info-continer">
			<div class="info-title">
				<h3 style="color: #424951;"><strong>경고 !</strong></h3>
			</div>
			<div class="info-box">
				<div class="info-message">
					해당 정보를 접근 할 수 있는 권한이 없습니다.
				</div>
				<div class="info-footer">
					<button type="button" class="btnConfirm" onclick="location.href='${pageContext.request.contextPath}/';">메인화면으로 이동</button>
				</div>
			</div>
		</div>
    </div>
</div>