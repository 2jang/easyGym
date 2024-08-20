<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<%
    request.setCharacterEncoding("utf-8");
%>
<%@ include file="/WEB-INF/views/layout/header.jsp"%>
<script>
    var contextPath = "${contextPath}";
</script>
<link rel="stylesheet" href="${contextPath}/css/mypage/mypageMain.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="${contextPath}/js/mypage/mypageMain.js"></script>
<style>
.form-group {
        display: flex;
        align-items: center;
        margin-bottom: 15px; /* 각 항목 간의 간격을 조절합니다 */
    }

    .form-group label {
        margin-right: 10px; /* 레이블과 입력 필드 간의 간격을 조절합니다 */
        font-weight: bold;
        width: 150px; /* 레이블의 너비를 조절합니다 */
    }

    .form-group input {
        flex: 1; /* 입력 필드가 가능한 공간을 차지하도록 설정합니다 */
        padding: 8px;
        .button-container {
    display: flex;
    gap: 10px; /* 버튼 간의 간격을 조정할 수 있습니다 */
}

.button {
    padding: 10px 20px; /* 버튼의 크기를 동일하게 조정 */
    font-size: 16px;    /* 글자 크기 */
    color: white;       /* 글자 색상 */
    background-color: #007bff; /* 버튼 배경 색상 */
    border: none;       /* 버튼의 테두리 없애기 */
    border-radius: 4px; /* 버튼 모서리 둥글게 */
    cursor: pointer;    /* 커서 모양 변경 */
}

.button a {
    color: white; /* 버튼 안의 링크 색상 */
    text-decoration: none; /* 링크의 밑줄 제거 */
}
#withdraw-form{
	display:inline;
}
</style>
<section id="banner">
    <header>
        <h2>My page</h2>
    </header>
    <p>
    <c:choose>
                <c:when test="${not empty sessionScope.member}">
                    ${sessionScope.member.memberName}님, 회원님의 개인정보를<br>
                    수정할 수 있으며 활동 내역과 찜 목록 등을 관리하실 수 있습니다. 
                </c:when>
                <c:otherwise>
                    로그인을 해주세요.
                </c:otherwise>
            </c:choose></p>
</section>
<div class="container">


    <div class="nav">
        <button class="nav-btn active" data-target="my-info">내 정보</button>
        <button class="nav-btn" data-target="searchHistory">내역조회</button>
        <button class="nav-btn" data-target="update-info">정보수정</button>
    </div>
    <div class="content">
        <div class="sidebar">
            <button class="button primary active" data-target="using-products">이용중인 상품</button>
            <button class="button primary" data-target="dibs-list" onclick="fn_dibsList();">찜 목록</button>
			<button class="button primary" data-target="points">포인트</button>
        </div>
        <div class="main-content">
			<!-- 내 정보 탭 안에 사이드바 -->
            <div id="using-products" class="section active">
                <h2>이용중인 상품</h2>
                <!-- 이용 중인 상품 목록이 여기에 동적으로 로드됩니다 -->
            </div>
            <div id="dibs-list" class="section">
                <h2>찜 목록</h2>
                <!-- mypageMain.js 파일에 finction 및 테이블 구조 만들어져 있음 -->
            </div>
			<div id="points" class="section">
                <h2>포인트 적립/사용 내역</h2>
				<table>
					<tr><th>번호</th><th>적립/사용 내역</th><th>포인트 금액</th><th>적용일자</th></tr>
					<tr><td colspan="4">적립내역이 없습니다.</td></tr>
				</table>
            </div>
			
			<!-- 내역조회 탭 안에 사이드바 -->
            <div id="purchaseHistory" class="section">
                <h2>구매내역</h2>
                <img src="${contextPath}/images/payform/ana.png" alt="커밍 쑨!">
            </div>
			<div id="reportHistory" class="section">
                <h2>신고내역</h2>
                <img src="${contextPath}/images/payform/ana.png" alt="커밍 쑨!">
            </div>
			<div id="reviewHistory" class="section">
                <h2>리뷰내역</h2>
                <img src="${contextPath}/images/payform/ana.png" alt="커밍 쑨!">
            </div>
            
			<!-- 정보수정 탭 -->
            <div id="update-info" class="section">
                <div align="center" id="password-check">
                    <h2 style="margin-bottom: 10px;">비밀번호 확인</h2>
                    <form id="password-check-form" style="margin-bottom: 10px;">
                        <input class="passwordcheck" type="password" id="password" placeholder="비밀번호 확인">
                        <input type="hidden" id="memberNo" value="${member.memberNo}"> <!-- 멤버 번호를 위한 숨겨진 입력 필드 -->
                        <button type="button" id="password-check-btn">확인</button>
                    </form>
                </div>
                <div class="modify" id="update-form" style="display:none;  width: 600px; align=center;">
                    <h2>회원정보 수정</h2>
                    <form method="post" action="${contextPath}/mypage/memberUpdate.do" id="form">
                        <input type="hidden" id="memberNo" value="${member.memberNo}">
                        <div class="form-group">
                        	<label for ="memberName">이름</label>
                        	<input type="text" value="${member.memberName}" disabled></div>
                        	<div class="form-group">
                        	<label for ="memberId">아이디</label>
                        	<input type="text" value="${member.memberId}" disabled></div>
                        	<div class="form-group">
                        	<label for ="memberPwd">비밀번호</label>
                        	<input type="password" id="memberPwd" value="${member.memberPwd}"></div>
                        	<div class="form-group">
                        	<label for ="memberPwdConfirm">비밀번호 확인</label>
                        	<input type="password" id="memberPwdConfirm" value="${member.memberPwd}"></div>
							<div class="form-group">
                        	<label for ="memberPhone">휴대전화</label>
                        	<input type="text" id="memberPhone" value="${member.memberPhone}" ></div>
                        	<div class="form-group">
                        	<label for ="memberEmail">이메일</label>
                        	<input type="text" id="memberEmail" value="${member.memberEmail}" ></div>
                       </form>
                       <div class="button-container" style="margin-bottom: 30px;">
						    <button class="button primary" type="button" id="update-btn">수정하기</button>
						    <button class="button primary" id="cancel-btn" style="color:#fff; text-decoration:none;"><a href="${contextPath}/mypage/mypageMain.do">취소하기</a></button>
						    <button class="button primary" type="button" id="withdraw-btn">회원탈퇴</button>
						</div>
                </div>
            </div>
        </div>
    </div>
</div>
<%@ include file="/WEB-INF/views/layout/footer.jsp"%>