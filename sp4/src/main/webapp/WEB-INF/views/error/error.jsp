<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
   response.setStatus(HttpServletResponse.SC_OK);
%>

<div class="container body-container">
	<div class="inner-page">
		<div class="info-continer">
			<div class="info-title">
				<h3>시스템 오류</h3>
			</div>
			<div class="info-box">
				<div class="info-message">
					시스템에 오류가 발생했습니다.<br>
					잠시후 다시 시도 해보시기 바랍니다. <br>
				</div>
				<div class="info-footer">
					<button type="button" class="btnConfirm" onclick="javascript:history.back();">이전화면으로 이동</button>
				</div>
			</div>
		</div>
    </div>
</div>
