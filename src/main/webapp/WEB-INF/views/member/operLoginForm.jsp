<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/layout/header.jsp"%>
<section id="banner">
    <header>
        <h2>Business User Access</h2>
    </header>
    <p>사업자 회원님, 환영합니다! 아이디와 비밀번호를 입력하시고<br>
    로그인 버튼을 클릭하시면, 귀하의 헬스장을 등록하고 관리할 수 있는<br>
    다양한 서비스에 접근하실 수 있습니다.</p>
</section>
<div class="container mt-5">
   <div class="row justify-content-center">
      <div class="col-md-6">
         <div class="card p-4 border border-light">
            <form class="text-center mb-3" action="/member/operLogin.do" onsubmit="return check(this)" method="post">
               <img class="mb-4" src="/images/member/user.png" alt="로그인" width="72" height="72">
               <div class="form-floating mb-3">
                  <input type="text" class="form-control" id="operatorId"
                     name="operatorId" placeholder="아이디 입력"> <label for="floatingInput"></label>
               </div>
               <div class="form-floating mb-3">
                  <input type="password" class="form-control" id="operatorPwd"
                     name="operatorPwd" placeholder="비밀번호 입력"> <label for="floatingPassword"></label>
               </div>
               <div class="row justify-content-between mb-3">
                  <div class="col-md-6 text-start">
                     <small class="d-block"><a href="/member/operJoin.do">회원가입</a></small>
                  </div>
               </div>
               <button class="btn btn-primary w-100 py-2" type="submit">로그인</button>
            </form>
         </div>
      </div>
   </div>
</div>

<%@ include file="/WEB-INF/views/layout/footer.jsp"%>