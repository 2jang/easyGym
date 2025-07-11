$(document).ready(function() {
    if (!sessionStorage.getItem('pageLoaded')) {
        // 페이지가 처음 로드되었을 때
        sessionStorage.setItem('pageLoaded', 'true');
        location.reload();
    } else {
        // 뒤로가기로 페이지에 돌아왔을 때
        sessionStorage.removeItem('pageLoaded');
    }

    // 페이지를 떠날 때 (다른 페이지로 이동할 때) 세션 스토리지를 초기화합니다.
    $(window).on('beforeunload', function() {
        sessionStorage.removeItem('pageLoaded');
    });

    // 뒤로가기 이벤트를 감지하여 페이지를 새로고침합니다.
    window.onpageshow = function(event) {
        if (event.persisted) {
            location.reload();
        }
    };

    var requestInProgress = false;

    function centerModal() {
        var modal = document.getElementById('reportModal');
        var modalContent = document.querySelector('.modal-content');
        if (modal && modalContent) {
            var windowHeight = window.innerHeight;
            var modalHeight = modalContent.offsetHeight;
            var scrollTop = window.scrollY || window.pageYOffset;

            // 스크롤 위치와 화면 중앙을 기준으로 모달 콘텐츠 위치 조정
            modalContent.style.position = 'absolute'; // 절대 위치로 설정
            modalContent.style.top = `${Math.max((windowHeight - modalHeight) / 2, 0) + scrollTop}px`;
        }
    }
    $(".report-button").click(function(event) {
        var memberNo = $('.memberNo').val();
        var detailNo = $('.detailNo').val();
        event.stopPropagation();

        if (!memberNo) {
            showAlert("로그인이 필요합니다. 로그인 페이지로 이동합니다.");
            let address = window.location.href;
            window.location.href = '/member/loginForm.do?action=' + encodeURIComponent(address);
            return;
        }

        // 서버 요청 처리 중일 때 추가 요청 방지
        if (requestInProgress) return;
        requestInProgress = true;

        $.ajax({
            type: "POST",
            url: "/detail/selectReport.do",
            data: { memberNo: memberNo,
                detailNo: detailNo
            },
            success: function(response) {
                console.log('Server response:', response); // 응답 로그 추가
                requestInProgress = false; // 요청 완료 후 플래그 리셋
                if (response === "noBuy") {
                    showAlert("회원권을 구매하신 고객님만 불편 사항을 제출할 수 있습니다.");
                } else if (response === "alreadyReport") {
                    showAlert("이미 불편 사항을 제출한 이력이 있습니다.");
                } else if (response === "memberShip") {
                    var modal = document.getElementById('reportModal');
                    if (modal) {
                        modal.style.display = 'flex'; // 모달을 화면 중앙에 표시
                        centerModal(); // 중앙 위치 조정
                    } else {
                        console.error('모달 창을 찾을 수 없습니다.');
                    }
                }
            },
            error: function(xhr, status, error) {
                requestInProgress = false; // 오류 발생 시 플래그 리셋
                console.error('Error:', error);
            }
        });
    });



    // 취소 버튼 클릭 시 모달 창 숨기기
    document.getElementById('cancelReport').addEventListener('click', function() {
        document.getElementById('reportModal').style.display = 'none';
    });

    // 신고 유형 선택 시 기타 입력 필드 표시
    document.getElementById('reportType').addEventListener('change', function() {
        var selectedValue = this.value;
        var otherInput = document.getElementById('otherInput');

        if (selectedValue === 'other') {
            otherInput.style.display = 'block';
        } else {
            otherInput.style.display = 'none';
        }
    });

    // 확인 버튼 클릭 시 모달 닫기 및 입력 값 처리
    document.getElementById('confirmReport').addEventListener('click', function() {
        var reportType = document.getElementById('reportType').value;
        var otherDetail = document.getElementById('otherDetail').value;
        var reportContent = (reportType === 'other') ? otherDetail : reportType; // 신고 내용
        var detailNo = $('.detailNo').val();
        var memberNo = $('.memberNo').val();
        if (!reportContent) {
            showAlert('신고 내용을 입력하세요.');
            return;
        }

        // Ajax 요청
        $.ajax({
            type: "POST",
            url: `/report.do`,
            data: {
                detailNo: detailNo,
                memberNo: memberNo,
                reportContent: reportContent // 선택된 신고 유형 또는 기타 입력 값
            },
            success: function(response) {
                // 요청 성공 시 처리
                showAlert('신고가 접수되었습니다.');
                document.getElementById('reportModal').style.display = 'none'; // 모달 닫기
            },
            error: function(xhr, status, error) {
                console.error('Error:', error);
            }
        });
    });

    // 윈도우 크기 조정 및 스크롤 시 모달 중앙 위치 조정
    window.addEventListener('resize', centerModal);
    window.addEventListener('scroll', centerModal);

    $(window).on('scroll', function() {
        var scrollTop = $(window).scrollTop();
        var fixedContainer = $('#fixedContainer');

        if (scrollTop > 500) {
            fixedContainer.fadeIn(); // 500px 스크롤 시 보이게 함
        } else {
            fixedContainer.fadeOut(); // 500px 이하일 때 숨김
        }
    });





    // 이미지 슬라이드
    $(function() {
        $('.slider_panel').append($('.slider_image').first().clone());  // 마지막 5번째 사진 뒤에 1번째 사진을 복제해서 붙여둠
        $('.slider_panel').prepend($('.slider_image').eq(-2).clone());  // 첫번째 사진 앞에 마지막 5번째 사진을 복제해서 붙여둠
        let index = 1;  // 마지막 5번 사진을 붙였으니 1로 바꿔야함.
        $('.slider_panel').css('left', -700);  // 첫 화면에서 5번이 보이고 1번으로 나오는 화면을 없애기 위한 작업
        $('.slider_text').hide();  // 첫 화면에서 5번이 보이고 1번으로 나오는 화면을 없애기 위한 작업
        $('.slider_text').eq(0).show();  // 첫 화면에서 5번이 보이고 1번으로 나오는 화면을 없애기 위한 작업
        $('.slider_panel').on('mousedown','img',function (event){
            event.preventDefault();
        });
        $('.control_button').click(function() {
            index = $(this).index();
            moveSlider(index + 1);  // 아래 버튼도 +1을 해줌
        });


        $('.control_button').click(function() {
            index = $(this).index();
            moveSlider(index + 1);  // 아래 버튼도 +1을 해줌
        });

        $('.left_control').click(function() {
            if (index > 1) {
                index--;
                moveSlider(index);
            } else {
                $('.slider_panel').css('left', -7700);
                index = 10;
                moveSlider(index);
            }
        });

        $('.right_control').click(function() {
            if (index < 10) {  // 기존 : < 4 / 이미지 앞뒤로 추가하고는 < 5로 바꿈
                index++;
                moveSlider(index);
            } else {
                $('.slider_panel').css('left', 0);
                index = 1;
                moveSlider(index);
            }
        });

        // 이미지 슬라이드 구현 함수
        function moveSlider(index) {
            $('.slider_panel').animate({
                left: -(index * 700)
            }, 'slow');
            $('.control_button').removeClass('active');
            $('.control_button').eq(index - 1).addClass('active');
            $('.slider_text').hide();  // 설명글을 fadeout 안하고 바로 사라지게
            $('.slider_text').eq(index - 1).fadeIn('slow');  // 설명글을 보이게 함
        }
    });


});
document.addEventListener('DOMContentLoaded', (event) => {
    const textareas = document.querySelectorAll('.auto-resize-textarea');

    const adjustHeight = (textarea) => {
        textarea.style.height = 'auto'; // 높이 자동 설정
        textarea.style.height = `${textarea.scrollHeight}px`; // 실제 내용 높이로 설정
    };

    textareas.forEach(textarea => {
        textarea.addEventListener('input', () => adjustHeight(textarea));
        // 초기 높이 조절
        adjustHeight(textarea);
    });
});
//alert 표현 기능
function showAlert(message) {
    var alertContainer = $("#alertContainer");

    if (alertContainer.children().length >= 2) {
        alertContainer.children().first().remove(); // 가장 오래된 알림을 제거
    }

    var alertMessage = $("<div>").addClass("alertMessage").text(message);
    alertContainer.append(alertMessage);

    setTimeout(function() {
        alertMessage.remove();
    }, 3000); // 3초 후에 알림 제거
}
// 글 등록하기
function writeSubmit() {
    var memberNo = $('.memberNo').val();

    if (!memberNo) {
        showAlert("로그인이 필요합니다. 로그인 페이지로 이동합니다.");
        let address = window.location.href;
        window.location.href = '/member/loginForm.do?action=' + encodeURIComponent(address);
        return;
    }

    var detailNo = $('.detailNo').val();
    var reviewComment = $('#myTextarea').val();
    var reviewRating = $("input[name='detailScope']:checked").val();
    var fileInput = $('#reviewImageName')[0].files;

    // 파일 크기 검사 및 필터링
    const MAX_SIZE = 1 * 1024 * 1024; // 1MB in bytes
    const filesToUpload = Array.from(fileInput).filter(file => {
        if (file.size > MAX_SIZE) {
            showAlert("1MB 이상의 파일은 등록할 수 없습니다. 다른 파일을 선택해 주세요.");
            return false;
        }
        return true;
    });

    if (filesToUpload.length !== fileInput.length) {
        // 파일 크기 초과로 인해 업로드할 수 없는 경우
        return;
    }

    // FormData 객체 생성
    var formData = new FormData();
    formData.append('detailNo', detailNo);
    formData.append('memberNo', memberNo);
    formData.append('reviewComment', reviewComment);
    formData.append('reviewRating', reviewRating);

    // FormData에 파일 추가
    filesToUpload.forEach((file) => {
        formData.append('reviewImageName', file);
    });

    $.ajax({
        async: false,
        enctype: 'multipart/form-data',
        cache: false,
        url: '/writeReview.do',
        type: 'POST',
        data: formData,
        processData: false,
        contentType: false,
    })
        .done(function(response) {
            if (response === "success") {
                showAlert("작성하신 후기가 등록되었습니다.");

                // 리뷰 목록을 새로고침
                refreshReviews(detailNo);
            } else if (response === "noBuy") {
                showAlert("후기 작성은 회원권을 구매하신 회원님만 가능합니다");
            } else if (response === "reviewLimitExceeded") {
                showAlert("회원권 구매횟수에 따라 후기작성을 할 수 있습니다.");
            }
        })
        .fail(function(xhr, status, error) {
            console.error("Error:", error);
            console.error("Status:", status);
            console.error("Response:", xhr.responseText);
        });
}
// 리뷰 이미지 업데이트 (삭제 전용)
function updateReviewImagesForDeletion(detailNo) {
    $.ajax({
        url: '/getReviewImages.do',
        type: 'GET',
        dataType: 'json',
        cache: false,
        data: { detailNo: detailNo },
        success: function(response) {
            var reviewImageContainer = $('#reviewImage');
            reviewImageContainer.empty(); // 기존 이미지 제거

            // 서버로부터 받은 응답이 비어있는 경우, 이미지 컨테이너는 이미 비워졌으므로 추가 처리 없음
            if (!response || !Array.isArray(response) || response.length === 0) {
                console.log("No images to display.");
            }
        },
        error: function(xhr, status, error) {
            console.error("Error:", error);
            console.error("Status:", status);
            console.error("Response:", xhr.responseText);
        }
    });
}

function refreshReviews(detailNo) {
    $.ajax({
        url: '/getReviews.do',
        type: 'GET',
        dataType: 'json',
        data: { detailNo: detailNo },
        success: function(reviews) {
            var reviewContainer = $('#reviewContainer');
            reviewContainer.empty(); // 기존 리뷰 목록을 비웁니다

            const reviewsToShow = reviews.slice(0, 2); // 첫 2개 리뷰만 표시
            reviewsToShow.forEach(function(review) {
                var starsHtml = '';
                for (var i = 1; i <= 5; i++) {
                    if (i <= review.reviewRating) {
                        starsHtml += '<span class="star filled">★</span>';
                    } else {
                        starsHtml += '<span class="star">☆</span>';
                    }
                }

                var reviewHtml = `
                    <div class="ReviewRange" data-review-no="${review.reviewNo}">
                        <input class="reviewNo" type="hidden" value="${review.reviewNo}"/>
                        <button class="deleteButton" onclick="deleteComment(${review.reviewNo})">삭제</button>
                        <div class="personReviewRange">
                            <img class="reviewPicture" src="${contextPath}/images/detail/detailpage/reviewImage.png">
                            <p class="anonymous">(익명의 회원)</p>
                            <div class="stars">
                                ${starsHtml}
                            </div>
                            <p class="reviewDate">${review.reviewDate}</p>
                            <textarea class="reviewComment" readonly>${review.reviewComment}</textarea>
                        </div>
                    </div>
                `;
                reviewContainer.append(reviewHtml);
            });

            if (reviews.length > 2) {
                var viewAllReviewsHtml = `<a href="${contextPath}/detail/reviewViewer.do?detailNo=${detailNo}" class="viewAllReviews">후기 ${reviews.length}개 전체보기</a>`;
                reviewContainer.append(viewAllReviewsHtml);
            }

            // 리뷰 이미지 새로고침
            updateReviewImages(detailNo);
        },
        error: function(xhr, status, error) {
            console.error("Error:", error);
            console.error("Status:", status);
            console.error("Response:", xhr.responseText);
        }
    });
}

// 리뷰 이미지 업데이트
function updateReviewImages(detailNo) {
    $.ajax({
        url: '/getReviewImages.do',
        type: 'GET',
        dataType: 'json',
        cache: false,
        data: { detailNo: detailNo },
        success: function(response) {
            var reviewImageContainer = $('#reviewImage');
            reviewImageContainer.empty(); // 기존 이미지 제거

            // 데이터가 비어있을 경우 처리
            if (response && Array.isArray(response) && response.length > 0) {
                response.slice(0, 5).forEach(function(image) {
                    var imageHtml = `
                            <img class="reviewImage" style="width:130px; height:130px;" 
                                src="${contextPath}/images/detail/reviewImage/${image.detailNo}/${image.memberNo}/${image.reviewImgName}"/>`;
                    reviewImageContainer.append(imageHtml);
                });
            } else {
                console.log("No images to display.");
            }
        },
        error: function(xhr, status, error) {
            console.error("Error:", error);
            console.error("Status:", status);
            console.error("Response:", xhr.responseText);
        }
    });
}
function deleteComment(reviewNo) {
    var memberNo = $('.memberNo').val(); // 회원 번호를 가져옵니다.
    var detailNo = $('.detailNo').val(); // 업체 번호를 가져옵니다.

    if (!memberNo) {
        showAlert("로그인이 필요합니다. 로그인 페이지로 이동합니다.");
        let address = window.location.href;
        window.location.href = '/member/loginForm.do?action=' + encodeURIComponent(address);
        return;
    }

    $.ajax({
        type: "POST",
        url: "/delete.do",
        data: {
            reviewNo: reviewNo,
            memberNo: memberNo,
            detailNo: detailNo
        },
        success: function(data) {
            if (data === "success") {
                showAlert("해당 글은 삭제되었습니다.");

                // 삭제된 리뷰를 화면에서 제거합니다.
                $('.ReviewRange').each(function() {
                    var currentReviewNo = $(this).data('review-no');
                    if (currentReviewNo == reviewNo) {
                        $(this).remove(); // 해당 리뷰 요소를 제거합니다.
                    }
                });

                // 리뷰와 이미지 새로고침
                refreshReviews(detailNo);
                updateReviewImagesForDeletion(detailNo); // 함수명 업데이트
            } else if (data === "noBuy") {
                alert("해당 글은 해당 업체 회원권을 구매하고 자신이 작성한 글만 삭제 가능합니다.");
            } else if (data === "differentMember") {
                alert("해당 글은 직접 작성한 후기만 삭제할 수 있습니다.");
            }
        },
        error: function(xhr, status, error) {
            console.error("Error: " + error);
            alert("서버와의 통신에 문제가 발생했습니다. 다시 시도해 주세요.");
        }
    });
}