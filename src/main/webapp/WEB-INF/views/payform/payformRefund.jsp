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
    <title>이지짐 환불 완료</title>
    <link rel="stylesheet" type="text/css" href="${contextPath}/css/payform/payformRefund.css">
</head>
<body>
<div class="bg-image"></div>
<div class="container">
    <h1>환불이 완료되었습니다!</h1>
    <form id="payCheck_form">
        <div class="form_group">
            <div class="paymentInfo">
                <div class="form_group">
                    <label for="payName">구매자:</label>
                    <input type="text" id="payName" name="payName" value="${payform.memberName}" readonly required>
                </div>
                <div class="form_group">
                    <label for="userTel">휴대전화:</label>
                    <input type="text" id="userTel" name="userTel" value="${payform.memberPhone}" readonly required>
                </div>
                <div class="form_group">
                    <label for="bisName">헬스장 이름:</label>
                    <input type="text" id="bisName" name="bisName" value="${payform.detailBusinessName}" readonly required>
                </div>
                <div class="form_group">
                    <label for="refPoint">반환된 포인트:</label>
                    <input type="text" id="refPoint" name="refPoint" style="width:85%;" value="${payform.payformUsePoints}" readonly required>
                    <span id="pointsTag"> Points</span>
                </div>
            </div>

            <label for="finalPr">환불 금액:</label>
            <div id="finalPr"><span id="fp">${refundPrice}</span>원</div>
            <script>
                let fpElement = document.getElementById('fp');
                let finalPrice = fpElement.innerText;
                let fp = parseInt(finalPrice);
                fpElement.innerText = fp.toLocaleString();
            </script>
        </div>
        <button type="button" id="goBack" onclick="window.location.href='${contextPath}/main.do'">확인</button>
    </form>
</div>

</body>
</html>