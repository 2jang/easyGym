package com.isix.easyGym.common;

import java.io.File;
import java.io.FileInputStream;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Paths;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Controller("fileDownload")
public class FileDownloadController extends HttpServlet {
	private static final String ARTICLE_IMG_REPO = "fileupload";

	@GetMapping("/download.do")
	public void fileDown(@RequestParam("noticeNo") int noticeNo, @RequestParam("imageFileName") String imageFileName,
						 HttpServletRequest request, HttpServletResponse response) throws Exception {
		request.setCharacterEncoding("utf-8");
		response.setContentType("text/html;charset=utf-8");

		// 상대 경로를 절대 경로로 변환
		String basePath = new File("").getAbsolutePath();
		String fullPath = Paths.get(basePath, ARTICLE_IMG_REPO, String.valueOf(noticeNo)).toString();

		// 디렉토리가 없으면 생성
		File directory = new File(fullPath);
		if (!directory.exists()) {
			Files.createDirectories(directory.toPath());
		}

		String filePath = Paths.get(fullPath, imageFileName).toString();
		File imageFile = new File(filePath);

		// 파일이 존재하지 않으면 에러 응답
		if (!imageFile.exists()) {
			response.sendError(HttpServletResponse.SC_NOT_FOUND, "File not found");
			return;
		}

		// 읽어오는 것 input / 읽어온것을 클라이언트에 전달하는 것 output
		try (OutputStream outs = response.getOutputStream();
			 FileInputStream inputs = new FileInputStream(imageFile)) {

			response.setHeader("Cache-Control", "no-cache");
			// 이미지 파일을 다운받는데 필요한 response헤더 정보 설정
			response.addHeader("Content-disposition", "attachment;fileName=" + imageFileName);

			// 이미지를 한번에 클라이언트에게 보낼 수 없어서 buffer에 저장후 보낸다.
			byte[] buffer = new byte[1024 * 8]; // 버퍼를 이용해서 한번에 8kbyte씩 전송
			int bytesRead;
			while ((bytesRead = inputs.read(buffer)) != -1) {
				outs.write(buffer, 0, bytesRead);
			}
			outs.flush();
		}
	}
}