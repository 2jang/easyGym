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
        <title>회원 리스트</title>
        <link href="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/style.min.css" rel="stylesheet" />
        <link href="/css/admin/styles.css" rel="stylesheet" />
        <script src="https://use.fontawesome.com/releases/v6.3.0/js/all.js" crossorigin="anonymous"></script>
    </head>
    <body class="sb-nav-fixed">
        <nav class="sb-topnav navbar navbar-expand navbar-dark bg-dark">
            <!-- Navbar Brand-->
            <a class="navbar-brand ps-3" href="/admin/memberList.do">관리자 페이지</a>
            <!-- Sidebar Toggle-->
            <button class="btn btn-link btn-sm order-1 order-lg-0 me-4 me-lg-0" id="sidebarToggle" href="#!"><i class="fas fa-bars"></i></button>
            <!-- Navbar Search-->
            <form class="d-none d-md-inline-block form-inline ms-auto me-0 me-md-3 my-2 my-md-0">
                <div class="input-group">
                    <input class="form-control" type="text" placeholder="Search for..." aria-label="Search for..." aria-describedby="btnNavbarSearch" />
                    <button class="btn btn-primary" id="btnNavbarSearch" type="button"><i class="fas fa-search"></i></button>
                </div>
            </form>
            <!-- Navbar-->
            <ul class="navbar-nav ms-auto ms-md-0 me-3 me-lg-4">
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" id="navbarDropdown" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false"><i class="fas fa-user fa-fw"></i></a>
                    <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdown">
                        <li><a class="dropdown-item" href="/main.do">Home</a></li>
                        <li><hr class="dropdown-divider" /></li>
						<c:if test="${sessionScope.admin != null && sessionScope.admin.adminId != null}">
						    <li><a class="dropdown-item" href="/admin/logout.do">Logout</a></li>
						</c:if>
						<c:if test="${sessionScope.admin == null || sessionScope.admin.adminId == null}">
						    <li><a class="dropdown-item" href="/admin/loginForm.do">Login</a></li>
						</c:if>
                    </ul>
                </li>
            </ul>
        </nav>
        <div id="layoutSidenav">
            <div id="layoutSidenav_nav">
                <nav class="sb-sidenav accordion sb-sidenav-dark" id="sidenavAccordion">
					<div class="sb-sidenav-menu">
                       <div class="nav">
                           <div class="sb-sidenav-menu-heading">Management</div> <!-- 회원 관리 및 업체 리스트 관리 -->
                           <a class="nav-link collapsed" href="#" data-bs-toggle="collapse" data-bs-target="#collapseLayouts" aria-expanded="false" aria-controls="collapseLayouts">
                               <div class="sb-nav-link-icon"><i class="fas fa-columns"></i></div>
                               회원
                               <div class="sb-sidenav-collapse-arrow"><i class="fas fa-angle-down"></i></div>
                           </a>
                           <div class="collapse" id="collapseLayouts" aria-labelledby="headingOne" data-bs-parent="#sidenavAccordion">
                               <nav class="sb-sidenav-menu-nested nav">
                                   <a class="nav-link" href="/admin/memberList.do">Member List</a> <!-- 회원 리스트로 이동-->
                                   <a class="nav-link" href="/admin/withdrawMem.do">Withdraw Member</a>
                               </nav>
                           </div>
                           <a class="nav-link collapsed" href="#" data-bs-toggle="collapse" data-bs-target="#collapsePages" aria-expanded="false" aria-controls="collapsePages">
                               <div class="sb-nav-link-icon"><i class="fas fa-book-open"></i></div>
                               사업자
                               <div class="sb-sidenav-collapse-arrow"><i class="fas fa-angle-down"></i></div>
                           </a>
                           <div class="collapse" id="collapsePages" aria-labelledby="headingTwo" data-bs-parent="#sidenavAccordion">
                               <nav class="sb-sidenav-menu-nested nav accordion" id="sidenavAccordionPages">
                                   <a class="nav-link" href="/admin/operList.do">Operator List</a> <!-- 사업자 리스트로 이동-->
                                   <a class="nav-link" href="/admin/companyList.do">Company List</a>
                               </nav>
                           </div>
                           <div class="sb-sidenav-menu-heading">Comunity</div>
                           <a class="nav-link" href="/admin/noticeList.do">
                               <div class="sb-nav-link-icon"><i class="fas fa-chart-area"></i></div>
                               공지사항
                           </a>
                           <a class="nav-link" href="/admin/reportList.do">
                               <div class="sb-nav-link-icon"><i class="fas fa-table"></i></div>
                               신고리스트
                           </a>
                       </div>
                   </div>
                    <div class="sb-sidenav-footer">
                        <div class="small">isix</div>
                        easyGym
                    </div>
                </nav>
            </div>
            <div id="layoutSidenav_content">
                <main> <!-- ------------------------------------main---------------------------------------------- -->
                    <div class="container-fluid px-4">
                        <h1 class="mt-4">회원</h1>
                        <ol class="breadcrumb mb-4">
                            <li class="breadcrumb-item"><a href="/admin/memberList.do">메인으로</a></li>
                            <li class="breadcrumb-item active">Tables</li>
                        </ol>
                        <div class="card mb-4">
                            <div class="card-body">
                                가입중인 회원 목록 리스트
                                
                            </div>
                        </div>
                        <div class="card mb-4">
                            <div class="card-header">
                                <i class="fas fa-table me-1"></i>
                                회원목록
                            </div>
                            <div class="card-body">
                                <table id="datatablesSimple">
                                    <thead>
                                        <tr>
                                            <th>회원 번호</th>
                                            <th>회원 이름</th>
                                            <th>회원 아이디</th>
                                            <th>전화번호</th>
                                            <th>회원 이메일</th>
                                            <th>회원 주소</th>
                                        </tr>
                                    </thead>
                                    <tfoot>
                                        <tr>
											<th>회원 번호</th>
                                            <th>회원 이름</th>
                                            <th>회원 아이디</th>
                                            <th>전화번호</th>
                                            <th>회원 이메일</th>
                                            <th>회원 주소</th>
                                        </tr>
                                    </tfoot>
                                    <tbody>
										<c:choose>
											<c:when test="${mlist == null }">
												<tr>
													<td colspan="7">
														<p align="center">가입한 회원이 없습니다.</p>
													</td>
												<tr>
											</c:when>
											<c:when test="${mlist != null }">
												<c:forEach var="mem" items="${mlist}">
			                                        <tr>
			                                            <td>${mem.memberNo}</td>
			                                            <td>${mem.memberName}</td>
			                                            <td>${mem.memberId}</td>
			                                            <td>${mem.memberPhone}</td>
			                                            <td>${mem.memberEmail}</td>
			                                            <td>${mem.memberAddr}</td>
			                                        </tr>  
												</c:forEach>	
											</c:when> 
										</c:choose>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </main>
                <footer class="py-4 bg-light mt-auto">
                    <div class="container-fluid px-4">
                        <div class="d-flex align-items-center justify-content-between small">
                            <div class="text-muted">Copyright &copy; easyGym</div>
                        </div>
                    </div>
                </footer>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
        <script src="/js/admin/scripts.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/umd/simple-datatables.min.js" crossorigin="anonymous"></script>
        <script src="/js/admin/datatables-simple-demo.js"></script>
    </body>
</html>
