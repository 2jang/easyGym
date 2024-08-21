package com.isix.easyGym.detail.controller;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.commons.io.FileUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.isix.easyGym.detail.dao.DetailDAO;
import com.isix.easyGym.detail.dto.DetailDTO;
import com.isix.easyGym.detail.dto.DetailDibsDTO;
import com.isix.easyGym.detail.dto.DetailImageDTO;
import com.isix.easyGym.detail.dto.DetailReviewDTO;
import com.isix.easyGym.detail.service.DetailServiceImpl;
import com.isix.easyGym.member.dao.MemberDAO;
import com.isix.easyGym.member.dto.MemberDTO;
import com.isix.easyGym.member.dto.MemberOperDTO;
import com.isix.easyGym.member.service.MemberServiceImpl;
import com.isix.easyGym.payform.dto.PayformDTO;
import com.isix.easyGym.payform.service.PayformServiceImpl;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
@Controller("detailController")
public class DetailControllerImpl implements DetailController{
	
	private static String ARTICLE_IMG_REPO= "C:\\isixProject\\easyGym\\src\\main\\resources\\static\\images\\detail";
	
	@Autowired
	private DetailDTO detailDTO;
	
	@Autowired
	private DetailServiceImpl detailService;
	
	@Autowired
	private DetailDAO detailDAO;
	
	@Autowired
	private DetailDibsDTO detailDibsDTO;
	
	@Autowired
	private MemberDTO memberDTO;
	
	@Autowired
	private MemberServiceImpl memberService;
	
	@Autowired
	private MemberDAO memberDAO;
	
	@Autowired
	private PayformDTO payformDTO;
	
	@Autowired
	private PayformServiceImpl payformService;
	
	@Autowired
	private DetailReviewDTO detailReviewDTO;
	
	@Autowired
	private DetailImageDTO detailImageDTO;
	
	@Autowired
	private MemberOperDTO memberOperDTO;
	
	@Override
	@ResponseBody
	@RequestMapping(value = "/detail/selectReport.do", method = RequestMethod.POST)
	public String selectReport(@RequestParam("memberNo") int memberNo,
							   @RequestParam("detailNo") int detailNo,
			HttpServletRequest request, HttpServletResponse response) throws Exception {
	    // 기본적으로 "noBuy"를 반환하도록 설정
	    String success = "noBuy";
	    Map<String,Object> selectMap = new HashMap<String,Object>();
	    selectMap.put("detailNo", detailNo);
	    selectMap.put("memberNo", memberNo);
	    // 구매 여부 체크
	    int payformNo = payformService.findpay(selectMap);
	    if (payformNo != 0) {
	        // 구매가 있는 경우, 신고 여부 체크
	        int report = detailService.findReport(selectMap);
	        if (report != 0) {
	            // 이미 신고가 되어 있는 경우
	            success = "alreadyReport";
	        } else {
	            // 구매는 했으나 신고는 안한 경우
	            success = "memberShip";
	        }
	    }
	    
	    return success;
	}

	@ResponseBody
	@RequestMapping(value = "/report.do", method = RequestMethod.POST)
	public String doReport(@RequestParam("memberNo") int memberNo, @RequestParam("detailNo") int detailNo,
	                       @RequestParam("reportContent") String reportContent, HttpServletRequest request,
	                       HttpServletResponse response) throws Exception {
	    try {
	    	String success=null;
	    	Map<String,Object> countMap = new HashMap<String,Object>();
	    	countMap.put("memberNo", memberNo);
	    	countMap.put("detailNo", detailNo);
	    	int reportCount = detailService.findReportCount(countMap);
            int operatorNo = detailService.findOperatorNo(detailNo);
            Map<String, Object> reportMap = new HashMap<>();
            reportMap.put("reportCount", reportCount);
            reportMap.put("operatorNo", operatorNo);
            reportMap.put("memberNo", memberNo);
            reportMap.put("detailNo", detailNo);
            reportMap.put("reportContent", reportContent);
            detailService.addReport(reportMap);
            success = "success";
	        return success; // 성공적으로 리포트가 추가된 경우 반환할 값

	    } catch (Exception e) {
	        // 예외 발생 시 로깅 및 적절한 에러 메시지 반환
	        e.printStackTrace();
	        return "error"; // 에러 발생 시 반환할 값
	    }
	}
	@RequestMapping(value="/detail/reviewViewer.do" , method=RequestMethod.GET)
	@Override
    public ModelAndView reviewViewer(@RequestParam(value = "section", required = false) String _section,
			 @RequestParam(value = "pageNum", required = false) String _pageNum,
			 @RequestParam(value= "detailNo", required= false) int detailNo,
			 HttpServletRequest request, HttpServletResponse response) throws Exception{
        int section = Integer.parseInt((_section == null) ? "1" : _section);
        int pageNum = Integer.parseInt((_pageNum == null) ? "1" : _pageNum);
        	
        Map<String, Integer> pagingMap = new HashMap<>();
        pagingMap.put("section", section);
        pagingMap.put("pageNum", pageNum);
        Map<String,Integer> reviewAndCount = new HashMap<String,Integer>();
        int count = (section-1)*50+(pageNum-1)*5;
        reviewAndCount.put("count", count);
        reviewAndCount.put("detailNo", detailNo);
		List<DetailReviewDTO> reviewList  = detailDAO.selectAll(reviewAndCount);
        Map<String, Object> reviewMap = detailService.listReview(pagingMap);
        reviewMap.put("detailNo", detailNo);
        reviewMap.put("reviews", reviewList); // map안에 리스트와 토탈 글 숫자, 글 갯수 를 넣는다.
        reviewMap.put("section", section);
        reviewMap.put("pageNum", pageNum);
        ModelAndView mav = new ModelAndView();
        mav.addObject("reviewMap", reviewMap);
        mav.setViewName("/detail/review");
        return mav;
    }
	
	
	@GetMapping("/detail/registration.do")  //127.0.0.1:8090 => 이렇게만 매핑 보내기
	public ModelAndView registration(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView mav=new ModelAndView();
		mav.setViewName("/detail/registration");
		return mav;
	}
	
	@Override
    @GetMapping("/detail/search.do")
    public ModelAndView searchData(@RequestParam("query") String query,
            @RequestParam(value = "detailClassification",required = false) String detailClassification,
            HttpServletRequest request, HttpServletResponse response) throws Exception{
        ModelAndView mav=new ModelAndView();
        List<DetailDTO> selectedThing = new ArrayList<>();
        Map<String, String> searchMap= new HashMap<String, String>();

        if(detailClassification != null && !detailClassification.isEmpty()){
            searchMap.put("query", query);
            searchMap.put("detailClassification", detailClassification);
            selectedThing = detailService.findThing(searchMap);
            mav.addObject("allList", selectedThing);
            mav.setViewName("/detail/List");
            return mav;
        }
        else{
            searchMap.put("query", query);
            selectedThing = detailService.findPLace(searchMap);
            mav.addObject("allList", selectedThing);
            mav.setViewName("/detail/List");
            return mav;
        }
    }
	
	@RequestMapping(value = "/detail/signUpForm.do", method = RequestMethod.POST)
	public ModelAndView signUpForm(
	        @RequestParam("detailBusinessEng") String detailBusinessEng,
	        @RequestParam("operatorNo") int operatorNo,
	        @RequestParam("detailClassification") String detailClassification,
	        MultipartHttpServletRequest multipartRequest, HttpServletResponse response) throws Exception {

	    String imageFileName = null;
	    multipartRequest.setCharacterEncoding("utf-8");
	    Map<String, Object> detailMap = new HashMap<>();
	    Enumeration<String> enu = multipartRequest.getParameterNames();

	    while (enu.hasMoreElements()) {
	        String name = enu.nextElement();
	        String value = multipartRequest.getParameter(name);
	        detailMap.put(name, value);
	    }

	    List<String> fileList = multiFileUpload(multipartRequest);
	    List<DetailImageDTO> imageFileList = new ArrayList<>();

	    if (fileList != null && !fileList.isEmpty()) {
	        for (String fileName : fileList) {
	            DetailImageDTO detailImageDTO = new DetailImageDTO();
	            detailImageDTO.setImageFileName(fileName);
	            imageFileList.add(detailImageDTO);
	        }
	        detailMap.put("imageFileList", imageFileList);
	    }

	    HttpSession session = multipartRequest.getSession();
	    detailMap.put("operatorNo", operatorNo);

	    try {
	        detailService.addOperForm(detailMap);
	        if (imageFileList != null && !imageFileList.isEmpty()) {
	            for (DetailImageDTO detailImageDTO : imageFileList) {
	                imageFileName = detailImageDTO.getImageFileName();
	                File srcFile = new File(ARTICLE_IMG_REPO + File.separator + detailClassification + File.separator + "temp" + File.separator + imageFileName);
	                File destDir = new File(ARTICLE_IMG_REPO + File.separator + detailClassification + File.separator + detailBusinessEng);

	                if (!destDir.exists()) {
	                    destDir.mkdirs(); // Ensure destination directory exists
	                }
	                
	                File destFile = new File(destDir, imageFileName);
	                FileUtils.moveFile(srcFile, destFile); // Move the file
	            }
	        }
	    } catch (Exception e) {
	        if (imageFileList != null && !imageFileList.isEmpty()) {
	            for (DetailImageDTO detailImageDTO : imageFileList) {
	                imageFileName = detailImageDTO.getImageFileName();
	                File srcFile = new File(ARTICLE_IMG_REPO + File.separator + detailClassification + File.separator + "temp" + File.separator + imageFileName);
	                if (srcFile.exists()) {
	                    srcFile.delete(); // Delete the file if it exists
	                }
	            }
	        }
	        e.printStackTrace(); // Consider proper logging
	    }

	    ModelAndView mav = new ModelAndView();
	    mav.setViewName("/main");
	    return mav;
	}
	
		
	@Override
	@RequestMapping(value="/detail/detail.do", method = RequestMethod.GET)
	public ModelAndView detailForm(
		@RequestParam("detailNo") int detailNo,
		@RequestParam(value = "memberNo", required = false) String memberNo,
		HttpServletRequest request,
		HttpServletResponse response) throws Exception{
		HttpSession session= request.getSession();
		detailDTO=detailService.viewDetail(detailNo);
		ModelAndView mav=new ModelAndView();
		List<DetailReviewDTO> review = new ArrayList<>();
		review = detailService.findReview(detailNo); 
		List<DetailReviewDTO> reviewImage = new ArrayList<>();
		reviewImage = detailService.getReviewImages(detailNo);
		
		if(review != null ) {
			session.setAttribute("getReview", 1);
			mav.addObject("reviewImage",reviewImage);
			mav.addObject("review", review);
		}else {
			session.setAttribute("getReview", 0);
		}
		mav.addObject("details", detailDTO);
		mav.setViewName("/detail/detail");
		return mav;
	}
	@Override
	@ResponseBody
	@RequestMapping(value = "/getReviews.do", method = {RequestMethod.POST, RequestMethod.GET})
	public List<DetailReviewDTO> getReviews(@RequestParam("detailNo") int detailNo, HttpServletRequest request,
        HttpServletResponse response) throws Exception {
	    List<DetailReviewDTO> reviews = detailService.getReviews(detailNo);
	    System.out.print(reviews.get(0).getReviewImgName());
	    return reviews;
	}
   
	
		@Override
	 	@RequestMapping(value="/addFavorite", method=RequestMethod.GET)
	    @ResponseBody
	    public String dibs(@RequestParam("detailNo") String detailNo,
            @RequestParam("memberNo") int memberNo,
            @RequestParam(value = "action", required = false) String action,
            HttpServletRequest request,
            HttpServletResponse response) throws Exception {
	        String status;
	        HttpSession session = request.getSession();
            Map<String, Object> paramMap = new HashMap<>();
            paramMap.put("detailNo", detailNo);
            paramMap.put("memberNo", memberNo);

            DetailDibsDTO detailDibsDTO = detailService.findDibs(paramMap);

            if (detailDibsDTO == null) {
                detailDAO.insertDibs(paramMap);
                status = "insert";
            } else {
                detailDAO.removeDibs(paramMap);
                status = "delete";
            }
            return status;
		}
	

	@RequestMapping(value="/getFavoriteStatus", method=RequestMethod.GET)
	@ResponseBody
	public String getFavoriteStatus(@RequestParam("detailNo") String detailNo,
			@RequestParam("memberNo") String memberNo,HttpServletRequest request,
			HttpServletResponse response) throws Exception{
	    Map<String, Object> paramMap = new HashMap<>();
	    paramMap.put("detailNo", detailNo);
	    paramMap.put("memberNo", memberNo);

	    DetailDibsDTO detailDibsDTO = detailService.findDibs(paramMap);
	    if (detailDibsDTO != null) {
	        return "insert"; // 찜 되어 있는 상태
	    } else {
	        return "delete"; // 찜 되어 있지 않은 상태
	    }
	}
	
	
	
	
	@Override
	@ResponseBody
	@RequestMapping(value="/writeReview.do", method = RequestMethod.POST)
	public String writeReview(
	        @RequestParam("detailNo") String detailNo, 
	        @RequestParam(value="memberNo", required = false) int memberNo,
	        @RequestParam(value = "action", required = false) String action,
	        @RequestParam(value = "reviewComment", required = false) String reviewComment,
	        @RequestParam(value = "reviewRating", required = false) String reviewRating,
	        @RequestParam(value = "reviewImageName", required = false) MultipartFile reviewImageName,
	        MultipartHttpServletRequest multipartRequest,
	        HttpServletResponse response) throws Exception {
		String status = null;
	    try {
			Map<String,Object> selectMap = new HashMap<String,Object>();
			selectMap.put("detailNo", detailNo);
			selectMap.put("memberNo", memberNo);
			// 구매 여부 체크
			int purchaseCount = payformService.getPurchaseCount(selectMap); // 구매 횟수 조회
			int reviewCount = detailService.getReviewCount(selectMap);

			if (reviewCount >= purchaseCount) {
				status = "reviewLimitExceeded"; // 리뷰 작성 제한 초과
				return status;
			}

			int payformNo = payformService.findpay(selectMap);
		 	    if (payformNo != 0) {
	                multipartRequest.setCharacterEncoding("utf-8");
	                // Verify file upload
	                String imageFileName = fileUpload(multipartRequest);
	                HttpSession session = multipartRequest.getSession();

	                if (imageFileName != null && !imageFileName.isEmpty()) {
	                    // Handle image upload
	                    Map<String, Object> reviewImageMap = new HashMap<>();
	                    Enumeration<String> enu = multipartRequest.getParameterNames();

	                    while (enu.hasMoreElements()) {
	                        String name = enu.nextElement();
	                        String value = multipartRequest.getParameter(name);
	                        reviewImageMap.put(name, value);
	                    }

	                    reviewImageMap.put("reviewImageName", imageFileName);
	                    reviewImageMap.put("payformNo", payformNo);
	                    reviewImageMap.put("detailNo", detailNo);
	                    reviewImageMap.put("memberNo", memberNo);

	                    // Check if there's already an existing review image
	                    File existingImageFile = new File(ARTICLE_IMG_REPO + File.separator + "reviewImage" + File.separator + detailNo + File.separator + memberNo + File.separator + imageFileName);
	                    if (existingImageFile.exists()) {
	                        existingImageFile.delete(); // Delete the old image
	                    }

	                    // Save new review
	                    int reviewNo = detailService.addreview(reviewImageMap);

	                    File srcFile = new File(ARTICLE_IMG_REPO + File.separator + "reviewImage" + File.separator + "temp" + File.separator + imageFileName);
	                    File destDir = new File(ARTICLE_IMG_REPO + File.separator + "reviewImage" + File.separator + detailNo + File.separator + memberNo);
	                    if (!destDir.exists()) {
	                        destDir.mkdirs(); // Ensure destinqation directory exists
	                    }

	                    File destFile = new File(destDir, imageFileName);
	                    if (srcFile.exists()) {
	                        FileUtils.moveFile(srcFile, destFile); // Move the file
	                    } else {
	                        throw new FileNotFoundException("Source file not found: " + srcFile.getAbsolutePath());
	                    }

	                    status = "success";
	                } else {
	                    // Handle no image case
	                    Map<String, String> noImgReviewMap = new HashMap<>();
	                    noImgReviewMap.put("reviewComment", reviewComment);
	                    noImgReviewMap.put("reviewRating", reviewRating);
	                    noImgReviewMap.put("memberNo", String.valueOf(memberNo));
	                    noImgReviewMap.put("payformNo", String.valueOf(payformNo));
	                    noImgReviewMap.put("detailNo", detailNo);

	                    detailService.noImgReview(noImgReviewMap);
	                    status = "success";
	                }
	            } else {
	                status = "noBuy";
	            }
	    } catch (Exception e) {
	        e.printStackTrace(); // Use logging framework in production
	        status = "error";
	        System.out.print("글쓰기 중 오류 발생!!");
	    }

	    return status;
	}
	
	
	@ResponseBody
	@Override
	@RequestMapping(value="/getReviewImages.do", method = RequestMethod.GET)
	public List<DetailReviewDTO> getReviewImages(@RequestParam("detailNo") int detailNo, HttpServletRequest request, HttpServletResponse response)
	        throws Exception {
	    List<DetailReviewDTO> reviewImages = detailService.getReviewImages(detailNo);

	    if (reviewImages == null || reviewImages.isEmpty()) {
	        // 빈 리스트를 반환하거나 적절한 처리를 합니다.
	        return new ArrayList<>();
	    }

	    return reviewImages;
	}

	
	@Override
	@ResponseBody
	@RequestMapping(value = "/delete.do", method = RequestMethod.POST)
	public String deleteReview(@RequestParam("detailNo") int detailNo,
	                           @RequestParam("reviewNo") int reviewNo,
	                           @RequestParam("memberNo") int memberNo,
	              
	                           @RequestParam(value = "action", required = false) String action,
	                           RedirectAttributes rAttr,
	                           HttpServletRequest request,
	                           HttpServletResponse response) throws Exception {
	    String success;
	    
	    try {
	        // 구매 확인
	    	Map<String,Object> selectMap = new HashMap<String,Object>();
	 	    selectMap.put("detailNo", detailNo);
	 	    selectMap.put("memberNo", memberNo);
	 	    // 구매 여부 체크
	 	    int payformNo = payformService.findpay(selectMap);
	 	    if (payformNo != 0) {
	            // 리뷰 정보 조회
	            DetailReviewDTO reviewDTO = detailService.getReviewByNo(reviewNo);
	            /*if (reviewDTO == null) {
	                return "reviewNotFound";
	            }지울 지 생각 하기*/
	 	    	//differentMember
	 	    	selectMap.put("payformNo", payformNo);
	 	    	int selectMember = detailService.findReviewMember(selectMap);
	 	    	if(selectMember != 0) {
	 	    	// 이미지 파일 삭제
		            String imageFileName = reviewDTO.getReviewImgName(); // 단일 이미지 파일 이름 가져오기
		            if (imageFileName != null && !imageFileName.isEmpty()) {
		                String filePath = ARTICLE_IMG_REPO + File.separator + "reviewImage"
		                                    + File.separator + detailNo
		                                    + File.separator + memberNo
		                                    + File.separator + imageFileName;
		                File file = new File(filePath);
		                if (file.exists() && file.delete()) {
		                    // 빈 폴더 삭제
		                    File memberDir = new File(ARTICLE_IMG_REPO + File.separator + "reviewImage"
		                                                + File.separator + detailNo
		                                                + File.separator + memberNo);
		                    deleteEmptyDirectories(memberDir);
		                }
		            }

		            // 리뷰 삭제
		            detailService.removeReview(reviewNo);
		            success = "success";
	 	    	}else {
	 	    		success="differentMember";
	 	    	}
	            
	        } else {
	            success = "noBuy";
	        }
	    } catch (Exception e) {
	        e.printStackTrace(); // 예외 로그 출력
	        success = "error"; // 오류 발생 시 반환 값
	    }

	    return success;
	}

	// 빈 폴더 삭제
	private void deleteEmptyDirectories(File dir) {
	    if (dir.isDirectory()) {
	        File[] files = dir.listFiles();
	        if (files != null && files.length == 0) {
	            dir.delete();
	            // 상위 폴더도 비어있으면 삭제
	            File parentDir = dir.getParentFile();
	            if (parentDir != null && !parentDir.getName().equals("reviewImage") && parentDir.isDirectory()) {
	                deleteEmptyDirectories(parentDir);
	            }
	        }
	    }
	}
	
	
	//한 개 이미지 파일 업로드(fileUpload)
	private String fileUpload(MultipartHttpServletRequest multipartRequest) throws Exception {
		String imageFileName=null;
		Iterator<String> fileNames=multipartRequest.getFileNames();
		while(fileNames.hasNext()) {  //fileNames가 존재하면 while문이 hasNext 다음으로 계속 돔
			String detailBusinessEng = multipartRequest.getParameter("detailBusinessEng");
			String fileName=fileNames.next();
			MultipartFile mFile=multipartRequest.getFile(fileName);
			imageFileName=mFile.getOriginalFilename();
			File file=new File(ARTICLE_IMG_REPO + "\\" + fileName);  //이미지 파일 저장하는 내 경로 (상단에 경로 있음)
			if(mFile.getSize() != 0) {  //이미지 파일 사이즈가 0이 아닐 때 => 이미지가 첨부되어 있는 상태
				if(! file.exists()) {  //파일이 존재하지 않는다면~
					if(file.getParentFile().mkdir()) {  //mkdir = 폴더 생성
						file.createNewFile();
					}
				}
				mFile.transferTo(new File(ARTICLE_IMG_REPO + File.separator + "reviewImage" + File.separator + "temp" + File.separator + imageFileName));  //transferTo => 파일 전송 / new File => 익명으로 파일 객체 생성 / temp에 임시 저장
			}
		}
		return imageFileName;
	}
	private List<String> multiFileUpload(MultipartHttpServletRequest multipartRequest) throws Exception {
	    List<String> fileList = new ArrayList<>();
	    Iterator<String> fileNames = multipartRequest.getFileNames();

	    while (fileNames.hasNext()) {
	        String fileName = fileNames.next();
	        MultipartFile mFile = multipartRequest.getFile(fileName);
	        String detailClassification = multipartRequest.getParameter("detailClassification");
	        String originalFileName = mFile.getOriginalFilename();
	        
	        if (originalFileName != null && mFile.getSize() != 0) {
	            fileList.add(originalFileName);
	            File file = new File(ARTICLE_IMG_REPO + File.separator + detailClassification + File.separator + "temp" + File.separator + originalFileName);
	            if (!file.getParentFile().exists()) {
	                file.getParentFile().mkdirs(); // Ensure directory exists
	            }
	            mFile.transferTo(file); // Transfer file
	        }
	    }
	    return fileList;
	}


}
