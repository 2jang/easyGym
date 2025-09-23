<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/layout/header.jsp"%>
<script src="https://code.jquery.com/jquery-latest.min.js"></script>
<link rel="stylesheet" href="/css/member/operJoin.css">
</div>
<section id="banner">
    <header>
        <h2>Business Join</h2>
    </header>
    <p>사업자 가입 페이지에 오신 것을 환영합니다. 사용자 아이디와 비밀번호를 입력하시고<br>
    로그인 버튼을 클릭하시면, 개인화된 서비스와 설정에 접근하실 수 있습니다.</p>
    <footer>
    </footer>
</section>
<div class="form-container">
	<form name="opJoin" id="form" class="form" method="post"
		action="/member/operJoin" onsubmit="combineBizNum()">
		<img src="/images/member/fitness.png" class="img-fluid"
			alt="Fitness Image" />

		<div class="input-box">
			<label for="operatorId"><small>아이디</small></label> <input type="text"
				name="operatorId" autocomplete="off" id="operatorId" tabindex="1"
				placeholder="아이디를 입력해주세요." required autofocus /> <br>
			<span id="check"></span>
		</div>
		<div class="column">
			<div class="input-box">
				<label>비밀번호</label> <input type="password"
					placeholder="비밀번호를 입력해주세요." required name="operatorPwd"
					id="operatorPwd" tabindex="2" /> <span id="pwError"></span>
			</div>


			<div class="input-box">
				<label>비밀번호 확인</label> <input type="password"
					placeholder="비밀번호를 재입력해주세요." required name="repw" id="repw"
					tabindex="3" /> <span id="repwError"></span>
			</div>
		</div>

		<div class="input-box">
			<label>이름</label> <input type="text" placeholder="이름을 입력해주세요."
				name="operatorName" autocomplete="off" tabindex="4" required />
		</div>

		<div class="input-box">
			<label>Email</label>
			<div class="flex_container">
				<div class="column">
					<input type="text" placeholder="이메일을 입력해 주세요" name="operatorEmail1"
						id="operatorEmail1" tabindex="6" required />
				</div>
				<div class="column">
					<select class="emailControl" name="operatorEmail2"
						id="operatorEmail2" required>
						<option value="">이메일 선택</option>
						<option value="@naver.com">@naver.com</option>
						<option value="@daum.net">@daum.net</option>
						<option value="@gmail.com">@gmail.com</option>
						<option value="@hanmail.com">@hanmail.com</option>
						<option value="@yahoo.co.kr">@yahoo.co.kr</option>
					</select>
				</div>
			</div>
		</div>
		<br>
            <input type="hidden" name="operatorEmail" id="operatorEmail">
            <div class="input-group-addon">
              <button type="button" class="button primary" id="mailCheckBtn">인증번호전송</button>
            </div>
            <br>
            <div class="mail-check-box input-box" style="display:none;">
              <input class="mail-check-input" placeholder="인증번호 6자리를 입력해주세요" disabled="disabled" maxlength="6">
            </div>
            <span id="mail-check-warn"></span>

		<div class="input-box">
			<label>전화번호</label> <input type="text" placeholder="전화번호를 입력해 주세요."
				name="operatorPhone" tabindex="7" required />
		</div>

		<div class="input-box">
			<label for="bizNum1">사업자등록번호</label> <input type="text"
				id="operatorResNo" name="operatorResNo" placeholder=""
				maxlength="10" class="form-control" />
		</div>

		<div class="input-box">
			<label for="inputGroupFile04">사업자등록증</label>
			<div class="input-group">
				<input type="file" id="operatorImgName" name="operatorImgName"
					class="form-control" aria-describedby="inputGroupFileAddon04"
					aria-label="Upload" />
				<button class="btn btn-outline-secondary" type="button"
					id="inputGroupFileAddon04">업로드</button>
			</div>
		</div>

		<button type="submit" id="join" value="Join" class="btn btn-success"
			onclick="javascript:checkJoin()" disabled>가입하기</button>
		<!-- Cloudflare Turnstile 위젯 -->
		<div
			class="cf-turnstile"
			data-sitekey="0x4AAAAAABzyMbhmo7j2Zd0d"
			data-theme="auto"
			data-size="flexible"
			data-callback="onTurnstileSuccessJoin"
			data-error-callback="onTurnstileErrorJoin"
			data-expired-callback="onTurnstileExpiredJoin"
			style="margin: 20px 0;"
		></div>
	</form>
</div>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<script src="/js/member/operMember.js"></script>
<script type="text/javascript">
  function onTurnstileSuccessJoin(token) {
    var btn = document.getElementById('join');
    if (btn) btn.disabled = false;
  }
  function onTurnstileErrorJoin() {
    var btn = document.getElementById('join');
    if (btn) btn.disabled = true;
  }
  function onTurnstileExpiredJoin() {
    var btn = document.getElementById('join');
    if (btn) btn.disabled = true;
  }
</script>
<script src="https://challenges.cloudflare.com/turnstile/v0/api.js" async defer></script>


<%@ include file="/WEB-INF/views/layout/footer.jsp"%>
