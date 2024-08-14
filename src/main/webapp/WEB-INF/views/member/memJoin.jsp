<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
 <%@ include file="/WEB-INF/views/layout/header.jsp"%>
<link rel="stylesheet" href="/css/member/join.css" />

<style>
  .email-group {
    display: flex; /* Flexbox를 사용하여 가로 배치 */
    align-items: center; /* 세로 가운데 정렬 */
    gap: 10px; /* 요소 간의 간격 설정 */
  }

  .email-input,
  .email-select {
    flex: 1; /* Flexbox로 크기 조절 */
  }

  .email-select {
    max-width: 200px; /* 드롭다운의 최대 너비 설정 */
  }

  .input-group-addon {
    margin-left: 10px; /* 버튼과 입력 필드 간의 여백 */
  }

  .address-group {
    display: flex; /* Flexbox를 사용하여 가로 배치 */
    align-items: center; /* 세로 가운데 정렬 */
    gap: 10px; /* 요소 간의 간격 설정 */
  }

  .address-group input[type="text"] {
    flex: 1; /* Flexbox로 입력 필드 크기 조절 */
    margin-right: 10px; /* 버튼과 입력 필드 간의 간격 설정 */
  }

  .address-group input[type="button"] {
    flex-shrink: 0; /* 버튼의 크기를 고정 */
    }

</style>
<section id="banner">
        <header>
            <h2>Sign up</h2>
        </header>
        <p>회원가입 페이지입니다. 아래 양식을 작성하셔서 회원가입을 완료해 주세요.<br>가입 후 다양한 서비스와 혜택을 이용하실 수 있습니다.
        </p>
        <footer>
        </footer>
</section>
<article id="main">
<!--   <header class="special container">
    <span class="icon solid fa-envelope"></span>
    <h1>Sign up</h1>
  </header> -->
  <!-- One -->
  <section class="wrapper style4 special container medium">

    <!-- Content -->
    <div class="content">
      <form id="form" name="join" method="post" action="/member/addMember.do">
        <div class="row gtr-50">
          <div class="col-12">
            <input type="text" name="memberId" autocompleted="off" id="memberId"
              tabindex="1" placeholder="아이디를 입력해주세요." required autofocus />
            <br><span id="check"></span>
          </div>
          <div class="col-12">
            <input type="password" name="memberPwd" placeholder="비밀번호를 입력해주세요."
              required id="memberPwd" tabindex="2" />
            <br><span id="pwError"></span>
          </div>
          <div class="col-12">
            <input type="password" name="repw" placeholder="비밀번호를 재입력해주세요."
              required id="repw" tabindex="3" />
            <br><span id="repwError"></span>
          </div>
          <div class="col-12">
            <input type="text" name="memberName" placeholder="이름을 입력해주세요." autocomplete="off"
              tabindex="4" required />
          </div>
          <div class="col-12 email-group">
            <div class="email-input">
              <input type="text" name="memberEmail1" id="memberEmail1" tabindex="6"
                placeholder="이메일을 입력해주세요." required />
            </div>
            <div class="email-select">
              <select class="emailControl" name="memberEmail2" id="memberEmail2" required>
                <option value="">이메일 선택</option>
                <option value="@naver.com">@naver.com</option>
                <option value="@daum.net">@daum.net</option>
                <option value="@gmail.com">@gmail.com</option>
                <option value="@hanmail.com">@hanmail.com</option>
                <option value="@yahoo.co.kr">@yahoo.co.kr</option>
              </select>
            </div>
            <br>
            <input type="hidden" name="memberEmail" id="memberEmail">
            <div class="input-group-addon">
              <button type="button" class="button primary" id="mailCheckBtn">인증번호전송</button>
            </div>
            <br>
            <div class="mail-check-box input-box" style="display:none;">
              <input class="mail-check-input" placeholder="인증번호 6자리를 입력해주세요" disabled="disabled" maxlength="6">
            </div>
            <span id="mail-check-warn"></span>
          </div>
          <div class="col-12">
            <input type="text" name="memberPhone" autocompleted="off" id="memberPhone"
              tabindex="1" placeholder="전화번호를 입력해주세요." required autofocus />
            <br><span id="check"></span>
          </div>
          <div class="col-12">
            <div class="input-box">
              <div class="address-group">
                <input type="text" id="sample6_postcode" name="memberPost" placeholder="우편번호">
                <input type="button" class="button primary" onclick="sample6_execDaumPostcode()" value="우편번호 찾기">
              </div>

              <input type="text" id="sample6_address" name="memberAddr" placeholder="주소">
              <br>
              <input type="text" id="sample6_detailAddress" placeholder="상세주소">

            </div>
          </div>
          <div class="col-12">
            <div class="gender-box">
              <div class="gender-option">
                <div class="gender">
                  <label for="check-male" class="gender_text">남성</label>
                  <input type="radio" id="check-male" name="memberGender" value="1" tabindex="8" checked />
                </div>
                <div class="gender">
                  <label for="check-female" class="gender_text">여성</label>
                  <input type="radio" id="check-female" name="memberGender" value="2" tabindex="9" />
                </div>
              </div>
            </div>
          </div>
          <div class="col-12">
            <div class="agree-box">
              <div class="agree-option">
                <div class="agree">
                  <label for="memberMarketing">마케팅정보 수신 동의</label>
                  <input type="checkbox" id="memberMarketing" name="memberMarketing" value="1" tabindex="10">
                </div>
              </div>
            </div>
          </div>
          <input type="hidden" name="memberState" value="1">
          <div class="col-12">
            <ul class="buttons">
              <li><input type="submit" id="join" value="join" class="button primary" onclick="javascript:checkJoin()" /></li>
            </ul>
          </div>
        </div>
      </form>
    </div>
  </section>
</article>
<script src="/js/member/member.js"></script>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
function sample6_execDaumPostcode() {
    new daum.Postcode({
        oncomplete: function(data) {
            // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

            // 각 주소의 노출 규칙에 따라 주소를 조합한다.
            // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
            var addr = ''; // 주소 변수
            var extraAddr = ''; // 참고항목 변수

            //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
            if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                addr = data.roadAddress;
            } else { // 사용자가 지번 주소를 선택했을 경우(J)
                addr = data.jibunAddress;
            }

            // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
            if(data.userSelectedType === 'R'){
                // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                    extraAddr += data.bname;
                }
                // 건물명이 있고, 공동주택일 경우 추가한다.
                if(data.buildingName !== '' && data.apartment === 'Y'){
                    extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                }
                // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                if(extraAddr !== ''){
                    extraAddr = ' (' + extraAddr + ')';
                }
                // 조합된 참고항목을 해당 필드에 넣는다.
                document.getElementById("sample6_extraAddress").value = extraAddr;
            
            } else {
                document.getElementById("sample6_extraAddress").value = '';
            }

            // 우편번호와 주소 정보를 해당 필드에 넣는다.
            document.getElementById('sample6_postcode').value = data.zonecode;
            document.getElementById("sample6_address").value = addr;
            // 커서를 상세주소 필드로 이동한다.
            document.getElementById("sample6_detailAddress").focus();
        }
    }).open();
}</script>
<%@ include file="/WEB-INF/views/layout/footer.jsp"%>
