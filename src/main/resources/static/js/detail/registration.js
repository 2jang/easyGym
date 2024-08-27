
document.addEventListener("DOMContentLoaded", function() {
    var form = document.getElementById("detailForm");
        if (!form) {
            console.error("Form not found");
            return;
        }

    form.onsubmit = function(event) {
    event.preventDefault(); // 폼 제출을 즉시 막습니다.

        try {
            var requiredFields = [
            "detailBusinessName", "detailBusinessEng", "detailRoadAddress",
            "detailDailyTicket", "detailMonthlyTicket", "detailMonthlyPrice",
            "detailComment", "detailServiceProgram", "detailFreeService",
            "detailClassification", "detailKoClassification",
            "detailLatitude", "detailLongitude", "operatorNo"
        ];

            var requiredFiles = [
            "image1", "image2", "image3", "image4", "image5",
            "image6", "image7", "image8", "image9", "image10"
        ];

            var isValid = true;
            var missingFields = [];

            // 필수 입력 필드 검증
        requiredFields.forEach(function(fieldId) {
            var field = document.getElementById(fieldId);
                if (!field) {
                console.error("Field not found: " + fieldId);
            return;
            }
            if (!field.value.trim()) {
                isValid = false;
                field.style.border = "2px solid red";
                missingFields.push(field.getAttribute("placeholder") || fieldId);
            } else {
                field.style.border = "1px solid #ccc";
            }
        });

        // 필수 파일 업로드 필드 검증
        requiredFiles.forEach(function(fieldId) {
            var fileField = document.getElementById(fieldId);
            if (!fileField) {
                console.error("File field not found: " + fieldId);
                return;
            }
            if (!fileField.files.length) {
                isValid = false;
                fileField.style.border = "2px solid red";
                missingFields.push(fieldId);
            } else {
                fileField.style.border = "1px solid #ccc";
            }
        });

        // 유효하지 않은 경우 경고 메시지와 함께 폼 제출 중단
        if (!isValid) {
            var message = "모든 정보를 기입해 주세요.";
            console.log("Validation failed. Message: " + message);
            alert(message);
            return false; // 폼 제출 추가로 중단
        } else {
            console.log("Form is valid. Submitting...");
            this.submit();
        }
        } catch (error) {
            console.error("An error occurred: ", error);
            alert("오류가 발생했습니다. 다시 시도해 주세요.");
            return false;
        }
    };
});
