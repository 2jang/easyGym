package com.isix.easyGym.admin.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.context.annotation.SessionScope;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.isix.easyGym.admin.dao.AdminDAO;
import com.isix.easyGym.admin.dto.AdminDTO;
import com.isix.easyGym.admin.service.AdminServiceImpl;
import com.isix.easyGym.member.dto.MemberDTO;
import com.isix.easyGym.chatbot.service.TurnstileService;
import com.isix.easyGym.chatbot.dto.TurnstileResponse;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Controller("adminController")
public class AdminControllerImpl implements AdminController {
	
	@Autowired
	private AdminServiceImpl adminService;
	
	@Autowired
	private AdminDTO adminDTO;
	
	@Autowired
	private AdminDAO adminDAO;

	@Autowired
	private TurnstileService turnstileService;
	
	// 관리자 가입
	@Override
	@PostMapping("/admin/joinAd")
	public ModelAndView joinAd(AdminDTO adminDTO, HttpServletRequest request, HttpServletResponse response) throws Exception {
		request.setCharacterEncoding("utf-8");
		// Turnstile 검증
		String tokenJoin = request.getParameter("cf-turnstile-response");
		String remoteipJoin = request.getHeader("CF-Connecting-IP");
		if (remoteipJoin == null) remoteipJoin = request.getHeader("X-Forwarded-For");
		if (remoteipJoin == null) remoteipJoin = request.getRemoteAddr();
		TurnstileResponse validationJoin = turnstileService.validateToken(tokenJoin, remoteipJoin);
		if (validationJoin == null || !validationJoin.isSuccess()) {
			ModelAndView fail = new ModelAndView();
			fail.addObject("loginError", "봇 방지 인증에 실패했습니다. 다시 시도해 주세요.");
			fail.setViewName("admin/joinForm");
			return fail;
		}
		adminService.addAdmin(adminDTO);
		ModelAndView mv = new ModelAndView("redirect:/admin/loginForm");
		return mv;
	}

	@Override
	@GetMapping("/admin/joinForm")
	public ModelAndView adminForm(HttpServletRequest request, HttpServletResponse response) throws Exception {
		ModelAndView mav=new ModelAndView();
		mav.setViewName("admin/joinForm");
		return mav;
	} 

	

	
	
	@Override
	@GetMapping("/admin/loginForm") // 회원의 정보를 가지고 간다. 없으면 로그인 폼으로 다시 보낸다.
	public ModelAndView loginForm(@ModelAttribute("admin") AdminDTO admin, @RequestParam(value="action" ,required=false) String action, @RequestParam(value="result", required=false) String result,  HttpServletRequest req, HttpServletResponse res) throws Exception {
		
		HttpSession session = req.getSession(); 
		session.setAttribute("action", action);  
		ModelAndView mv = new ModelAndView();
		mv.addObject("result",result); 
		mv.addObject("admin",admin); 
		mv.setViewName("admin/loginForm");
		return mv;
	}
	
	
	
	// 관리자 로그인
	@Override
	@PostMapping("/admin/login")
	public ModelAndView login(@ModelAttribute("admin") AdminDTO admin, RedirectAttributes rAttr, HttpServletRequest req, HttpServletResponse res) throws Exception {
		// Turnstile 검증
		String token = req.getParameter("cf-turnstile-response");
		String remoteip = req.getHeader("CF-Connecting-IP");
		if (remoteip == null) remoteip = req.getHeader("X-Forwarded-For");
		if (remoteip == null) remoteip = req.getRemoteAddr();
		TurnstileResponse validation = turnstileService.validateToken(token, remoteip);
		if (validation == null || !validation.isSuccess()) {
			ModelAndView mv = new ModelAndView();
			mv.addObject("result", "봇 방지 인증에 실패했습니다.");
			mv.setViewName("redirect:/admin/loginForm");
			return mv;
		}

		adminDTO = adminService.login(admin);
		ModelAndView mv = new ModelAndView();
		if(adminDTO != null) {
			HttpSession session = req.getSession();
			session.setAttribute("admin", adminDTO);
			session.setAttribute("isLogOn", true);
			String action = (String)session.getAttribute("action");
			if(action != null) {
				mv.setViewName("redirect:" + action);
			}else {
				mv.setViewName("redirect:/admin/memberList");
			}
		}else {
			rAttr.addAttribute("result","아이디, 비밀번호가 다릅니다.");
			mv.setViewName("redirect:/admin/loginForm");
		}
		return mv;
	}
	
	// 로그아웃
	@Override
	@GetMapping("/admin/logout")
	public ModelAndView logout(HttpServletRequest req, HttpServletResponse res) throws Exception {
		HttpSession session = req.getSession();
		session.removeAttribute("admin");
		session.removeAttribute("isLogOn");
		ModelAndView mv = new ModelAndView();
		mv.setViewName("redirect:/admin/loginForm");
		return mv;
	}
	
	
	
	
	// 회원 전체 조회 
	@Override
	@RequestMapping(value = "/admin/memberList", method = RequestMethod.GET)
	public ModelAndView memberList(HttpServletRequest request, HttpServletResponse response) throws Exception {
		List mlist=adminService.memberList();
		ModelAndView mav=new ModelAndView();
		mav.setViewName("admin/memberList");
		mav.addObject("mlist",mlist);
		return mav;
	}
	
	// 탈퇴 회원 조회 
	@Override
	@RequestMapping(value = "/admin/withdrawMem", method = RequestMethod.GET)
	public ModelAndView withdrawMember(HttpServletRequest request, HttpServletResponse response) throws Exception {
		List mlist=adminService.withdrawMember();
		ModelAndView mav=new ModelAndView();
		mav.setViewName("admin/withdrawMem");
		mav.addObject("mlist",mlist);
		return mav;
	}
	
	
	// 사업자 전체 조회
	@Override
	@RequestMapping(value = "/admin/operList", method = RequestMethod.GET)
	public ModelAndView operatorList(HttpServletRequest request, HttpServletResponse response) throws Exception {
		List olist=adminService.operList();
		ModelAndView mav=new ModelAndView();
		mav.setViewName("admin/operList");
		mav.addObject("olist",olist);
		return mav;
	}

	// 업체 리스트 조회 
	@Override
	@RequestMapping(value = "/admin/companyList", method = RequestMethod.GET)
	public ModelAndView companyList(HttpServletRequest request, HttpServletResponse response) throws Exception {
		List clist=adminService.comList();
		ModelAndView mav=new ModelAndView();
		mav.setViewName("admin/companyList");
		mav.addObject("clist",clist);
		return mav;
	}

	// 신고 리스트 조회
	@Override
	@RequestMapping(value = "/admin/reportList", method = RequestMethod.GET)
	public ModelAndView reportList(HttpServletRequest request, HttpServletResponse response) throws Exception {
		List rlist = adminService.reportList();
		ModelAndView mv = new ModelAndView();
		mv.setViewName("admin/reportList");
		mv.addObject("rlist",rlist);
		return mv;
	}
	
	
	

	

	
	
	
	
}
