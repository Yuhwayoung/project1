<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<style type="text/css">
.body-main {
	max-width: 800px;
}

.table-form tr > td:nth-child(1) { width: 110px; padding-top: 15px; padding-right: 5px; text-align: right; vertical-align: top; }
.table-form tr > td:nth-child(1) label { font-weight: 700; }
.table-form tr > td:nth-child(2) { padding-left: 10px; padding-bottom: 13px; }
.table-form tr > td:nth-child(2) p:first-child { padding-bottom: 5px; }

.table-footer { margin-bottom: 10px; }
</style>

<script type="text/javascript">
function memberOk() {
	const f = document.memberForm;
	let str;

	str = f.userId.value;
	if( !/^[a-z][a-z0-9_]{4,9}$/i.test(str) ) { 
		alert("아이디는 5~10자이며 첫글자는 영문자이어야 합니다.");
		f.userId.focus();
		return;
	}

	
	str = f.userPwd.value;
	if( !str ) {
		alert("패스워드를 입력하세요. ");
		f.userPwd.focus();
		return;
	}
	if( !/^(?=.*[a-z])(?=.*[!@#$%^*+=-]|.*[0-9]).{5,10}$/i.test(str) ) { 
		alert("패스워드는 5~10자이며 하나 이상의 숫자나 특수문자가 포함되어야 합니다.");
		f.userPwd.focus();
		return;
	}

	if ( str !== f.userPwdCheck.value ) {
        alert("패스워드가 일치하지 않습니다. ");
        f.userPwdCheck.focus();
        return;
	}
	
    str = f.userName.value;
    if( !str ) {
        alert("이름을 입력하세요. ");
        f.userName.focus();
        return;
    }

    str = f.birth.value;
    if( ! str ) {
        alert("생년월일를 입력하세요. ");
        f.birth.focus();
        return;
    }
    
    str = f.tel1.value;
    if( !/^(\d){2,3}$/.test(str) ) {
        alert("전화번호를 입력하세요. ");
        f.tel1.focus();
        return;
    }

    str = f.tel2.value;
    if( !/^(\d){3,4}$/.test(str) ) {
        alert("전화번호를 입력하세요. ");
        f.tel2.focus();
        return;
    }

    str = f.tel3.value;
    if( !/^(\d){4}$/.test(str) ) {
        alert("전화번호를 입력하세요. ");
        f.tel3.focus();
        return;
    }
    
    str = f.email1.value;
    if( !str ) {
        alert("이메일을 입력하세요. ");
        f.email1.focus();
        return;
    }

    str = f.email2.value;
    if( !str ) {
        alert("이메일을 입력하세요. ");
        f.email2.focus();
        return;
    }

 	f.action = "${pageContext.request.contextPath}/member/${mode}";
    f.submit();
}

function changeEmail() {
    const f = document.memberForm;
	    
    let str = f.selectEmail.value;
    if(str !=="direct") {
        f.email2.value=str; 
        f.email2.readOnly = true;
        f.email1.focus(); 
    }
    else {
        f.email2.value="";
        f.email2.readOnly = false;
        f.email1.focus();
    }
}

function userIdCheck() {
	// 아이디 중복 검사
	let userId = $("#userId").val();
	if(!/^[a-z][a-z0-9_]{4,9}$/i.test(userId)) { 
		var str = "아이디는 5~10자 이내이며, 첫글자는 영문자로 시작해야 합니다.";
		$("#userId").focus();
		$("#userId").parent().find(".help-block").html(str);
		return;
	}
	
	let url = "${pageContext.request.contextPath}/member/userIdCheck";
	let query = "userId=" + userId;
	$.ajax({
		type:"POST"
		,url:url
		,data:query
		,dataType:"json"
		,success:function(data) {
			let passed = data.passed;
			if(passed === "true") {
				let str = "<span style='color:blue; font-weight: bold;'>" + userId + "</span> 아이디는 사용가능 합니다.";
				$(".userId-box").find(".help-block").html(str);
				$("#userIdValid").val("true");
			} else {
				let str = "<span style='color:red; font-weight: bold;'>" + userId + "</span> 아이디는 사용할수 없습니다.";
				$(".userId-box").find(".help-block").html(str);
				$("#userId").val("");
				$("#userIdValid").val("false");
				$("#userId").focus();
			}
		}
	});
}
</script>


<div class="container body-container">
    <div class="body-title">
		<h2><i class="icofont-user"></i> ${mode=="member"?"회원 가입":"회원 정보 수정"} </h2>
    </div>
    
    <div class="body-main mx-auto pt-15">

		<form name="memberForm" method="post">
		<table class="table table-form">
			<tr>
				<td>
					<label>아이디</label>
				</td>
				<td class="userId-box">
					<p>
						<input type="text" name="userId" id="userId" maxlength="15" class="form-control md" 
							value="${dto.userId}"
							${mode=="update" ? "readonly='readonly' ":""}
							placeholder="아이디">
						<c:if test="${mode=='member'}">
							<button type="button" class="btn" onclick="userIdCheck();">아이디 중복검사</button>
						</c:if>
					</p>
					<p class="help-block">아이디는 5~10자 이내이며, 첫글자는 영문자로 시작해야 합니다.</p>
				</td>
			</tr>
			
			<tr>
				<td>
					<label>패스워드</label>
				</td>
				<td>
					<p>
						<input type="password" name="userPwd" maxlength="15" class="form-control md"
							autocomplete="off" placeholder="패스워드">
					</p>
					<p class="help-block">패스워드는 5~10자 이내이며, 하나 이상의 숫자나 특수문자가 포함되어야 합니다.</p>
				</td>
			</tr>
			
			<tr>
				<td>
					<label>패스워드 확인</label>
				</td>
				<td>
					<p>
						<input type="password" name="userPwdCheck" maxlength="15" class="form-control md"
							autocomplete="off" placeholder="패스워드 확인">
					</p>
					<p class="help-block">패스워드를 한번 더 입력해주세요.</p>
				</td>
			</tr>
			
			<tr>
				<td>
					<label>이름</label>
				</td>
				<td>
					<p>
						<input type="text" name="userName" maxlength="30" class="form-control md"
							value="${dto.userName}" 
							${mode=="update" ? "readonly='readonly' ":""}
							placeholder="이름">
					</p>
				</td>
			</tr>
			
			<tr>
				<td>
					<label>생년월일</label>
				</td>
				<td>
					<p>
						<input type="date" name="birth" maxlength="10" class="form-control md"
							value="${dto.birth}" 
							placeholder="생년월일">
					</p>
					<p class="help-block">생년월일은 2000-01-01 형식으로 입력 합니다.</p>
				</td>
			</tr>
			  
			<tr>
				<td>
					<label>이메일</label>
				</td>
				<td>
					<p>
						<select name="selectEmail" onchange="changeEmail();" class="form-select">
							<option value="">선 택</option>
							<option value="naver.com" ${dto.email2=="naver.com" ? "selected='selected'" : ""}>naver.com</option>
							<option value="gmail.com" ${dto.email2=="gmail.com" ? "selected='selected'" : ""}>gmail.com</option>
							<option value="hanmail.net" ${dto.email2=="hanmail.net" ? "selected='selected'" : ""}>hanmail.net</option>
							<option value="hotmail.com" ${dto.email2=="hotmail.com" ? "selected='selected'" : ""}>hotmail.com</option>
							<option value="direct">직접입력</option>
						</select>
						<input type="text" name="email1" maxlength="30" class="form-control sm-33" value="${dto.email1}" >
						<span>@</span> 
						<input type="text" name="email2" maxlength="30" class="form-control sm-33" value="${dto.email2}" 
								readonly="readonly">
					</p>
				</td>
			</tr>
			  
			<tr>
				<td>
					<label>전화번호</label>
				</td>
				<td>
					<p>
						<input type="text" name="tel1" class="form-control sm" maxlength="4" value="${dto.tel1}" >
						<span>-</span>
						<input type="text" name="tel2" class="form-control sm" maxlength="4" value="${dto.tel2}" >
						<span>-</span>
						<input type="text" name="tel3" class="form-control sm" maxlength="4" value="${dto.tel3}" >
					</p>
				</td>
			</tr>
			  
			<tr>
				<td>
					<label>우편번호</label>
				</td>
				<td>
					<p>
						<input type="text" name="zip" id="zip" class="form-control sm" value="${dto.zip}"
							readonly="readonly">
						<button type="button" class="btn" onclick="daumPostcode();">우편번호</button>          
					</p>
				</td>
			</tr>
			  
			<tr>
				<td>
					<label>주소</label>
				</td>
				<td>
					<p>
						<input type="text" name="addr1" id="addr1" maxlength="50" 
							class="form-control lg" readonly="readonly" value="${dto.addr1}"
							placeholder="기본 주소">
					</p>
					<p>
						<input type="text" name="addr2" id="addr2" maxlength="50" 
							class="form-control lg" value="${dto.addr2}" placeholder="나머지 주소">
					</p>
				</td>
			</tr>
			
			<c:if test="${mode=='member'}">
				<tr>
					<td>
						<label>약관동의</label>
					</td>
					<td>
						<p style="padding-top: 2px;">
							<label>
								<input id="agree" name="agree" type="checkbox" checked="checked" class="form-check-input"
									onchange="form.sendButton.disabled = !checked"> <a href="#">이용약관</a>에 동의합니다.
							</label>
						</p>
					</td>
				</tr>
			</c:if>
		</table>
			
		<table class="table table-footer">
			<tr> 
				<td class="text-center">
					<button type="button" name="sendButton" class="btn btn-dark" onclick="memberOk();">${mode=="member"?"회원가입":"정보수정"}</button>
					<button type="reset" class="btn">다시입력</button>
					<button type="button" class="btn" onclick="location.href='${pageContext.request.contextPath}/';">${mode=="member"?"가입취소":"수정취소"}</button>
					<input type="hidden" name="userIdValid" id="userIdValid" value="false">
				</td>
			</tr>
			<tr class="text-center">
				<td style="color: blue;">${message}</td>
			</tr>
		</table>
		</form>

    </div>
    
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script>
    function daumPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

                // 각 주소의 노출 규칙에 따라 주소를 조합한다.
                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                var fullAddr = ''; // 최종 주소 변수
                var extraAddr = ''; // 조합형 주소 변수

                // 사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
                if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                    fullAddr = data.roadAddress;

                } else { // 사용자가 지번 주소를 선택했을 경우(J)
                    fullAddr = data.jibunAddress;
                }

                // 사용자가 선택한 주소가 도로명 타입일때 조합한다.
                if(data.userSelectedType === 'R'){
                    //법정동명이 있을 경우 추가한다.
                    if(data.bname !== ''){
                        extraAddr += data.bname;
                    }
                    // 건물명이 있을 경우 추가한다.
                    if(data.buildingName !== ''){
                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                    }
                    // 조합형주소의 유무에 따라 양쪽에 괄호를 추가하여 최종 주소를 만든다.
                    fullAddr += (extraAddr !== '' ? ' ('+ extraAddr +')' : '');
                }

                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                document.getElementById('zip').value = data.zonecode; //5자리 새우편번호 사용
                document.getElementById('addr1').value = fullAddr;

                // 커서를 상세주소 필드로 이동한다.
                document.getElementById('addr2').focus();
            }
        }).open();
    }
</script>
    
</div>
