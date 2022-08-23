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
				<h3>파일 용량 초과</h3>
			</div>
			<div class="info-box">
				<div class="info-message">
					파일은 최대 10MB 까지만 업로드가 가능합니다.<br>
					파일의 용량을 확인하고 다시 등록하기시 바랍니다.   
				</div>
				<div class="info-footer">
					<button type="button" class="btnConfirm" onclick="javascript:history.back();">이전화면으로 이동</button>
				</div>
			</div>
		</div>
    </div>
</div>
