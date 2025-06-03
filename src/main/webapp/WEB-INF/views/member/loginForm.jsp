<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/layout/header.jsp"%>
<style>
    /* 전체 폼 스타일 - 연한 회색 보더 추가 */
    form {
        border: 1px solid #ddd; /* 연한 회색 보더 */
        padding: 30px; /* 내부 여백을 1.5배로 */
        border-radius: 15px; /* 모서리 둥글게 */
        max-width: 525px; /* 폼의 최대 너비를 1.5배로 설정 */
        margin: 0 auto; /* 폼 전체 가운데 정렬 */
    }

    /* 입력 필드 스타일 */
    input[type="text"], input[type="password"] {
        width: 100%; /* 가로폭을 폼 너비에 맞춤 */
        margin-bottom: 15px; /* 아래 여백을 1.5배로 */
        padding: 15px; /* 필드 안의 패딩을 1.5배로 */
        border-radius: 15px; /* 모서리 둥글게 */
        border: 1px solid #ccc; /* 입력 필드 보더 */
        box-sizing: border-box; /* 패딩 포함한 크기 조정 */
        font-size: 1rem; /* 폰트 크기를 1.5배로 */
    }

    /* 로그인 버튼 스타일 */
    button.button.primary {
        width: 90%; /* 버튼이 폼의 너비를 채우도록 */
        padding: 15px; /* 버튼 안의 패딩을 1.5배로 */
        background-color: #6cc4b2; /* 버튼 색상 */
        color: white; /* 버튼 텍스트 색상 */
        border: none; /* 기본 보더 제거 */
        cursor: pointer; /* 커서 포인터 */
        margin-top: 15px; /* 버튼과 다른 요소 간의 여백을 1.5배로 */
        font-size: 24px; /* 폰트 크기를 1.5배로 */
        line-height: 1.2; /* 텍스트 줄 높이 */
    }
    
    .kakao-login-button img {
        width: 98%; /* 버튼이 폼의 너비를 채우도록 */
        text-align: center; /* 텍스트 및 이미지 중앙 정렬 */
        display: flex; /* 내부 요소 가운데 정렬을 위해 flex 사용 */
        align-items: center;
        justify-content: center;
        box-sizing: border-box; /* 패딩 포함한 크기 조정 */
        padding: 10px; /* 버튼 안의 패딩을 1.5배로 */
        font-size: 24px; /* 폰트 크기를 1.5배로 */
    }

    /* 회원가입 링크 스타일 */
    .joinSubmit {
        margin-top: 7px; /* 위쪽 여백을 1.5배로 */
        text-align: left; /* 링크 왼쪽 정렬 */
    }

    .joinSubmit a {
        color: #3498db; /* 링크 색상 */
        text-decoration: none; /* 기본 밑줄 제거 */
        font-size: 0.7rem; /* 폰트 크기를 1.5배로 */
    }

    .joinSubmit a:hover {
        text-decoration: underline; /* 마우스 오버시 밑줄 추가 */
    }
    /* 폼을 배너 쪽으로 올리기 위해 섹션 상단 여백 조정 */
    .wrapper.style4.special.container.medium {
        margin-top: -50px; /* 필요한 만큼 값을 조정 */
    }
</style>

<section id="banner">
    <header>
        <h2>Sign in</h2>
    </header>
    <p>로그인 페이지에 오신 것을 환영합니다. 사용자 아이디와 비밀번호를 입력하시고<br>
    로그인 버튼을 클릭하시면, 개인화된 서비스와 설정에 접근하실 수 있습니다.</p>
    <footer>
    </footer>
</section>

<article id="main">
    <!-- One -->
    <section class="wrapper style4 special container medium">
        <!-- Content -->
        <div class="content">
            <form class="text-center mb-3" action="/member/login.do" onsubmit="return check(this)" method="post">
               <img class="mb-4" src="/images/member/user.png" alt="로그인" width="72" height="72">
                <div class="row gtr-50">
                    <div class="col-12">
                        <input type="text" name="memberId" id="memberId" placeholder="아이디를 입력해주세요." autocomplete="off"/>
                    </div>
                    <div class="col-12">
                        <input type="password" name="memberPwd" placeholder="비밀번호를 입력해주세요." id="memberPwd" autocomplete="current-password" />
                    </div>
                </div>
                <div class="joinSubmit" >
                    <a href="${contextPath}/member/joinCheck.do">회원가입</a>
                </div>
                <button class="button primary" type="submit" style="background-color: #82D3C9; border-radius: 15px;">로그인</button>
<%--                <a href="javascript:fn_kakao()" class="kakao-login-button">--%>
<%--                    <img src="/images/member/kakao_login_large_wide.png" alt="카카오 로그인 버튼">--%>
<%--                </a>--%>
            </form>
        </div>
    </section>
</article>

<!-- 로그인 실패 시 알러트 띄우기 -->
<c:if test="${not empty loginError}">
    <script type="text/javascript">
        alert("${loginError}");
    </script>
</c:if>

<script src="/js/member/kakao.js"></script>
<%@ include file="/WEB-INF/views/layout/footer.jsp"%>
