function removeComment(reviewNo) {
    var memberNo = $('.memberNo').val(); // 회원 번호를 가져옵니다.
    var detailNo = $('.detailNo').val(); // 업체 번호를 가져옵니다.

    if (!memberNo) {
        alert("로그인이 필요합니다. 로그인 페이지로 이동합니다.");
        let address = window.location.href;
        window.location.href = '/member/loginForm?action=' + encodeURIComponent(address);
        return;
    }

    $.ajax({
        type: "POST",
        url: "/delete",
        data: {
            reviewNo: reviewNo,
            memberNo: memberNo,
            detailNo: detailNo
        },
        success: function(data) {
            if (data === "success") {
                alert("해당 글은 삭제되었습니다.");
                // 페이지 새로고침
                location.reload();
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

function refreshReviews(detailNo) {
    $.ajax({
        url: '/getReviews',
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
                var viewAllReviewsHtml = `<a href="${contextPath}/detail/reviewViewer?detailNo=${detailNo}" class="viewAllReviews">후기 ${reviews.length}개 전체보기</a>`;
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