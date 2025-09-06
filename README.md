
# 💪 EasyGym: 스마트 피트니스 정보 플랫폼 🏋️
[![Uptime Robot status](https://img.shields.io/uptimerobot/status/m797642181-b18ff4e3774e59b73ef48c01?up_message=Online&down_message=Offline&style=for-the-badge&logo=uptimerobot&logoColor=white&label=status&labelColor=065f46&color=10b981)](https://easygym.2jang.dev)  
[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.3.1-6DB33F?style=for-the-badge&logo=springboot&logoColor=white)](https://spring.io/projects/spring-boot)
[![Java](https://img.shields.io/badge/Java-17-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white)](https://www.java.com/)
[![MySQL](https://img.shields.io/badge/MySQL-8.0.36-4479A1?style=for-the-badge&logo=mysql&logoColor=white)](https://www.mysql.com/)
[![Gradle](https://img.shields.io/badge/Gradle-8.8-02303A?style=for-the-badge&logo=gradle&logoColor=white)](https://gradle.org/)
[![JSP](https://img.shields.io/badge/JSP-Jakarta%20EE-007396?style=for-the-badge&logo=jameson&logoColor=white)](https://www.oracle.com/java/technologies/jspt.html)

내 손안에서 펼쳐지는 스마트한 운동 생활! **EasyGym**은 사용자가 주변의 다양한 운동 시설(헬스장, 복싱장, 필라테스 등) 정보를 손쉽게 찾고, 예약하며, 운동 관련 정보를 활발히 공유할 수 있도록 도움을 주는 웹 서비스입니다.   
사용자와 시설 업체 간의 연결을 지원하고, 운동을 사랑하는 모두를 위한 커뮤니티를 만들어갑니다!

<p align="center">
  <br>
  <img src="src/main/resources/static/images/readme/easygym-mainpage.png">
  <br>
</p>

## ✨ 주요 기능

### 일반 사용자 기능
* **회원가입 및 로그인**:
    * 일반 회원 가입 (이메일 인증), 로그인, 로그아웃
    * 도로명 주소기반 주소 검색 API 구현
* **시설 정보 조회 및 검색**:
    * 운동 시설(헬스장, 복싱, 필라테스) 리스트 및 상세 정보 조회
    * 지역별, 운동 종류별 시설 검색 및 지도 기반 위치 제공 (Kakao Maps API 연동)
    * 리뷰, 평점 및 신고 시스템
* **결제 시스템**:
    * 토스 결제 API 구현
    * 결제 완료, 취소, 환불 처리
* **커뮤니티 (자유게시판, 공지사항)**:
    * 게시글 작성, 조회 (페이징 처리), 수정, 삭제
    * 게시글 내 댓글 작성, 조회, 삭제 (AJAX)
- 💬 **챗봇**:
    -   OpenRouter를 통해 Google의 Gemma LLM 모델 연동
    -   LLM을 사용한 챗봇 사용자 인터페이스 제공
    -   request 대신 stream 방식을 사용하여 한글자씩 출력하도록 설정, 딜레이 감소 및 시각적 효과

### 사업자 회원 기능
* **시설 등록 및 관리**:
    * 본인의 운동 시설 정보 신규 등록 (상세 정보, 이미지, 가격, 프로그램 등 입력)
    * 등록된 시설 정보 관리

### 관리자 기능
* **회원 관리**: 일반 회원 목록 조회, 탈퇴 회원 조회
* **사업자 및 업체 관리**:
    * 사업자 회원 목록 조회
    * 등록된 운동 시설(업체) 목록 조회 및 관리
* **콘텐츠 관리**:
    * 공지사항 CRUD
    * 사용자 신고 내역 조회 및 관리
    * 사용자 문의사항 목록 조회 및 답변

## 🏗️ 시스템 구조
```
easyGym/
├── src/
│   └── main/
│       ├── java/
│       │   └── com/isix/easyGym/ # (Controller, Service, DAO, DTO)
│       │       ├── admin/        # 관리자 모듈
│       │       ├── contact/      # 문의 기능 관련
│       │       ├── detail/       # 시설 상세 정보 기능 관련
│       │       ├── freeboard/    # 자유게시판 기능 관련
│       │       ├── member/       # 회원 기능 관련
│       │       ├── mypage/       # 마이페이지 기능 관련
│       │       ├── notice/       # 공지사항 기능 관련
│       │       ├── payform/      # 결제 기능 관련
│       │       └── report/       # 신고 기능 관련
│       │
│       ├── resources/            
│       │   ├── mybatis/
│       │   │   └── mappers/      # MyBatis XML 매퍼 파일 (*.xml)
│       │   │
│       │   └── static/           # 정적 컨텐츠 (css, js, images, sass)
│       │
│       └── webapp/
│           └── WEB-INF/
│               └── views/        # JSP 뷰 파일들
│                   └── main.jsp
└── build.gradle
```
* **Controller**: 사용자 요청 처리, 데이터 유효성 검사, Service 계층 호출, View(JSP)에 결과 전달  
* **Service**: 비즈니스 로직 수행, 트랜잭션 관리, DAO 계층 호출  
* **DAO**: MyBatis와 연동하여 데이터베이스 CRUD 작업 수행  
* **DTO**: 계층 간 데이터 전송을 위한 객체  
* **JSP**: 사용자에게 보여지는 UI, JSTL 및 EL을 사용하여 동적 컨텐츠 표시  

## 🔄 API 엔드포인트

-   `GET /main.do`: 메인 페이지
-   `GET /member/loginForm.do`: 일반 회원 로그인 폼
-   `POST /member/login.do`: 일반 회원 로그인 처리
-   `GET /member/operLoginForm.do`: 사업자 회원 로그인 폼
-   `POST /member/operLogin.do`: 사업자 회원 로그인 처리
-   `GET /detail/registration.do`: (사업자) 시설 등록 폼
-   `POST /detail/signUpForm.do`: (사업자) 시설 등록 처리
-   `GET /admin/memberList.do`: (관리자) 회원 목록 조회
-   `GET /detail/search.do`: 시설 검색 결과 페이지
-   `GET /detail/detail.do?detailNo={시설번호}`: 시설 상세 정보 페이지
-   `POST /payform/payformProcess.do`: 결제 처리
-   `GET /freeboard/fboardList.do`: 자유게시판 목록
-   `GET /mypage/mypageMain.do`: 마이페이지
-   `GET /notice/noticeList.do`: 공지사항 목록

## 📱 클라이언트 연동 (JSP 기반)

EasyGym은 **서버 사이드 렌더링**을 위해 JSP를 주로 사용하며, 일부 동적인 기능(찜하기, 댓글 등)에는 JavaScript(jQuery)와 AJAX가 활용됩니다.

-   **데이터 표시**: 컨트롤러에서 `ModelAndView` 객체에 담겨 전달된 데이터는 JSTL을 사용하여 JSP 페이지에 동적으로 렌더링됩니다.  
-   **동적 상호작용 (AJAX)**:
    * 찜하기 기능: jQuery AJAX를 사용하여 엔드포인트와 비동기 통신 후, 결과를 바탕으로 버튼 UI를 업데이트합니다.
    * 게시판 댓글 작성/삭제/조회: 페이지 새로고침 없이 비동기로 데이터를 처리합니다.
    
## 🚀 설치 및 실행 방법

### 준비물

-   Java (JDK) 17
-   Gradle 8.8
-   MySQL 8.0.36
-   [DB 덤프 파일](https://github.com/2jang/easyGym/releases/download/v1.0.19/0826_easygymdb.sql)

### 설치 단계

1.  **저장소 클론하기**

    ~~~bash
    git clone https://github.com/2jang/easyGym.git
    cd easyGym
    ~~~

2.  **데이터베이스 설정**
    1.  MySQL 서버에 접속하여 `easygymdb` 스키마(데이터베이스)를 생성합니다.
        ~~~sql
        CREATE DATABASE easygymdb DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
        ~~~
    2.  [제공된 SQL 덤프 파일](https://github.com/2jang/easyGym/releases/download/v1.0.19/0826_easygymdb.sql)(`0826_easygymdb.sql`)을 사용하여 `easygymdb`에 테이블을 생성하고 초기 데이터를 임포트합니다.
        ~~~bash
        # MySQL CLI 접속 후
        use easygymdb;
        source /path/to/0826_easygymdb.sql;
        # 또는
        # mysql -u (사용자명) -p easygymdb < /path/to/0826_easygymdb.sql
        ~~~

3.  **애플리케이션 설정**

    `src/main/resources/application.properties` 파일을 열어 아래 항목들을 환경에 맞게 수정합니다.

    * **데이터베이스 연결**:
        ~~~properties
        spring.datasource.url=jdbc:mysql://localhost:3306/easygymdb?allowMultiQueries=true
        spring.datasource.username=[DB 사용자명]  # 예: root
        spring.datasource.password=[DB 비밀번호]  # 예: 1234
        ~~~

4.  **프로젝트 빌드** (Gradle Wrapper 사용)

    ~~~bash
    ./gradlew build
    ~~~

### 실행 방법 🏃‍♀️

1.  **Spring Boot 애플리케이션 실행**

    ~~~bash
    ./gradlew bootRun
    ~~~

2.  애플리케이션 접속: [https://localhost:8090](https://localhost:8090) (SSL 기본 설정)

## 🧩 사용된 기술

* **Backend Framework**: Spring Boot 3.3.1, Spring MVC
* **Programming Language**: Java 17
* **View Technology**: JSP, JSTL (Jakarta EE)
* **Database**: MySQL
* **Data Persistence**: MyBatis
* **Build Tool**: Gradle
* **Server**: Tomcat
* **Utility**: Lombok
* **Servlet API**: Jakarta Servlet API
* **APIs & Libraries**:
    * Kakao Maps API
    * Dialogflow API
    * Bootstrap, jQuery, Font Awesome 
## 🌟 특징

-   **종합적인 운동 시설 정보**: 다양한 조건으로 시설을 검색하고 상세 정보 확인 가능
-   **커뮤니티 기능**: 자유게시판을 통한 사용자 간 정보 교류
-   **사업자 시설 등록**: 사업자 회원이 직접 자신의 운동 시설 정보를 플랫폼에 등록
-   **관리자 기능**: 회원, 시설, 콘텐츠 등 서비스 운영에 필요한 제반 관리 기능 제공
-   **외부 API 연동**: 카카오(지도), Dialogflow(챗봇) 등 활용
-   **보안**: HTTPS(SSL) 기본 적용

## 🔧 문제해결 팁

-   **DB 연결 오류**: `application.properties` 정보가 정확한지, MySQL 서버가 정상 동작 중인지 확인합니다. `easygymdb` 스키마가 생성되어 있고 SQL 덤프가 올바르게 임포트되었는지 확인합니다.
-   **Port 충돌**: `server.port=8090`이 다른 애플리케이션에서 사용 중인지 확인하고, 필요시 다른 포트로 변경합니다.
-   **의존성 문제**: `./gradlew clean build`를 통해 프로젝트를 클린 빌드하여 의존성이 올바르게 다운로드되었는지 확인합니다.

## 🤝 기여하기

EasyGym 프로젝트에 기여해주셔서 감사합니다! 버그 리포트, 기능 제안, Pull Request 등 모든 형태의 기여를 환영합니다.

1.  이 저장소를 Fork합니다.
2.  새로운 기능이나 수정을 위한 브랜치를 생성합니다. (`git checkout -b feature/새로운기능`)
3.  변경사항을 커밋합니다. (`git commit -m 'Fix: 버그 수정 / Add: 새로운 기능 추가'`)
4.  Fork한 저장소의 브랜치로 푸시합니다. (`git push origin feature/새로운기능`)
5.  원본 저장소로 Pull Request를 생성합니다.

## 📝 라이센스

이 프로젝트는 MIT 라이센스 하에 배포됩니다. 자세한 내용은 `LICENSE` 파일을 참고하세요.

## 🙏 감사의 말

-   프로젝트에 열심히 임해준 아이식스조 모두 수고했어요!

⭐ 이 프로젝트가 마음에 드셨다면 Star를 눌러주세요! ⭐
