document.addEventListener('DOMContentLoaded', function () {
   // 초기 설정
   const navButtons = document.querySelectorAll('.nav-btn');
   const sections = document.querySelectorAll('.section');
   const sidebar = document.querySelector('.sidebar');
   const mainContent = document.querySelector('.main-content');

   // 사이드바 버튼 클릭 이벤트 핸들러
   function sidebarBtnClickHandler(event) {
      const sidebarButtons = document.querySelectorAll('.sidebar-btn');
      sidebarButtons.forEach(btn => btn.classList.remove('active'));
      event.target.classList.add('active');

      sections.forEach(section => section.classList.remove('active'));
      const targetSection = document.getElementById(event.target.dataset.target);
      if (targetSection) {
         targetSection.classList.add('active');
      }
   }

   // 1.내 정보 탭을 클릭할 때의 처리
   function myInfoTabHandler() {
      sidebar.style.display = 'block';
      mainContent.style.width = '70%';
      sidebar.innerHTML = `
            <button class="sidebar-btn active" data-target="using-products">이용중인 상품</button>
            <button class="sidebar-btn" data-target="dibs-list">찜 목록</button>
			<button class="sidebar-btn" data-target="points">포인트</button>
        `;
      document.querySelectorAll('.sidebar-btn').forEach(btn => btn.addEventListener('click', sidebarBtnClickHandler));
      document.getElementById('using-products').classList.add('active');
   }

   // 2.내역조회 탭을 클릭할 때의 처리
   function searchHistoryTabHandler() {
      sidebar.style.display = 'block';
      mainContent.style.width = '70%';
      sidebar.innerHTML = `
         <button class="sidebar-btn active" data-target="purchaseHistory">구매내역</button>
         <button class="sidebar-btn" data-target="reportHistory">신고내역</button>
         <button class="sidebar-btn" data-target="reviewHistory">리뷰내역</button>
      `;
      document.querySelectorAll('.sidebar-btn').forEach(btn => btn.addEventListener('click', sidebarBtnClickHandler));
      document.getElementById('purchaseHistory').classList.add('active');
	  // 구매내역 로드
      loadPurchaseHistory();
	  // 항상 찜 목록을 새로고침
      fn_dibsList();
	  // 리뷰내역 로드
	  loadReviewHistory();
	  // 신고내역 로드
	  loadReportHistory();
   }

   // 3.정보 수정 탭을 클릭할 때의 처리
   function updateInfoTabHandler() {
      sidebar.style.display = 'none';
      mainContent.style.width = '100%';
      const updateInfoSection = document.getElementById('update-info');
      if (updateInfoSection) {
         updateInfoSection.classList.add('active', 'fullscreen');
      }
   }

   // 탭 버튼 클릭 이벤트
   navButtons.forEach(button => {
      button.addEventListener('click', () => {
         navButtons.forEach(btn => btn.classList.remove('active'));
         button.classList.add('active');

         sections.forEach(section => section.classList.remove('active', 'fullscreen'));

         if (button.dataset.target === 'my-info') {
            myInfoTabHandler();
         } else if (button.dataset.target === 'searchHistory') {
            searchHistoryTabHandler();
         } else {
            updateInfoTabHandler();
         }
      });
   });

   // 초기 내 정보 탭 설정
   myInfoTabHandler();

   // 비밀번호 확인 이벤트 (여기 addEventListener가 찜 목록과 충돌나게 함.)

   const passwordCheckBtn = document.getElementById('password-check-btn');
   if (passwordCheckBtn) {
      passwordCheckBtn.addEventListener('click', checkPassword);
   }

   function checkPassword() {
      //alert("비밀번호체크");
      var memberPwd = document.getElementById('password').value;
      var memberNo = document.getElementById('memberNo').value;
      if (!memberNo || !memberPwd) {
         alert("멤버 번호와 비밀번호를 입력해 주세요.");
         return;
      }

      // FormData 객체 생성
      var formData = new FormData();
      formData.append('memberNo', memberNo);
      formData.append('memberPwd', memberPwd);

      // 비밀번호 확인을 위해 POST 요청
      fetch(`${contextPath}/mypage/checkPassword.do`, {
         method: 'POST',
         body: formData
      })
          .then(response => {
             if (!response.ok) {
                throw new Error('Network response was not ok');
             }
             return response.json(); // 서버 응답을 JSON으로 파싱
          })
          .then(data => {
             if (data) { // 반환된 값이 true인지 확인
                document.getElementById('password-check').style.display = 'none';
                document.getElementById('update-form').style.display = 'block';
             } else {
                alert("비밀번호가 올바르지 않습니다.");
             }
          })
          .catch(error => {
             console.error('Error:', error);
             alert("서버와의 통신 중 오류가 발생했습니다.");
          });
   }


   // 포인트 내역 필터링 이벤트
   const filterPointsBtn = document.getElementById('filter-points-btn');
   if (filterPointsBtn) {
      filterPointsBtn.addEventListener('click', function() {
         var startDate = document.getElementById('start-date').value;
         var endDate = document.getElementById('end-date').value;
         alert('조회기간: ' + startDate + ' ~ ' + endDate);
      });
   }

   // 정보수정 클릭 이벤트
   const updateBtn = document.getElementById('update-btn');
   const withdrawBtn = document.getElementById('withdraw-btn');

   if (updateBtn) {
      updateBtn.addEventListener('click', function(event) {
         event.preventDefault();

         const memberPwd = document.getElementById('memberPwd').value;
         const memberPwdConfirm = document.getElementById('memberPwdConfirm').value;
         const memberPhone = document.getElementById('memberPhone').value;
         const memberEmail = document.getElementById('memberEmail').value;

         if (memberPwd !== memberPwdConfirm) {
            alert("비밀번호가 일치하지 않습니다.");
            return;
         }

         const formData = new URLSearchParams();
         formData.append('memberPwd', memberPwd);
         formData.append('memberPhone', memberPhone);
         formData.append('memberEmail', memberEmail);

         fetch(`${contextPath}/mypage/memberUpdate.do`, {
            method: 'POST',
            headers: {
               'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: formData.toString()
         })
             .then(response => {
                if (!response.ok) {
                   throw new Error('Network response was not ok');
                }
                return response.text();
             })
             .then(data => {
                window.location.href = `${contextPath}/mypage/mypageMain.do`;
             })
             .catch(error => {
                console.error('Error:', error);
                alert("서버와의 통신 중 오류가 발생했습니다.");
             });
      });
   }

   //회원탈퇴
   if (withdrawBtn) {
      withdrawBtn.addEventListener('click', function() {
         const memberNo = document.getElementById('memberNo').value;

         const formData = new URLSearchParams();
         formData.append('memberNo', memberNo);

         fetch(`${contextPath}/mypage/withdraw.do`, {
            method: 'POST',
            headers: {
               'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: formData.toString()
         })
             .then(response => {
                if (!response.ok) {
                   throw new Error('Network response was not ok');
                }
                return response.text();
             })
             .then(data => {
                alert("회원탈퇴가 완료되었습니다.");
                window.location.href = `${contextPath}/main.do`;
             })
             .catch(error => {
                console.error('Error:', error);
                alert("서버와의 통신 중 오류가 발생했습니다.");
             });
      });
   }


   // 취소 버튼 클릭 이벤트
   const cancelBtn = document.getElementById('cancel-btn');
   if (cancelBtn) {
      cancelBtn.addEventListener('click', function() {
         location.href = `${contextPath}/mypage/mypageMain.do`; // 마이페이지 첫 화면으로 이동
      });
   }


   // 찜 목록 버튼 클릭 이벤트 추가
   const dibsListBtn = document.querySelector('[data-target="dibs-list"]');
   if (dibsListBtn) {
      dibsListBtn.addEventListener('click', fn_dibsList);
   }
});

//1-2)찜 목록 불러오기
function fn_dibsList() {
   fetch(`${contextPath}/mypage/mypageMain.do`, {
      method: 'POST',
      headers: {
         'Content-Type': 'application/json',
      },
   })
       .then(response => response.json())
       .then(data => {
          let tableHtml = '<table><tr><th>번호</th><th>업체명</th><th>프로그램명</th><th>지역</th><th>찜</th></tr>';
          if (data.dibsList && data.dibsList.length > 0) {
             data.dibsList.forEach((dibs, index) => {
                tableHtml += `<tr>
                    <td>${index + 1}</td>
                    <td>${dibs.detailBusinessName}</td>
                    <td>${dibs.detailKoClassification}</td>
                    <td>${dibs.detailRoadAddress}</td>
                    <td><button onclick="fn_removeDibs(${dibs.detailNo})">삭제</button></td>
                </tr>`;
             });
          } else {
             tableHtml += '<tr><td colspan="5">찜 목록이 없습니다.</td></tr>';
          }
          tableHtml += '</table>';
          document.getElementById('dibs-list').innerHTML = '<h2>찜 목록</h2>' + tableHtml;
       })
       .catch(error => {
          console.error('Error:', error);
          alert('찜 목록을 불러오는 중 오류가 발생했습니다.');
       });
}

//찜 목록 취소하기
function fn_removeDibs(detailNo) {
   fetch(`${contextPath}/mypage/removeDibs.do?detailNo=${detailNo}`, {
      method: 'GET'
   })
       .then(response => {
          if (!response.ok) {
             throw new Error('Network response was not ok');
          }
          return response.text();
       })
       .then(() => {
          alert('찜이 취소되었습니다.');
          fn_dibsList(); // 찜 목록 새로고침
       })
       .catch(error => {
          console.error('Error:', error);
          alert('찜 취소 중 오류가 발생했습니다.');
       });
}

//이용중인 상품 불러오기
function loadUsingProducts() {
   fetch(`${contextPath}/mypage/mypageMain.do`, {
      method: 'POST',
      headers: {
         'Content-Type': 'application/json',
      },
   })
       .then(response => response.json())
       .then(data => {
          let html = '';
          if (data.payformList && data.payformList.length > 0) {
             data.payformList.forEach(payform => {
                html += `
                        <div class="item">
                            <div class="info">
                                <p>이용권</p>
                            </div>
                            <div class="details">
                                <p>업체명: ${payform.detailBusinessName}</p>
                                <p>구독 개월: ${payform.payformSub}개월</p>
                                
                            </div>
                            <div class="actions">
                                <button onclick="cancelPayform(${payform.payformNo})">취소하기</button>
                            </div>
                        </div>
                    `;
             });
          } else {
             html = '<p>이용 중인 상품이 없습니다.</p>';
          }
          document.getElementById('using-products').innerHTML = '<h2>이용중인 상품</h2>' + html;
       })
       .catch(error => {
          console.error('Error:', error);
          alert('이용 중인 상품 목록을 불러오는 중 오류가 발생했습니다.');
       });
}

//결제 취소하기
function cancelPayform(payformNo) {
   // 동적으로 form 생성
   var form = document.createElement('form');
   form.method = 'POST';
   form.action = contextPath + '/payform/payformCancel.do';

   // payformNo를 위한 hidden input 추가
   var input = document.createElement('input');
   input.type = 'hidden';
   input.name = 'payformNo';
   input.value = payformNo;
   form.appendChild(input);

   // form을 body에 추가하고 제출
   document.body.appendChild(form);
   form.submit();
}

// 페이지 로드 시 이용 중인 상품 목록 불러오기
document.addEventListener('DOMContentLoaded', function() {
   loadUsingProducts();
   // 기존의 이벤트 리스너들 유지
});

// 2.내역조회
// 구매내역 불러오기
function loadPurchaseHistory() {
   fetch(`${contextPath}/mypage/searchHistory.do`, {
      method: 'POST',
      headers: {
         'Content-Type': 'application/json',
      },
   })
   .then(response => {
      if (!response.ok) {
         throw new Error('Network response was not ok');
      }
      return response.json(); // JSON으로 응답 파싱
   })
   .then(data => {
      console.log('응답 데이터:', data); // 데이터 로그
      let tableHtml = '<table><tr><th>번호</th><th>업체명</th><th>구독개월수</th><th>결제금액</th><th>결제일</th></tr>';
      if (data.purchaseHistory && data.purchaseHistory.length > 0) {
         data.purchaseHistory.forEach((purchase, index) => {
            tableHtml += `<tr>
               <td width="10%">${index + 1}</td>
               <td width="30%">${purchase.detailBusinessName}</td>
               <td width="20%">${purchase.payformSub}</td>
               <td width="20%">${purchase.payformPrice}</td>
               <td width="20%">${purchase.payformDate}</td>
            </tr>`;
         });
      } else {
         tableHtml += '<tr><td colspan="5">구매내역이 없습니다.</td></tr>';
      }
      tableHtml += '</table>';
      document.getElementById('purchaseHistory').innerHTML = '<h2>구매내역</h2>' + tableHtml;
   })
   .catch(error => {
      console.error('Error:', error);
      alert('구매내역을 불러오는 중 오류가 발생했습니다.');
   });
}

// 리뷰내역 불러오기
function loadReviewHistory() {
   fetch(`${contextPath}/mypage/searchHistory.do`, {
      method: 'POST',
      headers: {
         'Content-Type': 'application/json',
      },
   })
   .then(response => {
      if (!response.ok) {
         throw new Error('Network response was not ok');
      }
      return response.json(); // JSON으로 응답 파싱
   })
   .then(data => {
      console.log('응답 데이터:', data); // 데이터 로그
      let tableHtml = '<table><tr><th>번호</th><th>업체명</th><th>리뷰내용</th><th>작성일</th></tr>';
      if (data.reviewHistory && data.reviewHistory.length > 0) {
         data.reviewHistory.forEach((review, index) => {
            tableHtml += `<tr>
               <td>${index + 1}</td>
               <td>${review.detailBusinessName}</td>
               <td>${review.reviewComment}</td>
               <td>${review.reviewDate}</td>
            </tr>`;
         });
      } else {
         tableHtml += '<tr><td colspan="5">리뷰내역이 없습니다.</td></tr>';
      }
      tableHtml += '</table>';
      document.getElementById('reviewHistory').innerHTML = '<h2>리뷰내역</h2>' + tableHtml;
   })
   .catch(error => {
      console.error('Error:', error);
      alert('리뷰내역을 불러오는 중 오류가 발생했습니다.');
   });
}

// 신고내역 불러오기
function loadReportHistory() {
   fetch(`${contextPath}/mypage/searchHistory.do`, {
      method: 'POST',
      headers: {
         'Content-Type': 'application/json',
      },
   })
   .then(response => {
      if (!response.ok) {
         throw new Error('Network response was not ok');
      }
      return response.json(); // JSON으로 응답 파싱
   })
   .then(data => {
      console.log('응답 데이터:', data); // 데이터 로그
      let tableHtml = '<table><tr><th>번호</th><th>업체명</th><th>신고내용</th><th>작성일</th></tr>';
      if (data.reportHistory && data.reportHistory.length > 0) {
         data.reportHistory.forEach((report, index) => {
            tableHtml += `<tr>
               <td>${index + 1}</td>
               <td>${report.detailBusinessName}</td>
               <td>${report.reportContent}</td>
               <td>${report.reportDate}</td>
            </tr>`;
         });
      } else {
         tableHtml += '<tr><td colspan="5">신고내역이 없습니다.</td></tr>';
      }
      tableHtml += '</table>';
      document.getElementById('reportHistory').innerHTML = '<h2>신고내역</h2>' + tableHtml;
   })
   .catch(error => {
      console.error('Error:', error);
      alert('신고내역을 불러오는 중 오류가 발생했습니다.');
   });
}
