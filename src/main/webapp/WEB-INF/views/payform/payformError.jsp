<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<%
    request.setCharacterEncoding("utf-8");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" name="viewport" content="width=device-width, initial-scale=1.0">
    <title>이지짐 구매 에러</title>
    <link rel="stylesheet" type="text/css" href="${contextPath}/CSS/payform/payformDone.css">

</head>
<body>
<div class="bg-image"></div>
<div class="container">
    <h1>구매 중 오류 발생!</h1>
    <form id="payCheck_form">
        <div class="form_group">
            <div class="paymentInfo">
                <div class="form_group">
                    <label>구매중 오류가 발생했습니다. 다시 결제해주세요!</label>
                </div>
            </div>
        </div>
        <button type="button" id="goBack" onclick="window.history.back();">뒤로 돌아가기</button>
    </form>
</div>

</body>
</html>