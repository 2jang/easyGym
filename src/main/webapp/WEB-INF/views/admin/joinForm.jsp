<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<%
    request.setCharacterEncoding("utf-8");
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
        <meta name="description" content="" />
        <meta name="author" content="" />
        <title>Register - SB Admin</title>
        <link href="/css/admin/styles.css" rel="stylesheet" />
        <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
    </head>
    <body class="bg-primary">
        <div id="layoutAuthentication">
            <div id="layoutAuthentication_content">
                <main>
                    <div class="container">
                        <div class="row justify-content-center">
                            <div class="col-lg-7">
                                <div class="card shadow-lg border-0 rounded-lg mt-5">
                                    <div class="card-header"><h3 class="text-center font-weight-light my-4">Create Account</h3></div>
                                    <div class="card-body">
                                        <form action="/admin/joinAd.do" method="post" id="admin-join-form">
                                            <div class="row mb-3">
                                                <div class="col-md-6">
                                                    <div class="form-floating mb-3 mb-md-0">
                                                        <input class="form-control" id="inputFirstName" name="adminId" type="text" placeholder="Enter your first name" />
                                                        <label for="inputFirstName">아이디</label>
                                                    </div>
                                                </div> 
												<div class="col-md-6">
                                                    <div class="form-floating mb-3 mb-md-0">
                                                        <input class="form-control" id="inputPassword" name="adminPwd" type="password" placeholder="Create a password" />
                                                        <label for="inputPassword">비밀번호</label>
                                                    </div>
                                                </div>          
                                            </div>
											<div class="form-floating mb-3">
	                                                <input class="form-control" id="inputPhone" name="adminPhone" type="text" placeholder="010-1234-1234" />
	                                                <label for="inputPhone">전화번호</label>
	                                            </div>
                                            <div class="form-floating mb-3">
                                                <input class="form-control" id="inputEmail" name="adminEmail" type="email" placeholder="name@example.com" />
                                                <label for="inputEmail">이메일</label>
                                            </div>
                                            <div class="cf-turnstile"
                                                 data-sitekey="0x4AAAAAABzyMbhmo7j2Zd0d"
                                                 data-theme="auto"
                                                 data-size="flexible"
                                                 data-callback="onTurnstileSuccessAdminJoin"
                                                 data-error-callback="onTurnstileErrorAdminJoin"
                                                 data-expired-callback="onTurnstileExpiredAdminJoin"
                                                 style="margin: 20px 0;">
                                            </div>
                                            <div class="mt-4 mb-0">
                                                <div class="d-grid"><a class="btn btn-primary btn-block" href="/admin/loginForm.do"><input type="submit" value="가입하기" id="admin-join-submit" disabled></a></div>
                                            </div>
                                        </form>
                                    </div>
                                    <div class="card-footer text-center py-3">
                                        <div class="small"><a href="login.html">Have an account? Go to login</a></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </main>
            </div>
            <div id="layoutAuthentication_footer">
                <footer class="py-4 bg-light mt-auto">
                    <div class="container-fluid px-4">
                        <div class="d-flex align-items-center justify-content-between small">
                            <div class="text-muted">Copyright &copy; Your Website 2023</div>
                            <div>
                                <a href="#">Privacy Policy</a>
                                &middot;
                                <a href="#">Terms &amp; Conditions</a>
                            </div>
                        </div>
                    </div>
                </footer>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
        <script src="/js/admin/scripts.js"></script>
        <script type="text/javascript">
            function onTurnstileSuccessAdminJoin(token) {
                var btn = document.getElementById('admin-join-submit');
                if (btn) btn.disabled = false;
            }
            function onTurnstileErrorAdminJoin() {
                var btn = document.getElementById('admin-join-submit');
                if (btn) btn.disabled = true;
            }
            function onTurnstileExpiredAdminJoin() {
                var btn = document.getElementById('admin-join-submit');
                if (btn) btn.disabled = true;
            }
        </script>
        <script src="https://challenges.cloudflare.com/turnstile/v0/api.js" async defer></script>
    </body>
</html>
