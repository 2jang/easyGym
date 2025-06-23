<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/layout/header.jsp"%>
<style>
    .image.featured img {
        width: 100%;
        height: 270px;
    }
    .card-img-top {
        width: 100%;
        height: 200px;
        object-fit: cover;
    }
    .card {
        display: flex;
        flex-direction: column;
        height: 100%;
        overflow: hidden;
    }
    .card-body {
        flex: 1;
    }
    footer.major {
        text-align: center;
    }
    .intro-text {
        font-size: 17px;
        color: #888;
    }
    @font-face {
        font-family: 'S-CoreDream-3Light';
        src: url('https://fastly.jsdelivr.net/gh/projectnoonnu/noonfonts_six@1.2/S-CoreDream-3Light.woff') format('woff');
        font-weight: normal;
        font-style: normal;
    }
    @font-face {
        font-family: 'SUITE-Regular';
        src: url('https://fastly.jsdelivr.net/gh/projectnoonnu/noonfonts_2304-2@1.0/SUITE-Regular.woff2') format('woff2');
        font-weight: 400;
        font-style: normal;
    }
    @font-face {
        font-family: 'NanumSquareRound';
        src: url('https://fastly.jsdelivr.net/gh/projectnoonnu/noonfonts_two@1.0/NanumSquareRound.woff') format('woff');
        font-weight: normal;
        font-style: normal;
    }
    p, h2, h3, span {
        font-family: 'SUITE-Regular', sans-serif;
    }
    a{
        color:#000;
    }
</style>

<!-- Banner -->
<section id="banner">
    <div class="inner">
        <header>
            <h2>EASYGYM</h2>
        </header>
        <p>This is <strong>EASYGYM</strong>. Discover<br />
            the Best Gyms near you.
        </p>
        <footer>
            <ul class="buttons stacked">
                <li><a href="${contextPath}/detail/search.do?query=" class="button fit scrolly">Search My Location</a></li>
            </ul>
        </footer>
    </div>
</section>

<!-- Main -->
<article id="main">
    <header class="special container">
        <span></span>
        <h3 class="intro-text">가장 좋은 헬스장, 필라테스 스튜디오, 그리고 복싱 시설을 찾아보세요.
            주변의 최고의 피트니스 장소를 쉽게 찾아보세요.<br> 당신의 피트니스 요구와 라이프스타일에 맞는 완벽한 장소를 찾을 수 있도록 도와드립니다.
        </h3>
    </header>

    <!-- CTA -->
    <section id="cta">
        <c:choose>
            <c:when test="${sessionScope.isLogOn eq false or (sessionScope.member eq null and sessionScope.operator eq null)}">
                <header>
                    <h2>사업자이신가요?</h2>
                    <p>이지짐 사업자로 등록하고, 헬스장이나 운동시설을 보다 효과적으로 관리하고 홍보하세요.<br>지금 등록하셔서 귀하의 시설을 많은 고객들에게 알리고, 더 많은 기회를 잡아보세요!</p>
                </header>
                <footer>
                    <ul class="buttons">
                        <li><a href="/member/operLoginForm.do" class="button primary">Sign In</a></li>
                        <li><a href="/member/operJoinForm.do" class="button">Sign Up</a></li>
                    </ul>
                </footer>
            </c:when>
        </c:choose>
    </section>

     
    <div class="container">
        <h2>헬스장 인기순위</h2>
        <div class="row row-cols-1 row-cols-md-3 g-4">
            <!-- 첫 번째 헬스장 -->
            <c:choose>
                <c:when test="${not empty healthList[0]}">
                    <div class="col">
                        <a href="${contextPath}/detail/detail.do?detailNo=${healthList[0].detailNo}">
                            <div class="card shadow-sm">
                                <img src="${contextPath}/images/detail/${healthList[0].detailClassification}/${healthList[0].detailBusinessEng}/${healthList[0].detailBusinessEng}1.png" class="card-img-top" alt="${healthList[0].detailBusinessName}" onerror="this.onerror=null; this.src='${contextPath}/images/detail/health/bodyCrush/bodyCrush1.png'">
                                <div class="card-body">
                                    <h3 class="card-text">${healthList[0].detailBusinessName}</h3>
                                    <p class="card-text">${healthList[0].detailRoadAddress}</p>
                                </div>
                            </div>
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="col">
                        <div class="card shadow-sm">
                            <img src="${contextPath}/images/placeholder.png" class="card-img-top" alt="Placeholder" onerror="this.onerror=null; this.src='${contextPath}/images/detail/health/bodyCrush/bodyCrush1.png'">
                            <div class="card-body">
                                <p class="card-text">헬스장 정보가 없습니다.</p>
                            </div>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
            <!-- 두 번째 헬스장 -->
            <c:choose>
                <c:when test="${not empty healthList[1]}">
                    <div class="col">
                        <a href="${contextPath}/detail/detail.do?detailNo=${healthList[1].detailNo}">
                            <div class="card shadow-sm">
                                <img src="${contextPath}/images/detail/${healthList[1].detailClassification}/${healthList[1].detailBusinessEng}/${healthList[1].detailBusinessEng}2.png" class="card-img-top" alt="${healthList[1].detailBusinessName}" onerror="this.onerror=null; this.src='${contextPath}/images/detail/health/bodyCrush/bodyCrush1.png'">
                                <div class="card-body">
                                    <h3 class="card-text">${healthList[1].detailBusinessName}</h3>
                                    <p class="card-text">${healthList[1].detailRoadAddress}</p>
                                </div>
                            </div>
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="col">
                        <div class="card shadow-sm">
                            <img src="${contextPath}/images/placeholder.png" class="card-img-top" alt="Placeholder" onerror="this.onerror=null; this.src='${contextPath}/images/detail/health/bodyCrush/bodyCrush1.png'">
                            <div class="card-body">
                                <p class="card-text">헬스장 정보가 없습니다.</p>
                            </div>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
            <!-- 세 번째 헬스장 -->
            <c:choose>
                <c:when test="${not empty healthList[2]}">
                    <div class="col">
                        <a href="${contextPath}/detail/detail.do?detailNo=${healthList[2].detailNo}">
                            <div class="card shadow-sm">
                                <img src="${contextPath}/images/detail/${healthList[2].detailClassification}/${healthList[2].detailBusinessEng}/${healthList[2].detailBusinessEng}3.png" class="card-img-top" alt="${healthList[2].detailBusinessName}" onerror="this.onerror=null; this.src='${contextPath}/images/detail/health/gymLight/gymLight1.png'">
                                <div class="card-body">
                                    <h3 class="card-text">${healthList[2].detailBusinessName}</h3>
                                    <p class="card-text">${healthList[2].detailRoadAddress}</p>
                                </div>
                            </div>
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="col">
                        <div class="card shadow-sm">
                            <img src="${contextPath}/images/placeholder.png" class="card-img-top" alt="Placeholder" onerror="this.onerror=null; this.src='${contextPath}/images/detail/health/gymLight/gymLight1.png'">
                            <div class="card-body">
                                <p class="card-text">헬스장 정보가 없습니다.</p>
                            </div>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
        <footer class="major">
            <ul class="buttons">
                <li><a href="${contextPath}/detail/search.do?query=&detailClassification=health" class="button primary">헬스 더보기</a></li>
            </ul>
        </footer>
         
        <h2>필라테스 인기순위</h2>
        <div class="row row-cols-1 row-cols-md-3 g-4">
            <!-- 첫 번째 필라테스 -->
            <c:if test="${not empty pilatesList[0]}">
                <div class="col">
                    <a href="${contextPath}/detail/detail.do?detailNo=${pilatesList[0].detailNo}">
                        <div class="card shadow-sm">
                            <img src="${contextPath}/images/detail/${pilatesList[0].detailClassification}/${pilatesList[0].detailBusinessEng}/${pilatesList[0].detailBusinessEng}1.png" class="card-img-top" alt="${pilatesList[0].detailBusinessName}" onerror="this.onerror=null; this.src='${contextPath}/images/detail/health/bodyCrush/bodyCrush1.png'">
                            <div class="card-body">
                                <h3 class="card-text">${pilatesList[0].detailBusinessName}</h3>
                                <p class="card-text">${pilatesList[0].detailRoadAddress}</p>
                            </div>
                        </div>
                    </a>
                </div>
            </c:if>
            <!-- 두 번째 필라테스 -->
            <c:if test="${not empty pilatesList[1]}">
                <div class="col">
                    <a href="${contextPath}/detail/detail.do?detailNo=${pilatesList[1].detailNo}">
                        <div class="card shadow-sm">
                            <img src="${contextPath}/images/detail/${pilatesList[1].detailClassification}/${pilatesList[1].detailBusinessEng}/${pilatesList[1].detailBusinessEng}2.png" class="card-img-top" alt="${pilatesList[1].detailBusinessName}" onerror="this.onerror=null; this.src='${contextPath}/images/detail/health/bodyCrush/bodyCrush1.png'">
                            <div class="card-body">
                                <h3 class="card-text">${pilatesList[1].detailBusinessName}</h3>
                                <p class="card-text">${pilatesList[1].detailRoadAddress}</p>
                            </div>
                        </div>
                    </a>
                </div>
            </c:if>
            <!-- 세 번째 필라테스 -->
            <c:if test="${not empty pilatesList[2]}">
                <div class="col">
                    <a href="${contextPath}/detail/detail.do?detailNo=${pilatesList[2].detailNo}">
                        <div class="card shadow-sm">
                            <img src="${contextPath}/images/detail/${pilatesList[2].detailClassification}/${pilatesList[2].detailBusinessEng}/${pilatesList[2].detailBusinessEng}3.png" class="card-img-top" alt="${pilatesList[2].detailBusinessName}" onerror="this.onerror=null; this.src='${contextPath}/images/detail/health/bodyCrush/bodyCrush1.png'">
                            <div class="card-body">
                                <h3 class="card-text">${pilatesList[2].detailBusinessName}</h3>
                                <p class="card-text">${pilatesList[2].detailRoadAddress}</p>
                            </div>
                        </div>
                    </a>
                </div>
            </c:if>
        </div>
        <footer class="major">
            <ul class="buttons">
                <li><a href="${contextPath}/detail/search.do?query=&detailClassification=pilates"" class="button primary">필라테스 더보기</a></li>
            </ul>
        </footer>
         
        <h2>복싱장 인기순위</h2>
        <div class="row row-cols-1 row-cols-md-3 g-4">
            <!-- 첫 번째 복싱장 -->
            <c:if test="${not empty boxingList[0]}">
                <div class="col">
                    <a href="${contextPath}/detail/detail.do?detailNo=${boxingList[0].detailNo}">
                        <div class="card shadow-sm">
                            <img src="${contextPath}/images/detail/${boxingList[0].detailClassification}/${boxingList[0].detailBusinessEng}/${boxingList[0].detailBusinessEng}1.png" class="card-img-top" alt="${boxingList[0].detailBusinessName}" onerror="this.onerror=null; this.src='${contextPath}/images/detail/health/bodyCrush/bodyCrush1.png'">
                            <div class="card-body">
                                <h3 class="card-text">${boxingList[0].detailBusinessName}</h3>
                                <p class="card-text">${boxingList[0].detailRoadAddress}</p>
                            </div>
                        </div>
                    </a>
                </div>
            </c:if>
            <!-- 두 번째 복싱장 -->
            <c:if test="${not empty boxingList[1]}">
                <div class="col">
                    <a href="${contextPath}/detail/detail.do?detailNo=${boxingList[1].detailNo}">
                        <div class="card shadow-sm">
                            <img src="${contextPath}/images/detail/${boxingList[1].detailClassification}/${boxingList[1].detailBusinessEng}/${boxingList[1].detailBusinessEng}2.png" class="card-img-top" alt="${boxingList[1].detailBusinessName}" onerror="this.onerror=null; this.src='${contextPath}/images/detail/health/bodyCrush/bodyCrush1.png'">
                            <div class="card-body">
                                <h3 class="card-text">${boxingList[1].detailBusinessName}</h3>
                                <p class="card-text">${boxingList[1].detailRoadAddress}</p>
                            </div>
                        </div>
                    </a>
                </div>
            </c:if>
            <!-- 세 번째 복싱장 -->
            <c:if test="${not empty boxingList[2]}">
                <div class="col">
                    <a href="${contextPath}/detail/detail.do?detailNo=${boxingList[2].detailNo}">
                        <div class="card shadow-sm">
                            <img src="${contextPath}/images/detail/${boxingList[2].detailClassification}/${boxingList[2].detailBusinessEng}/${boxingList[2].detailBusinessEng}3.png" class="card-img-top" alt="${boxingList[2].detailBusinessName}" onerror="this.onerror=null; this.src='${contextPath}/images/detail/health/bodyCrush/bodyCrush1.png'">
                            <div class="card-body">
                                <h3 class="card-text">${boxingList[2].detailBusinessName}</h3>
                                <p class="card-text">${boxingList[2].detailRoadAddress}</p>
                            </div>
                        </div>
                    </a>
                </div>
            </c:if>
        </div>
        <footer class="major">
            <ul class="buttons">
                <li><a href="${contextPath}/detail/search.do?query=&detailClassification=boxing" class="button primary">복싱 더보기</a></li>
            </ul>
        </footer>
    </div>

    <!-- Shop -->
     
    <section class="wrapper style1 container special">
        <h2>추천 쇼핑 및 참고 사이트</h2>
        <div class="row">
            <div class="col-4 col-12-narrower">
                <section>
                    <span>
                    <a href="https://5colorsfood.co.kr/?gad_source=1&gclid=CjwKCAjwnei0BhB-EiwAA2xuBsNhqOgv84-y_YRFY6s6ZxLzjr-ilMy-ZYddi_MArhc9dVGj8F9HvRoCExsQAvD_BwE" class="image featured">
                    <img src="/images/member/mainshop2.png" alt="" onerror="this.onerror=null; this.src='${contextPath}/images/detail/health/bodyCrush/bodyCrush1.png'"/>
                    </a>
                    </span>
                    <header>
                        <h3>헬스 보충제 쇼핑몰</h3>
                    </header>
                    <p>체중 관리의 새로운 동반자! 효과적인 다이어트 보조제로 건강하게 목표를 달성하세요. 에너지와 자신감을 더해주는 완벽한 솔루션을 만나보세요.</p>
                </section>
            </div>
            <div class="col-4 col-12-narrower">
                <section>
                    <span><a href="https://zerotohero.co.kr/?gad_source=1&gclid=CjwKCAjw2dG1BhB4EiwA998cqJBk0UsTIn0cORgsB6ViiUCPsy3b9s8IC-0nJx1RATkIcp457mc2uxoCDTsQAvD_BwE" class="image featured"><img src="/images/member/mainShop1.png" alt="" onerror="this.onerror=null; this.src='${contextPath}/images/detail/health/bodyCrush/bodyCrush1.png'"/></a></span>
                    <header>
                        <h3>헬스 용품 쇼핑몰</h3>
                    </header>
                    <p>건강과 체력을 위한 필수 아이템! 고품질 헬스 용품과 액세서리로 여러분의 운동 목표를 지원합니다. 체계적인 운동을 위한 신뢰할 수 있는 제품들을 만나보세요.</p>
                </section>
            </div>
            <div class="col-4 col-12-narrower">
                <section>
                    <span><a href="http://demo047.megaweb1.kr/" class="image featured"><img src="/images/member/mainShop4.jpg" alt="" onerror="this.onerror=null; this.src='${contextPath}/images/detail/health/bodyCrush/bodyCrush1.png'"/></a></span>
                    <header>
                        <h3>홈트레이닝 참고 사이트</h3>
                    </header>
                    <p>집에서 편하게, 강력하게! 다양한 운동 프로그램과 전문가의 지도로 목표를 달성하고 운동의 새로운 즐거움을 경험해보세요.</p>
                </section>
            </div>
        </div>
    </section>
</article>

<%-- ====================================================================== --%>
<%--                새로운 JSP/CSS/JS 기반 챗봇 코드 시작                  --%>
<%-- ====================================================================== --%>

<%-- 1. 챗봇 UI를 위한 스타일(CSS) --%>
<style>
    /* 챗봇 버튼 */
    .chatbot-toggle-button {
        position: fixed; bottom: 24px; right: 24px; width: 64px; height: 64px;
        background-color: #2563eb; /* 기본 파란색 */
        color: white;
        border: none;
        border-radius: 9999px;
        display: flex;
        align-items: center;
        justify-content: center;
        cursor: pointer;
        box-shadow: 0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1);
        z-index: 9999;
        transition: background-color 0.2s ease-in-out, transform 0.2s ease-in-out;
    }
    .chatbot-toggle-button:hover {
        background-color: #1d4ed8; /* 더 어두운 파란색 */
        transform: scale(1.05);
    }
    .chatbot-toggle-button svg { width: 28px; height: 28px; }

    /* 챗봇 컨테이너 */
    .chatbot-container {
        position: fixed; bottom: 24px; right: 24px; width: 384px; height: 600px;
        background-color: white; border-radius: 1rem;
        box-shadow: 0 20px 25px -5px rgb(0 0 0 / 0.1), 0 8px 10px -6px rgb(0 0 0 / 0.1);
        z-index: 9999; display: flex; flex-direction: column; overflow: hidden;
        border: 1px solid #e5e7eb; transform-origin: bottom right;
        transition: opacity 0.2s ease-in-out, transform 0.2s ease-in-out;
    }
    .chatbot-hidden {
        opacity: 0; transform: scale(0.95); pointer-events: none;
    }

    /* 챗봇 헤더 */
    .chatbot-header {
        display: flex; align-items: center; justify-content: space-between;
        padding: 0.75rem; border-bottom: 1px solid #e5e7eb; background-color: white; flex-shrink: 0;
    }
    .chatbot-header .title-group { display: flex; align-items: center; gap: 0.5rem; }
    .chatbot-header .title-group svg { width: 24px; height: 24px; color: #4b5563; }
    .chatbot-header h6 { font-size: 1.125rem; font-weight: 600; color: #374151; margin: 0; }
    .chatbot-header .close-button { background: none; border: none; cursor: pointer; padding: 0.25rem; }
    .chatbot-header .close-button svg { width: 20px; height: 20px; }

    /* 메시지 영역 */
    .chatbot-messages {
        flex-grow: 1; padding: 1rem; overflow-y: auto; background-color: #f0f4f8;
    }
    .message-container { display: flex; flex-direction: column; gap: 0.75rem; }
    .message-bubble {
        max-width: 75%; padding: 0.75rem; border-radius: 1.25rem; font-size: 0.875rem;
        box-shadow: 0 1px 2px 0 rgb(0 0 0 / 0.05); white-space: pre-wrap; word-break: break-word; line-height: 1.5;
    }

    /* ▼▼▼ [수정] 선택자를 더 구체적으로 변경하여 우선순위를 높임 ▼▼▼ */
    .message-container .message-user {
        align-self: flex-end;
        background-color: #fff3cd !important; /* 노란색 계열 배경 (tailwind yellow-200) */
        color: #374151;
        border-bottom-right-radius: 0.375rem;
    }
    /* ▼▼▼ [수정] 선택자를 더 구체적으로 변경하여 우선순위를 높임 ▼▼▼ */
    .message-container .message-bot {
        align-self: flex-start;
        background-color: white !important;
        color: #374151;
        border: 1px solid #e5e7eb;
        border-bottom-left-radius: 0.375rem;
    }

    .typing-indicator { display: flex; gap: 4px; padding-top: 5px; }
    .typing-indicator .dot { width: 6px; height: 6px; border-radius: 50%; background-color: #60a5fa; animation: typing 1s infinite; }
    .typing-indicator .dot:nth-child(2) { animation-delay: 0.2s; }
    .typing-indicator .dot:nth-child(3) { animation-delay: 0.4s; }
    @keyframes typing { 0%, 100% { transform: translateY(0); } 50% { transform: translateY(-4px); } }

    /* 입력 영역 */
    .chatbot-input-area { padding: 0.75rem; border-top: 1px solid #e5e7eb; background-color: white; flex-shrink: 0;}
    .chatbot-input-group { display: flex; align-items: center; gap: 0.5rem; }
    .chatbot-input-group input { width: 100%; padding: 0.5rem 0.75rem; font-size: 0.875rem; border: 1px solid #d1d5db; border-radius: 0.375rem; }
    .chatbot-input-group input:focus { outline: none; border-color: #3b82f6; }
    .chatbot-input-group button { width: 36px; height: 36px; color: white; border-radius: 9999px; border: none; cursor: pointer; display: flex; align-items: center; justify-content: center; transition: background-color 0.2s; }
    .chatbot-input-group button svg { width: 20px; height: 20px; }
    .chatbot-input-group button:disabled { background-color: #93c5fd; cursor: not-allowed; }
    .chatbot-input-group button:not(:disabled) { background-color: #3b82f6; }
    .chatbot-input-group button:not(:disabled):hover { background-color: #2563eb; }
</style>

<%-- 2. 챗봇 UI를 위한 HTML 구조 --%>
<!-- 챗봇 열기 버튼 -->
<button class="chatbot-toggle-button" id="chatbot-open-button">
    <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor">
        <path fill-rule="evenodd" d="M4.848 2.771A49.144 49.144 0 0112 2.25c2.43 0 4.817.178 7.152.52 1.978.292 3.348 2.024 3.348 3.97v6.02c0 1.946-1.37 3.678-3.348 3.97a48.901 48.901 0 01-3.476.383.39.39 0 00-.297.15l-2.755 4.133a.75.75 0 01-1.248 0l-2.755-4.133a.39.39 0 00-.297-.15 48.9 48.9 0 01-3.476-.384c-1.978-.29-3.348-2.024-3.348-3.97V6.741c0-1.946 1.37-3.68 3.348-3.97zM6.75 8.25a.75.75 0 01.75-.75h9a.75.75 0 010 1.5h-9a.75.75 0 01-.75-.75zm.75 2.25a.75.75 0 000 1.5H12a.75.75 0 000-1.5H7.5z" clip-rule="evenodd" />
    </svg>
</button>

<!-- 챗봇 메인 컨테이너 -->
<div class="chatbot-container chatbot-hidden" id="chatbot-container">
    <!-- 헤더 -->
    <div class="chatbot-header">
        <div class="title-group">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor">
                <path fill-rule="evenodd" d="M4.848 2.771A49.144 49.144 0 0112 2.25c2.43 0 4.817.178 7.152.52 1.978.292 3.348 2.024 3.348 3.97v6.02c0 1.946-1.37 3.678-3.348 3.97a48.901 48.901 0 01-3.476.383.39.39 0 00-.297.15l-2.755 4.133a.75.75 0 01-1.248 0l-2.755-4.133a.39.39 0 00-.297-.15 48.9 48.9 0 01-3.476-.384c-1.978-.29-3.348-2.024-3.348-3.97V6.741c0-1.946 1.37-3.68 3.348-3.97z" clip-rule="evenodd" />
            </svg>
            <h6>EasyGym 챗봇</h6>
        </div>
        <button class="close-button" id="chatbot-close-button">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor">
                <path fill-rule="evenodd" d="M5.47 5.47a.75.75 0 011.06 0L12 10.94l5.47-5.47a.75.75 0 111.06 1.06L13.06 12l5.47 5.47a.75.75 0 11-1.06 1.06L12 13.06l-5.47 5.47a.75.75 0 01-1.06-1.06L10.94 12 5.47 6.53a.75.75 0 010-1.06z" clip-rule="evenodd" />
            </svg>
        </button>
    </div>

    <!-- 메시지 표시 영역 -->
    <div class="chatbot-messages" id="chatbot-messages">
        <div class="message-container" id="message-container">
            <!-- 초기 메시지 -->
            <div class="message-bubble message-bot">안녕하세요! 저는 EasyGym 챗봇입니다. 무엇을 도와드릴까요?</div>
        </div>
    </div>

    <!-- 사용자 입력 영역 -->
    <div class="chatbot-input-area">
        <div class="chatbot-input-group">
            <input type="text" id="chatbot-user-input" placeholder="메시지를 입력하세요..." autocomplete="off">
            <button id="chatbot-send-button" disabled>
                <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor">
                    <path d="M3.478 2.405a.75.75 0 00-.926.94l2.432 7.905H13.5a.75.75 0 010 1.5H4.984l-2.432 7.905a.75.75 0 00.926.94 60.519 60.519 0 0018.445-8.986.75.75 0 000-1.218A60.517 60.517 0 003.478 2.405z" />
                </svg>
            </button>
        </div>
    </div>
</div>

<%-- 3. 챗봇 UI를 위한 로직(JavaScript) --%>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const openButton = document.getElementById('chatbot-open-button');
        const closeButton = document.getElementById('chatbot-close-button');
        const chatbotContainer = document.getElementById('chatbot-container');
        const messagesDiv = document.getElementById('chatbot-messages');
        const messageContainer = document.getElementById('message-container');
        const userInput = document.getElementById('chatbot-user-input');
        const sendButton = document.getElementById('chatbot-send-button');

        // 챗봇 열기/닫기
        openButton.addEventListener('click', () => {
            chatbotContainer.classList.remove('chatbot-hidden');
            openButton.classList.add('chatbot-hidden');
        });
        closeButton.addEventListener('click', () => {
            chatbotContainer.classList.add('chatbot-hidden');
            openButton.classList.remove('chatbot-hidden');
        });

        // 입력창에 내용이 있을 때만 전송 버튼 활성화
        userInput.addEventListener('input', () => {
            sendButton.disabled = userInput.value.trim() === '';
        });

        // 메시지 전송 처리
        function sendMessage() {
            const userText = userInput.value.trim();
            if (userText === '') return;

            addMessage(userText, 'user');
            userInput.value = '';
            sendButton.disabled = true;

            getBotResponse(userText);
        }

        sendButton.addEventListener('click', sendMessage);
        userInput.addEventListener('keypress', (e) => {
            if (e.key === 'Enter' && !e.shiftKey) {
                e.preventDefault();
                sendMessage();
            }
        });

        // 메시지를 화면에 추가하는 함수
        function addMessage(text, sender, isStreaming = false) {
            const messageBubble = document.createElement('div');

            // ▼▼▼ [수정] 템플릿 리터럴 대신 전통적인 문자열 합치기 사용 ▼▼▼
            messageBubble.className = 'message-bubble message-' + sender;

            const textNode = document.createTextNode(text);
            messageBubble.appendChild(textNode);

            if (isStreaming) {
                const typingIndicator = document.createElement('div');
                typingIndicator.className = 'typing-indicator';
                typingIndicator.innerHTML = '<span class="dot"></span><span class="dot"></span><span class="dot"></span>';
                messageBubble.appendChild(typingIndicator);
                messageBubble.id = 'streaming-message';
            }

            messageContainer.appendChild(messageBubble);
            messagesDiv.scrollTop = messagesDiv.scrollHeight;
            return messageBubble;
        }

        // 봇 응답을 API로부터 스트리밍으로 받아오는 함수
        function getBotResponse(userText) {
            const streamingBubble = addMessage('', 'bot', true);
            let accumulatedText = '';

            const encodedQuestion = encodeURIComponent(userText);
            const eventSourceUrl = '${pageContext.request.contextPath}/chatbot/stream-chat?question=' + encodedQuestion;
            const eventSource = new EventSource(eventSourceUrl);

            eventSource.onmessage = function(event) {
                accumulatedText += event.data;
                streamingBubble.childNodes[0].nodeValue = accumulatedText;
                messagesDiv.scrollTop = messagesDiv.scrollHeight;
            };

            eventSource.onerror = function(error) {
                const typingIndicator = streamingBubble.querySelector('.typing-indicator');
                if(typingIndicator) {
                    typingIndicator.remove();
                }

                if (accumulatedText.trim() === '') {
                    streamingBubble.childNodes[0].nodeValue = "죄송합니다. 서버와 통신 중 오류가 발생했습니다.";
                }

                eventSource.close();
            };
        }
    });
</script>

<%-- ====================================================================== --%>
<%--                새로운 JSP/CSS/JS 기반 챗봇 코드 끝                    --%>
<%-- ====================================================================== --%>

<%@ include file="/WEB-INF/views/layout/footer.jsp"%>