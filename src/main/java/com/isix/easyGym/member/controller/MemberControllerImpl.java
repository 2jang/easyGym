package com.isix.easyGym.member.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.isix.easyGym.member.dto.KakaoDTO;
import com.isix.easyGym.member.dto.MemberDTO;
import com.isix.easyGym.member.service.MemberService;
import com.isix.easyGym.chatbot.service.TurnstileService;
import com.isix.easyGym.chatbot.dto.TurnstileResponse;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Controller("memberController")
public class MemberControllerImpl implements MemberController {

	@Autowired
	private MemberService memberService;

	@Autowired
	private TurnstileService turnstileService;

	@Autowired
	private MemberDTO memberDTO;
	
	@Autowired
	private KakaoDTO kakaoDTO;
	
	@Override
	@GetMapping("/member/joinSelect.do")
	public ModelAndView joinSelect(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView();
		mav.setViewName("member/joinSelect");
		return mav;
	}
	
	// 회원가입 페이지
	@RequestMapping(value = "/member/memJoin.do")
    public ModelAndView showJoinForm() {
        ModelAndView mav = new ModelAndView();
        mav.setViewName("member/memJoin"); 
        return mav;
    }
	
	// 회원가입 기능
	@PostMapping(value = "/member/addMember.do")
	public ModelAndView addMember(@ModelAttribute("memberDTO") MemberDTO memberDTO, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView();
		memberService.addMember(memberDTO);
		mav.setViewName("redirect:/member/afterMemJoin.do");
		return mav;
	}
	
	@Override 
	@GetMapping("/member/gymRegister.do")
	public ModelAndView gymRegister(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView();
		mav.setViewName("member/gymRegister");
		return mav;
	}	
	
	@RequestMapping(value = "/member/afterMemJoin.do")
    public ModelAndView afterMemJoin() {
        ModelAndView mav = new ModelAndView();
        mav.setViewName("member/afterMemJoin"); 
        return mav;
    }
	
	@Override
	@RequestMapping(value = "/member/joinCheck.do")	// 이용 약관 동의
	public ModelAndView joinCheck(@ModelAttribute("memberDTO") MemberDTO memberDTO, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView();
		mav.setViewName("member/joinCheck");
		return mav;
	}

	@Override 
	@GetMapping("/member/loginSelect.do")
	public ModelAndView loginSelect(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView mav = new ModelAndView();
		mav.setViewName("member/loginSelect");
		return mav;
	}	
	@Override
	@GetMapping("/member/modMemberForm.do")
	public ModelAndView modMemberForm(@RequestParam("id") String id, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		memberDTO = memberService.findMember(id); // 회원정보 id를 찾아서 memberDTO에 넘겨줌
		ModelAndView mav = new ModelAndView("/member/modMemberForm");
		mav.addObject("member", memberDTO); // memberDTO=memberService.findMember(id);의 memberDTO에 담긴 id를 member에 담음
		return mav;
	}

	@Override
	@PostMapping("/member/updateMember.do")
	public ModelAndView updateMember(@ModelAttribute("memberDTO") MemberDTO memberDTO, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		request.setCharacterEncoding("utf-8");
		memberService.updateMember(memberDTO); // 업데이트 하기
		ModelAndView mav = new ModelAndView("redirect:/member/listMembers.do"); // 회원정보수정하면 listMembers 메서드를 찾아가서 다시
																				// 회원목록을 보여주게 됨
		return mav;
	}

	@Override
	@GetMapping("/member/delMember.do")
	public ModelAndView delMember(String id, HttpServletRequest request, HttpServletResponse response)throws Exception {
		memberService.delMember(id);
		ModelAndView mav = new ModelAndView("redirect:/member/listMembers.do"); // 회원삭제하면 listMembers 메서드를 찾아가서 다시 회원목록을
																				// 보여주게 됨
		return mav;
	}

	@GetMapping("/member/loginForm.do")
	public ModelAndView loginForm(@ModelAttribute("member") MemberDTO member,
	                               @RequestParam(value = "action", required = false) String action,
	                               @RequestParam(value = "result", required = false) Integer result,
	                               HttpServletRequest req,
	                               HttpServletResponse res) throws Exception {
	    ModelAndView mv = new ModelAndView();
	    HttpSession session = req.getSession();
	    session.setAttribute("action", action);

	    // result 값에 따라 처리
	    if (result != null) {
	        switch (result) {
	            case 0:
	                mv.addObject("loginError", "아이디 또는 비밀번호가 잘못되었습니다. 다시 시도해 주세요.");
	                break;
	            case 2:
	                mv.addObject("loginError", "탈퇴한 회원입니다. 다시 가입해 주세요.");
	                break;
	        }
	    }

	    mv.setViewName("member/loginForm");
	    return mv;
	}


	
	@Override
	@RequestMapping(value = "/member/login.do", method = RequestMethod.POST)
	public ModelAndView login(@ModelAttribute("memberDTO") MemberDTO memberDTOParam,
	                           @RequestParam(value ="action", required=false) String action,
	                           RedirectAttributes rAttr,
	                           HttpServletRequest request,
	                           HttpServletResponse response) throws Exception {
	    ModelAndView mv = new ModelAndView();

	    // Turnstile 서버 검증
	    String token = request.getParameter("cf-turnstile-response");
	    String remoteip = request.getHeader("CF-Connecting-IP");
	    if (remoteip == null) {
	        remoteip = request.getHeader("X-Forwarded-For");
	    }
	    if (remoteip == null) {
	        remoteip = request.getRemoteAddr();
	    }

	    TurnstileResponse validation = turnstileService.validateToken(token, remoteip);
	    if (validation == null || !validation.isSuccess()) {
	        mv.addObject("loginError", "봇 방지 인증에 실패했습니다. 다시 시도해 주세요.");
	        mv.setViewName("member/loginForm");
	        return mv;
	    }

	    MemberDTO memberDTO = memberService.login(memberDTOParam);

	    if (memberDTO != null) {
	        if (memberDTO.getMemberState() == 0) {
	            mv.setViewName("redirect:/member/loginForm.do?result=2");
	        } else {
	            HttpSession session = request.getSession();
	            session.setMaxInactiveInterval(30 * 60);
	            session.setAttribute("member", memberDTO);
	            session.setAttribute("isLogOn", true);
	            session.setAttribute("sns", 0);
	            action = (String) session.getAttribute("action");
	            if (action != null) {
	                mv.setViewName("redirect:" + action);
	            } else {
	                mv.setViewName("redirect:/main.do");
	            }
	        }
	    } else {
	        mv.addObject("loginError", "아이디 또는 비밀번호가 잘못되었습니다. 다시 시도해 주세요.");
	        mv.setViewName("member/loginForm");
	    }

	    return mv;
	}



	// 아이디 중복체크
	@PostMapping("/member/checkId.do")
	@ResponseBody
	public ResponseEntity<Boolean> confirmId(@RequestParam("memberId")String memberId) {
		
		boolean result = true;
		
		if(memberId.trim().isEmpty()) {
			System.out.print("id : " + memberId);
			result = false;
		} else {
			if (memberService.selectId(memberId)) {
				result = false;
			} else {
				result = true;
			}
		}
		
		return new ResponseEntity<>(result, HttpStatus.OK);
	}

	@Override
	public ModelAndView loginForm(MemberDTO member, String action, String result, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	@RequestMapping(value = "/kakao-login", method = RequestMethod.GET)
	@Override
	public ModelAndView oauth(
	        @RequestParam(value = "code", required = false) String code,
	        @RequestParam(value = "error", required = false) String error,
	        @RequestParam(value = "error_description", required = false) String error_description,
	        @RequestParam(value = "state", required = false) String state,
	        HttpServletRequest request, HttpServletResponse response) throws Exception {

	    HttpSession session = request.getSession();
	    
	    try {
	        String access_token = memberService.getKakaoAccessToken(code);
	        KakaoDTO kakaoDTO = memberService.getKakaoUserInfo(access_token);
	        
	        memberService.kakaoLogin(kakaoDTO);

	        session.setAttribute("member", kakaoDTO);
	        session.setAttribute("isLogOn", true);
	        session.setAttribute("sns", 1);

	    } catch (Exception e) {
	        e.printStackTrace();
	        // 예외 발생 시 오류 페이지로 리다이렉트
	        ModelAndView mav = new ModelAndView();
	        mav.setViewName("redirect:/errorPage.do");
	        return mav;
	    }

	    ModelAndView mav = new ModelAndView();
	    mav.setViewName("redirect:/main.do");
	    return mav;
	}


}