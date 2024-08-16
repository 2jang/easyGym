window.onload = function() {
    let subscriptionMonths = document.getElementById('subscriptionMonths');
    let payformPayment = document.getElementById('payformPayment');
    let originalPrice = document.getElementById('originalPrice');
    let oriPrice = document.getElementById('oriPrice');
    let finalPrice = document.getElementById('finalPrice');
    let onePrice = parseInt(document.getElementById('onePrice').value);
    let priceAmout = document.getElementById('price');
    let discountRate = document.getElementById('discountRate');
    let paymentButton = document.getElementById('paymentButton');
    let usePoint = document.getElementById('usePoint');
    let nowPoint = document.getElementById('nowPoint');
    let remainPointsInput = document.getElementById('remainPoints');
    let totalPoints = parseInt(nowPoint.textContent);
    let paymentForm = document.getElementById('payment_form');

    subscriptionMonths.addEventListener('change', update);
    payformPayment.addEventListener('change', update);
    usePoint.addEventListener('input', handlePointInput);
    paymentForm.addEventListener('submit', handleSubmit);

    function handlePointInput(event) {
        let inputPoint = parseInt(event.target.value) || 0;
        if (inputPoint > totalPoints) {
            alert("사용할 포인트는 현재 포인트보다 많을 수 없습니다");
            event.target.value = event.target.value.slice(0, -1);
            inputPoint = parseInt(event.target.value) || 0;
        }
        let remainingPoints = totalPoints - inputPoint;
        nowPoint.textContent = remainingPoints;
        remainPointsInput.value = remainingPoints;
        update();
    }

    function handleSubmit(event) {
        // form 제출 시 remainingPoints 값을 업데이트
        remainPointsInput.value = nowPoint.textContent;
    }

    function update() {
        let months = parseInt(subscriptionMonths.value);
        let payment = parseInt(payformPayment.value);
        let price = 0;
        let discount = 0;

        switch (months) {
            case 1:
                price = onePrice;
                discount = 0;
                originalPrice.classList.remove('original-price');
                break;
            case 3:
                price = onePrice * 3;
                discount = 10;
                originalPrice.classList.add('original-price');
                break;
            case 6:
                price = onePrice * 6;
                discount = 30;
                originalPrice.classList.add('original-price');
                break;
        }

        switch (payment) {
            case 0:
                paymentButton.textContent = "신용카드로 결제하기"
                break;
            case 1:
                paymentButton.textContent = "계좌이체로 결제하기"
                break;
            case 2:
                paymentButton.textContent = "가상계좌로 결제하기"
                break;
            case 3:
                paymentButton.textContent = "휴대폰으로 결제하기"
                break;
            case 4:
                paymentButton.textContent = "문화상품권으로 결제하기"
                break;
            case 5:
                paymentButton.textContent = "도서문화상품권으로 결제하기"
                break;
            case 6:
                paymentButton.textContent = "게임문화상품권으로 결제하기"
                break;
        }

        let discountedPrice = price * (1 - discount / 100);
        let usedPoint = parseInt(usePoint.value) || 0;
        let finalPriceValue = discountedPrice - usedPoint;

        if (finalPriceValue < 0) {
            alert("사용할 포인트가 결제 금액보다 많습니다. 포인트를 다시 입력해주세요.");
            usePoint.value = discountedPrice; // 최대 사용 가능 포인트로 설정
            usedPoint = discountedPrice;
            finalPriceValue = 0;
            nowPoint.textContent = totalPoints - usedPoint;
            remainPointsInput.value = totalPoints - usedPoint;
        }

        oriPrice.textContent = price.toLocaleString();
        finalPrice.textContent = finalPriceValue.toLocaleString();
        discountRate.textContent = discount + '%';
        priceAmout.value = Math.round(finalPriceValue);
    }

    update();
}