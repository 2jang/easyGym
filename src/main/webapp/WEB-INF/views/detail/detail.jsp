<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"
         isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>
<c:set var="member" value="${member}" scope="session"/>
<%
    request.setCharacterEncoding("utf-8");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${details.detailBusinessName}</title>
    <script src="http://code.jquery.com/jquery-latest.min.js"></script>
    <script>
        var contextPath = "${pageContext.request.contextPath}";
    </script>
    <link rel="stylesheet" href="${contextPath}/css/detail/detail.css">
    <script src="${contextPath}/js/detail/detail.js"></script>
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=9a9906a8b7e291e6dddbb2bd165b6d7f&libraries=services"></script>

    <script>
        // ▼▼▼ 여기에 로직을 수정합니다 ▼▼▼

        // 1. 서버에서 전달한 JSON 데이터를 JSP 변수에 할당하고, 이를 바로 JavaScript 변수에 대입합니다.
        // 이 방식은 따옴표 문제를 완벽하게 회피할 수 있습니다.
        const allRandomImages = ${allRandomImagePathsJson};

        /**
         * 이미지 로딩 실패 시, 이 함수를 호출하여 랜덤 대체 이미지를 설정합니다.
         * @param {HTMLImageElement} element - onerror 이벤트가 발생한 <img> 요소
         */
        function setRandomFallbackImage(element) {
            // 무한 루프 방지를 위해 onerror 핸들러를 먼저 제거합니다.
            element.onerror = null;

            // 랜덤 이미지 목록이 비어있지 않은 경우에만 실행
            if (allRandomImages && allRandomImages.length > 0) {
                // 목록에서 랜덤한 인덱스를 선택합니다.
                const randomIndex = Math.floor(Math.random() * allRandomImages.length);
                // 해당 <img> 요소의 src를 새로운 랜덤 이미지 경로로 설정합니다.
                element.src = contextPath + allRandomImages[randomIndex];
            } else {
                // 만약 랜덤 이미지 목록조차 없다면, 기본 이미지로 설정합니다.
                element.src = contextPath + '/images/detail/health/bodyCrush/bodyCrush1.png';
            }
        }

        // ▲▲▲ 여기까지 수정 ▲▲▲

        $(document).ready(function() {
            var requestInProgress = false;

            function updateFavoriteButton(button, status) {
                var newSrc = (status === "insert")
                    ? '${contextPath}/images/detail/detailpage/pickDibs.png'
                    : '${contextPath}/images/detail/detailpage/dibs.png';
                $(button).find('.dibs').attr('src', newSrc);
            }
            function showAlert(message) {
                var alertContainer = $("#alertContainer");
                if (alertContainer.children().length >= 2) {
                    alertContainer.children().first().remove();
                }
                var alertMessage = $("<div>").addClass("alertMessage").text(message);
                alertContainer.append(alertMessage);
                setTimeout(function() {
                    alertMessage.remove();
                }, 3000);
            }
            function checkFavoriteStatus() {
                $(".favorite-button").each(function() {
                    var button = this;
                    var detailNo = $(button).find('.detailNo').val();
                    var memberNo = $('.memberNo').val();
                    if (!memberNo) return;
                    $.ajax({
                        type: "GET",
                        url: "${contextPath}/getFavoriteStatus",
                        data: { detailNo: detailNo, memberNo: memberNo },
                        success: function(data) {
                            if (data === "insert" || data === "delete") {
                                updateFavoriteButton(button, data);
                            }
                        },
                        error: function(xhr, status, error) { console.error("Error: " + error); }
                    });
                });
            }
            checkFavoriteStatus();
            $(".favorite-button").click(function(event) {
                var button = this;
                var detailNo = $(button).find('.detailNo').val();
                var memberNo = $(button).find('.memberNo').val();
                if (!memberNo) {
                    showAlert("로그인이 필요합니다. 로그인 페이지로 이동합니다.");
                    let address = window.location.href;
                    window.location.href = '${contextPath}/member/loginForm.do?action=' + encodeURIComponent(address);
                    return;
                }
                if (requestInProgress) return;
                requestInProgress = true;
                $.ajax({
                    type: "GET",
                    url: "${contextPath}/addFavorite",
                    data: { detailNo: detailNo, memberNo: memberNo },
                    success: function(data) {
                        if (data === "insert" || data === "delete") {
                            showAlert(data === "insert" ? "찜 목록에 추가되었습니다." : "찜 목록에서 삭제되었습니다.");
                            updateFavoriteButton(button, data);
                        }
                        requestInProgress = false;
                    },
                    error: function(xhr, status, error) { console.error("Error: " + error); requestInProgress = false; }
                });
                event.stopPropagation();
            });
        });
    </script>
</head>
<body>
<div id="alertContainer"></div>
<c:choose>
    <c:when test="${!empty details}">
        <div id="detailRange">
            <div id="animation_canvas">
                <div class="slider_panel">
                    <c:forEach var="i" begin="1" end="10">
                        <img class="slider_image"
                             src="${contextPath}/images/detail/${details.detailClassification}/${details.detailBusinessEng}/${details.detailBusinessEng}${i}.png"
                             onerror="setRandomFallbackImage(this)" />
                    </c:forEach>
                </div>
                <div class="left_right_control_panel">
                    <img class="left_control" src="${contextPath}/images/detail/detailpage/arrow_pre.png" alt="">
                    <img class="right_control" src="${contextPath}/images/detail/detailpage/arrow_next.png" alt="">
                </div>
            </div>
            <div id="firstInfo">
                <h3 id="companyName">${details.detailBusinessName}</h3>
                <img id="pointer" src="${contextPath}/images/detail/detailpage/address.png" alt=""><h4 id="address">${details.detailRoadAddress}</h4><a id ="toAddress" href="#2"> ></a><br>
                <img id="fiveStar" src="${contextPath}/images/detail/detailpage/sStar.jpg">
                <p id="gradeLink">후기<a id="toReview" href="#1"> ></a></p><br>
                <img id="dailyTicket" src="${contextPath}/images/detail/detailpage/dailyTicket.png"><br><br>
            </div>
            <div class="buttonRange">
                <button class="report-button">
                    <img class="report" src="${contextPath}/images/detail/detailpage/report.jpg" alt="report">
                </button>
            </div>
            <div class="buttonRange">
                <button class="favorite-button" >
                    <input  type="hidden" class="memberNo" value="${member.memberNo}">
                    <input  type="hidden" class="detailNo" value="${details.detailNo}">
                    <img class="dibs" src="${contextPath}/images/detail/detailpage/dibs.png" alt="Favorite">
                </button>
            </div>
            <div id="reportModal" class="modal">
                <div class="modal-content">
                    <h2>신고하기</h2>
                    <form id="reportForm">
                        <label for="reportType">신고 유형:</label>
                        <select id="reportType">
                            <option value="">선택하세요</option>
                            <option value="facility_cleanliness">시설 청결 상태 불량</option>
                            <option value="exercise_environment">운동 환경이 불편</option>
                            <option value="equipment_diversity">기구가 다양하지 않음</option>
                            <option value="free_services">무료로 제공되는 것들이 제대로 지켜지지 않음</option>
                            <option value="other">기타</option>
                        </select>
                        <div id="otherInput" style="display: none;">
                            <label for="otherDetail">기타 사항:</label>
                            <input type="text" id="otherDetail" name="otherDetail" />
                        </div>
                        <button type="button" id="confirmReport">확인</button>
                        <button type="button" id="cancelReport">취소</button>
                    </form>
                </div>
            </div>
            <div id="memberTicketRange">
                <h4 id="memberTicket">회원권</h4>
                <div class="memberTicketBox">
                    <h3 class="ticket">이지짐 회원권</h3>
                    <h4 id="fieldMonthlyPrice">이지짐회원가</h4>
                    <h3 class="ticketPrice">${details.detailMonthlyTicket}<p class="month">/월</p></h3>
                </div>
            </div>
            <div id="dailyAndInfoRange">
                <h4 id="dailyTicketRange">일일권</h4>
                <div class="memberTicketBox">
                    <h3 class="ticket">${details.detailKoClassification}</h3>
                    <p id="dailyLimit">1회 입장 제한</p>
                    <h4 id="fieldDailyPrice">이지짐회원가</h4>
                    <h3 class="ticketPrice">${details.detailDailyTicket}</h3>
                </div>
                <div id="dailyInfoBox">
                    <h5 id="dailyInfo">일일권 제공 및 안내 사항</h5>
                    <h5 id="dailyInfoDetail">공용락커 사용 | 사워실 이용 가능 | 수건 무료제공 | 운동복 무료제공 | 실내용 운동화 지침</h5>
                </div>
            </div>
            <div id="commentRange">
                <textarea spellcheck="false" class="auto-resize-textarea" readonly>${details.detailComment}</textarea>
            </div>
            <div id="operatingRange" >
                <textarea spellcheck="false" class="auto-resize-textarea" readonly>${details.detailServiceProgram}</textarea>
            </div>
            <div id="convenienceFacility">
                <h4 id="facilityInfo">편의시설</h4>
                <div id="FacilityRange">
                    <img class="FacilityImage" src="${contextPath}/images/detail/conImage/analysis.png" alt="">
                    <img class="FacilityImage" src="${contextPath}/images/detail/conImage/wifi.png" alt="">
                    <img class="FacilityImage" src="${contextPath}/images/detail/conImage/bodyComposition.png" alt="">
                    <img class="FacilityImage" src="${contextPath}/images/detail/conImage/cloth.png" alt="">
                    <img class="FacilityImage" src="${contextPath}/images/detail/conImage/locker.png" alt="">
                    <img class="FacilityImage" src="${contextPath}/images/detail/conImage/shower.png" alt="">
                    <img class="FacilityImage" src="${contextPath}/images/detail/conImage/tower.png" alt="">
                </div>
            </div>
            <div id="imageRange">
                <h4 id="imageInfo">사진</h4>
                <div id="imageBox">
                    <c:forEach var="i" begin="1" end="10">
                        <img src="${contextPath}/images/detail/${details.detailClassification}/${details.detailBusinessEng}/${details.detailBusinessEng}${i}.png" height="130" width="130"
                             onerror="setRandomFallbackImage(this)">
                    </c:forEach>
                </div>
            </div>
            <div id="reviewImageRange">
                <div id="reviewImage">
                    <c:choose>
                        <c:when test="${!empty reviewImage}">
                            <c:forEach var="img" items="${reviewImage}">
                                <img class="reviewImage" style="width:130px; height:130px;"
                                     src="${contextPath}/images/detail/reviewImage/${img.detailNo}/${img.memberNo}/${img.reviewImgName}"/>
                            </c:forEach>
                        </c:when>
                    </c:choose>
                </div>
            </div>
            <div id="reviewRange">
                <a name="1"></a>
                <div class="reviewWriteRange">
                    <div class="rating">
                        <input type="radio" id="star5" name="detailScope" value="5" /><label for="star5" title="5 stars">★</label>
                        <input type="radio" id="star4" name="detailScope" value="4" /><label for="star4" title="4 stars">★</label>
                        <input type="radio" id="star3" name="detailScope" value="3" /><label for="star3" title="3 stars">★</label>
                        <input type="radio" id="star2" name="detailScope" value="2" /><label for="star2" title="2 stars">★</label>
                        <input type="radio" id="star1" name="detailScope" value="1" /><label for="star1" title="1 star">★</label>
                    </div>
                    <div id="textArea">
                        <textarea id="myTextarea" maxlength="150"></textarea>
                        <div id="charCount">0/150</div>
                    </div>
                    <div id="fileRange">
                        <p id="fileInfo">이미지파일 첨부</p>
                        <input type="file" id="reviewImageName" name="reviewImageName">
                    </div>
                    <button id="writeButton" onclick="writeSubmit()">글쓰기</button>
                    <div id="writeBorder"></div>
                </div>
            </div>
            <div id="reviewContainer">
                <c:choose>
                    <c:when test="${!empty details and sessionScope.getReview == 1 and !empty review}">
                        <c:set var="reviewCount" value="${fn:length(review)}" />
                        <c:forEach var="rev" items="${review}" varStatus="status" begin="0" end="${reviewCount > 2 ? 1 : reviewCount - 1}">
                            <div class="ReviewRange" data-review-no="${rev.reviewNo}">
                                <c:if test="${member.memberNo == rev.memberNo}">
                                    <button class="deleteButton" onclick="deleteComment(${rev.reviewNo})">삭제</button>
                                </c:if>
                                <div class="personReviewRange">
                                    <img class="reviewPicture" src="${contextPath}/images/detail/detailpage/reviewImage.png">
                                    <p class="anonymous">(익명의 회원)</p>
                                    <div class="stars">
                                        <c:forEach begin="1" end="5" var="i">
                                            <span class="star ${i <= rev.reviewRating ? 'filled' : ''}">${i <= rev.reviewRating ? '★' : '☆'}</span>
                                        </c:forEach>
                                    </div>
                                    <p class="reviewDate">${rev.reviewDate}</p>
                                    <textarea class="reviewComment" readonly>${rev.reviewComment}</textarea>
                                </div>
                            </div>
                        </c:forEach>
                        <c:if test="${reviewCount > 2}">
                            <a href="${contextPath}/detail/reviewViewer.do?detailNo=${details.detailNo}" class="viewAllReviews">후기 ${reviewCount}개 전체보기</a>
                        </c:if>
                    </c:when>
                </c:choose>
            </div>
            <div id="mapRange">
                <h5 id="locationInfo">위치</h5>
                <a name="2"></a>
                <div id="map" style="width:85%;height:350px;"></div>
            </div>
            <script>
                var mapContainer = document.getElementById('map'),
                    mapOption = {
                        center: new kakao.maps.LatLng(${details.detailLatitude}, ${details.detailLongitude}),
                        draggable: false,
                        level: 3
                    };
                var map = new kakao.maps.Map(mapContainer, mapOption);
                var markerPosition  = new kakao.maps.LatLng(${details.detailLatitude}, ${details.detailLongitude});
                var marker = new kakao.maps.Marker({ position: markerPosition });
                marker.setMap(map);
            </script>
            <p id="produ">easyGym은 통신판매의 중개자이며, 통신판매의 당사자가 아닙니다. 따라서<br>
                이지짐은 상품의 구매, 이용 및 환불 등과 관련한 의무와 책임은 각 판매자에게 있습니다.<br>
                단, 회사가 직접 판매하는 통합회원권 상품의 경우, 다짐이 통신판매 당사자의 지위를 갖게 됩니다.
            </p>
            <div id="fixedContainer">
                <form action="${contextPath}/payform/payformForm.do" method="post">
                    <input type="hidden" name="memberNo" value="${member.memberNo}">
                    <input type="hidden" name="detailNo" value="${details.detailNo}">
                    <button type="submit" id="ticketChoice">회원권 선택</button>
                </form>
            </div>
        </div>
    </c:when>
    <c:otherwise>
        <div style="text-align: center; padding: 50px;">
            <h3>해당 정보를 찾을 수 없습니다.</h3>
        </div>
    </c:otherwise>
</c:choose>

</body>
</html>