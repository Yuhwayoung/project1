<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<div class="container body-container">
	<div class="inner-page">
		<div class="info-continer">
			<div class="info-title">
				<h3>${title}</h3>
			</div>
			<div class="info-box">
				<div class="info-message">
					${message} 
				</div>
				<div class="info-footer">
					<button type="button" class="btnConfirm" onclick="location.href='${pageContext.request.contextPath}/';">메인화면으로 이동</button>
				</div>
			</div>
		</div>
    </div>
</div>
