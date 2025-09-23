<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>
<!-- Footer -->
<footer id="footer">
	<ul class="copyright">
		<li>© EASYGYM</li><li>Design: <a href="/">EASYGYM</a></li><li><a href="/admin/loginForm">ADMIN</a></li>
	</ul>
</footer>

<%-- JSP/CSS/JS 기반 챗봇 코드 시작 --%>

<%-- 1. 챗봇 UI를 위한 스타일(CSS) --%>
<style>
	/* 챗봇 버튼 */
	.chatbot-toggle-button {
		position: fixed; bottom: 24px; right: 24px; width: 64px; height: 64px;
		background-color: #2563eb; /* 기본 파란색 */
		color: white;
		border: none;
		border-radius: 9999px;
		display: flex;
		align-items: center;
		justify-content: center;
		cursor: pointer;
		box-shadow: 0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1);
		z-index: 9999;
		transition: background-color 0.2s ease-in-out, transform 0.2s ease-in-out;
	}
	.chatbot-toggle-button:hover {
		background-color: #1d4ed8; /* 더 어두운 파란색 */
		transform: scale(1.05);
	}
	.chatbot-toggle-button svg { width: 28px; height: 28px; }

	/* 챗봇 컨테이너 */
	.chatbot-container {
		position: fixed; bottom: 24px; right: 24px; width: 384px; height: 600px;
		background-color: white; border-radius: 1rem;
		box-shadow: 0 20px 25px -5px rgb(0 0 0 / 0.1), 0 8px 10px -6px rgb(0 0 0 / 0.1);
		z-index: 9999; display: flex; flex-direction: column; overflow: hidden;
		border: 1px solid #e5e7eb; transform-origin: bottom right;
		transition: opacity 0.2s ease-in-out, transform 0.2s ease-in-out;
	}
	.chatbot-hidden {
		opacity: 0; transform: scale(0.95); pointer-events: none;
	}

	/* 챗봇 헤더 */
	.chatbot-header {
		display: flex; align-items: center; justify-content: space-between;
		padding: 0.75rem; border-bottom: 1px solid #e5e7eb; background-color: white; flex-shrink: 0;
	}
	.chatbot-header .title-group { display: flex; align-items: center; gap: 0.5rem; }
	.chatbot-header .title-group svg { width: 24px; height: 24px; color: #4b5563; }
	.chatbot-header h6 { font-size: 1.125rem; font-weight: 600; color: #374151; margin: 0; }
	.chatbot-header .close-button { background: none; border: none; cursor: pointer; padding: 0.25rem; }
	.chatbot-header .close-button svg { width: 20px; height: 20px; }

	/* 메시지 영역 */
	.chatbot-messages {
		flex-grow: 1; padding: 1rem; overflow-y: auto; background-color: #f0f4f8;
	}
	.message-container { display: flex; flex-direction: column; gap: 0.75rem; }
	.message-bubble {
		max-width: 75%; padding: 0.75rem; border-radius: 1.25rem; font-size: 0.875rem;
		box-shadow: 0 1px 2px 0 rgb(0 0 0 / 0.05); white-space: pre-wrap; word-break: break-word; line-height: 1.5;
	}

	/* ▼▼▼ [수정] 선택자를 더 구체적으로 변경하여 우선순위를 높임 ▼▼▼ */
	.message-container .message-user {
		align-self: flex-end;
		background-color: #fff3cd !important; /* 노란색 계열 배경 (tailwind yellow-200) */
		color: #374151;
		border-bottom-right-radius: 0.375rem;
	}
	/* ▼▼▼ [수정] 선택자를 더 구체적으로 변경하여 우선순위를 높임 ▼▼▼ */
	.message-container .message-bot {
		align-self: flex-start;
		background-color: white !important;
		color: #374151;
		border: 1px solid #e5e7eb;
		border-bottom-left-radius: 0.375rem;
	}

	.typing-indicator { display: flex; gap: 4px; padding-top: 5px; }
	.typing-indicator .dot { width: 6px; height: 6px; border-radius: 50%; background-color: #60a5fa; animation: typing 1s infinite; }
	.typing-indicator .dot:nth-child(2) { animation-delay: 0.2s; }
	.typing-indicator .dot:nth-child(3) { animation-delay: 0.4s; }
	@keyframes typing { 0%, 100% { transform: translateY(0); } 50% { transform: translateY(-4px); } }

	/* 입력 영역 */
	.chatbot-input-area { padding: 0.75rem; border-top: 1px solid #e5e7eb; background-color: white; flex-shrink: 0;}
	.chatbot-input-group { display: flex; align-items: center; gap: 0.5rem; }
	.chatbot-input-group input { width: 100%; padding: 0.5rem 0.75rem; font-size: 0.875rem; border: 1px solid #d1d5db; border-radius: 0.375rem; }
	.chatbot-input-group input:focus { outline: none; border-color: #3b82f6; }
	.chatbot-input-group button { width: 36px; height: 36px; color: white; border-radius: 9999px; border: none; cursor: pointer; display: flex; align-items: center; justify-content: center; transition: background-color 0.2s; }
	.chatbot-input-group button svg { width: 20px; height: 20px; }
	.chatbot-input-group button:disabled { background-color: #93c5fd; cursor: not-allowed; }
	.chatbot-input-group button:not(:disabled) { background-color: #3b82f6; }
	.chatbot-input-group button:not(:disabled):hover { background-color: #2563eb; }
</style>

<%-- 2. 챗봇 UI를 위한 HTML 구조 --%>
<!-- 챗봇 열기 버튼 -->
<button class="chatbot-toggle-button" id="chatbot-open-button">
	<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor">
		<path fill-rule="evenodd" d="M4.848 2.771A49.144 49.144 0 0112 2.25c2.43 0 4.817.178 7.152.52 1.978.292 3.348 2.024 3.348 3.97v6.02c0 1.946-1.37 3.678-3.348 3.97a48.901 48.901 0 01-3.476.383.39.39 0 00-.297.15l-2.755 4.133a.75.75 0 01-1.248 0l-2.755-4.133a.39.39 0 00-.297-.15 48.9 48.9 0 01-3.476-.384c-1.978-.29-3.348-2.024-3.348-3.97V6.741c0-1.946 1.37-3.68 3.348-3.97zM6.75 8.25a.75.75 0 01.75-.75h9a.75.75 0 010 1.5h-9a.75.75 0 01-.75-.75zm.75 2.25a.75.75 0 000 1.5H12a.75.75 0 000-1.5H7.5z" clip-rule="evenodd" />
	</svg>
</button>

<!-- 챗봇 메인 컨테이너 -->
<div class="chatbot-container chatbot-hidden" id="chatbot-container">
	<!-- 헤더 -->
	<div class="chatbot-header">
		<div class="title-group">
			<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor">
				<path fill-rule="evenodd" d="M4.848 2.771A49.144 49.144 0 0112 2.25c2.43 0 4.817.178 7.152.52 1.978.292 3.348 2.024 3.348 3.97v6.02c0 1.946-1.37 3.678-3.348 3.97a48.901 48.901 0 01-3.476.383.39.39 0 00-.297.15l-2.755 4.133a.75.75 0 01-1.248 0l-2.755-4.133a.39.39 0 00-.297-.15 48.9 48.9 0 01-3.476-.384c-1.978-.29-3.348-2.024-3.348-3.97V6.741c0-1.946 1.37-3.68 3.348-3.97z" clip-rule="evenodd" />
			</svg>
			<h6>EasyGym 챗봇</h6>
		</div>
		<button class="close-button" id="chatbot-close-button">
			<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor">
				<path fill-rule="evenodd" d="M5.47 5.47a.75.75 0 011.06 0L12 10.94l5.47-5.47a.75.75 0 111.06 1.06L13.06 12l5.47 5.47a.75.75 0 11-1.06 1.06L12 13.06l-5.47 5.47a.75.75 0 01-1.06-1.06L10.94 12 5.47 6.53a.75.75 0 010-1.06z" clip-rule="evenodd" />
			</svg>
		</button>
	</div>

	<!-- 메시지 표시 영역 -->
	<div class="chatbot-messages" id="chatbot-messages">
		<div class="message-container" id="message-container">
			<!-- 초기 메시지 -->
			<div class="message-bubble message-bot">안녕하세요! 저는 EasyGym 챗봇입니다. 무엇을 도와드릴까요?</div>
		</div>
	</div>

	<!-- 사용자 입력 영역 -->
	<div class="chatbot-input-area">
		<div class="chatbot-input-group">
			<input type="text" id="chatbot-user-input" placeholder="메시지를 입력하세요..." autocomplete="off">
			<button id="chatbot-send-button" disabled>
				<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor">
					<path d="M3.478 2.405a.75.75 0 00-.926.94l2.432 7.905H13.5a.75.75 0 010 1.5H4.984l-2.432 7.905a.75.75 0 00.926.94 60.519 60.519 0 0018.445-8.986.75.75 0 000-1.218A60.517 60.517 0 003.478 2.405z" />
				</svg>
			</button>
		</div>
	</div>
</div>

<%-- 3. 챗봇 UI를 위한 로직(JavaScript) --%>
<script>
	document.addEventListener('DOMContentLoaded', function() {
		const openButton = document.getElementById('chatbot-open-button');
		const closeButton = document.getElementById('chatbot-close-button');
		const chatbotContainer = document.getElementById('chatbot-container');
		const messagesDiv = document.getElementById('chatbot-messages');
		const messageContainer = document.getElementById('message-container');
		const userInput = document.getElementById('chatbot-user-input');
		const sendButton = document.getElementById('chatbot-send-button');

		// 챗봇 열기/닫기
		openButton.addEventListener('click', () => {
			chatbotContainer.classList.remove('chatbot-hidden');
			openButton.classList.add('chatbot-hidden');
		});
		closeButton.addEventListener('click', () => {
			chatbotContainer.classList.add('chatbot-hidden');
			openButton.classList.remove('chatbot-hidden');
		});

		// 입력창에 내용이 있을 때만 전송 버튼 활성화
		userInput.addEventListener('input', () => {
			sendButton.disabled = userInput.value.trim() === '';
		});

		function sendMessage() {
			const userText = userInput.value.trim();
			if (userText === '') return;

			addMessage(userText, 'user');
			userInput.value = '';
			sendButton.disabled = true;

			getBotResponse(userText);
		}

		sendButton.addEventListener('click', sendMessage);
		userInput.addEventListener('keypress', (e) => {
			if (e.key === 'Enter' && !e.shiftKey) {
				e.preventDefault();
				sendMessage();
			}
		});

		// 메시지를 화면에 추가하는 함수 (사용자 메시지는 마크다운 적용 안함)
		function addMessage(text, sender, isStreaming = false) {
			const messageBubble = document.createElement('div');
			messageBubble.className = 'message-bubble message-' + sender;

			if (sender === 'user') {
				// 사용자 메시지는 일반 텍스트로 처리
				messageBubble.textContent = text;
			}

			if (isStreaming) {
				// 봇의 스트리밍 메시지를 위한 초기 설정
				const typingIndicator = document.createElement('div');
				typingIndicator.className = 'typing-indicator';
				typingIndicator.innerHTML = '<span class="dot"></span><span class="dot"></span><span class="dot"></span>';
				messageBubble.appendChild(typingIndicator);
				messageBubble.id = 'streaming-message';
			}

			messageContainer.appendChild(messageBubble);
			messagesDiv.scrollTop = messagesDiv.scrollHeight;
			return messageBubble;
		}

		// 봇 응답을 API로부터 스트리밍으로 받아오는 함수
		function getBotResponse(userText) {
			const streamingBubble = addMessage('', 'bot', true);
			let accumulatedText = '';

			const encodedQuestion = encodeURIComponent(userText);
			const eventSourceUrl = '${pageContext.request.contextPath}/chatbot/stream-chat?question=' + encodedQuestion;
			const eventSource = new EventSource(eventSourceUrl);

			eventSource.onmessage = function(event) {
				// "DONE" 신호는 무시 (실제 종료는 onerror 또는 다른 이벤트로 처리 가능)
				if (event.data === "[DONE]") {
					eventSource.close();
					const typingIndicator = streamingBubble.querySelector('.typing-indicator');
					if (typingIndicator) {
						typingIndicator.remove();
					}
					return;
				}

				accumulatedText += event.data;

				// ▼▼▼ [핵심 변경] 마크다운을 HTML로 변환하고, 보안 처리 후 innerHTML에 삽입 ▼▼▼
				const unsafeHtml = marked.parse(accumulatedText);
				streamingBubble.innerHTML = DOMPurify.sanitize(unsafeHtml); // 보안 처리된 HTML을 삽입

				messagesDiv.scrollTop = messagesDiv.scrollHeight;
			};

			eventSource.onerror = function(error) {
				eventSource.close();
				const typingIndicator = streamingBubble.querySelector('.typing-indicator');
				if (typingIndicator) {
					typingIndicator.remove();
				}

				// 이미 내용이 있으면 에러 메시지를 추가하지 않고, 없으면 에러 메시지 표시
				if (accumulatedText.trim() === '') {
					streamingBubble.innerHTML = "죄송합니다. 서버와 통신 중 오류가 발생했습니다.";
				}
			};
		}
	});
</script>

<%-- JSP/CSS/JS 기반 챗봇 코드 끝 --%>

<!-- 부트스트랩 JS 로드 -->
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<!-- Scripts -->
<script src="/js/member/jquery.min.js"></script>
<script src="/js/member/jquery.dropotron.min.js"></script>
<script src="/js/member/jquery.scrolly.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/marked/marked.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/dompurify/dist/purify.min.js"></script>

<!-- 	<script src="/js/member/jquery.scrollgress.min.js"></script>
-->
<script src="/js/member/jquery.scrollex.min.js"></script>
<script src="/js/member/browser.min.js"></script>
<script src="/js/member/breakpoints.min.js"></script>
<script src="/js/member/util.js"></script>
<script src="/js/member/main.js"></script>
</body>
</html>
