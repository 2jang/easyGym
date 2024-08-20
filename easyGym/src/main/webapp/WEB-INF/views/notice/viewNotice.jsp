<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<%
    request.setCharacterEncoding("utf-8");
%>

<%@ include file="/WEB-INF/views/layout/header.jsp"%>
<link href="/css/notice/detail.css" rel="stylesheet" />
<section id="banner">
    <header>
        <h2>Notice Board</h2>
    </header>
    <p>공지사항 페이지입니다. 중요한 소식, 업데이트, 이벤트, 공지사항 등을 <br>이곳에서 확인하실 수 있습니다.
        항상 최신 정보를 받아보실 수 있도록 자주 방문해주세요.
        </p>
</section>
<article id="main">
        <table class="details-table">
            <thead>
                <tr>
                    <th class="title">제목</th>
                    <th class="author">작성자</th>
                    <th class="hit">조회수</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td class="title">${noMap.notice.noticeTitle}</td>
                    <td class="author">admin</td>
                    <td class="hit">${noMap.notice.noticeHit}</td>
                </tr>
                <tr>
                    <td colspan="3" class="content">${noMap.notice.noticeContent}</td>
                </tr>
                <c:if test="${not empty noMap.imageFileList}">
                    <tr>
                        <td colspan="3">
                            <div class="image-container">
                                <c:forEach var="imgList" items="${noMap.imageFileList}" varStatus="status">
                                    <img id="preview${status.count}" src="<c:url value='/nodownload.do'/>?noticeNo=${imgList.noticeNo}&imageFileName=${imgList.imageFileName}">
                                </c:forEach>
                            </div>
                        </td>
                    </tr>
                </c:if>
            </tbody>
        </table>

        <div class="button-group">
            <input class="btn btn-outline-secondary reBtn" type="button" value="돌아가기" onclick="location.href='/notice/noticeList.do'">
        </div>
</article>

<%@ include file="/WEB-INF/views/layout/footer.jsp"%>
