function goToDetail(detailNo) {
    let detailForm = document.createElement('form');
    let inputData = document.createElement('input');
    inputData.setAttribute('type', 'hidden');
    inputData.setAttribute('name', 'detailNo');
    inputData.setAttribute('value', detailNo);
    detailForm.appendChild(inputData);
    document.body.appendChild(detailForm);
    detailForm.setAttribute('action', '/detail/detail.do');
    detailForm.setAttribute('method', 'get');
    detailForm.submit();
}
document.addEventListener('DOMContentLoaded', function() {
    const mapWrap = document.querySelector('.map_wrap');
    const initialHeight = mapWrap.offsetHeight; // 초기 높이 저장
    const initialTop = mapWrap.offsetTop; // 초기 top 위치 저장
    const triggerHeight = 270; // 트리거 높이 설정

    function adjustMapWrap() {
        const scrollTop = window.scrollY || document.documentElement.scrollTop;

        if (scrollTop > triggerHeight) {
            mapWrap.style.position = 'fixed';
            mapWrap.style.top = '0';
            mapWrap.style.bottom = '0'; // 화면 하단까지 채우기
            mapWrap.style.width = '30%';
            mapWrap.style.right = '10%';
            mapWrap.style.height = '100vh'; // 화면 전체 높이
        } else {
            mapWrap.style.position = 'absolute';
            mapWrap.style.top = `${initialTop}px`;
            mapWrap.style.width = '30%';
            mapWrap.style.right = '10%';
            mapWrap.style.height = `${initialHeight}px`; // 초기 높이로 설정
        }
    }

    window.addEventListener('scroll', adjustMapWrap);
    adjustMapWrap(); // 페이지 로드 시 초기 상태 설정
});