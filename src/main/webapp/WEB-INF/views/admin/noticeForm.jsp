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
        <title>공지사항 페이지</title>
        <link href="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/style.min.css" rel="stylesheet" />
        <link href="/css/admin/styles.css" rel="stylesheet" />
        <link href="/css/notice/style.css" rel="stylesheet" />
		<script src="/js/admin/scripts.js"></script>
		<script src="/js/admin/script.js"></script>
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
                <main>
                    <div class="container-fluid px-4">
                        <h1 class="mt-4">공지사항 작성</h1>
                        <ol class="breadcrumb mb-4">
                            <li class="breadcrumb-item"><a href="/admin/index.do">메인으로</a></li>
                            <li class="breadcrumb-item active">공지</li>
                        </ol>
                        <div class="card mb-4">
                            <div class="card-body">
                                DataTables is a third party plugin that is used to generate the demo table below. For more information about DataTables, please visit the
                                <a target="_blank" href="https://datatables.net/">official DataTables documentation</a>
                                .
                            </div>
                        </div>
                        <div class="card mb-4">
                           
                            <div class="card-body">
								<form name="formName" id="formId">  <!-- enctype="multipart/form-data" : 글과 이미지가 함께 넘어갈 수 있게 함 -->
									<div class="form-container">
									    <div class="mb-3">
									        <label for="boardWriter" class="form-label">작성자</label>
									        <input type="text" class="form-control" name="adminId" id="boardWriter" value="${sessionScope.admin.adminId}" readonly> 
									    </div>
									    <div class="mb-3">
									        <label for="boardTitle" class="form-label">제목</label>
									        <input type="text" class="form-control" name="noticeTitle" id="boardTitle">
									    </div>
									    <div class="mb-3">
									        <label for="boardContent" class="form-label">내용</label>
									        <textarea class="form-control" id="boardContent" name="noticeContent" rows="3"></textarea>
									    </div>
									    <div class="input-group mb-3">
									        <input type="file" class="form-control"  value="파일추가" id="inputGroupFile04" aria-describedby="inputGroupFileAddon04" name="imageFileName" aria-label="Upload" onclick="fn_addFile()" >
											<div id="dock_file"></div>
									        <button class="btn btn-outline-secondary" type="button" id="inputGroupFileAddon04" >확인</button>
									    </div>
										<div class="dropdown-container">
										    <div class="btn-group" id="dropdownContainer">
										        <button type="button" class="btn btn-outline-info dropdown-toggle custom-select-btn" id="dropdownMenuButton" onclick="toggleDropdown()">
										            선택
										        </button>
										        <div class="dropdown-menu custom-select-dropdown" id="customSelectDropdown">
													<a class="dropdown-item" name="noticeCategory" onclick="selectOption(1)">필독</a>
													<a class="dropdown-item" name="noticeCategory" onclick="selectOption(0)">일반</a>
										        </div>
										    </div>
										    <div class="upload-btn ms-auto">
										        <button class="btn btn-outline-secondary" type="button" id="uploadButton">업로드</button>
										    </div>
										</div>
									</div>
								  </form>
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
        
        <script src="https://cdn.jsdelivr.net/npm/simple-datatables@7.1.2/dist/umd/simple-datatables.min.js" crossorigin="anonymous"></script>
        <script src="/js/admin/datatables-simple-demo.js"></script>
		<script>
		        // JavaScript 코드를 여기에 작성
		        document.addEventListener('DOMContentLoaded', function() {
		            var uploadButton = document.getElementById('uploadButton');
		            uploadButton.addEventListener('click', function() {
		                console.log('업로드 버튼 클릭됨');
		                // 추가적인 로직 구현
		            });
		        });
				
				document.addEventListener('DOMContentLoaded', function() {
				    var uploadButton = document.getElementById('uploadButton');
				    uploadButton.addEventListener('click', function() {
				        var form = document.formName;
				        form.action = '/admin/addNotice.do';
				        form.method = 'post';
				        form.enctype = 'multipart/form-data';
				        form.submit();
				    });
				});
				
				
		  </script>
    </body>
</html>
