package com.isix.easyGym.member.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import com.isix.easyGym.member.dto.KakaoDTO;
import com.isix.easyGym.member.service.MemberService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Controller("memberLogout")
public class MemberLogoutController {

    @Autowired
    MemberService memberService;

    @RequestMapping(value = {"/member/logout", "/member/operLogout"}, method = RequestMethod.GET)
    public ModelAndView logout(HttpServletRequest request, HttpServletResponse response) throws Exception {
        HttpSession session = request.getSession(false); // 기존 세션이 있을 경우 가져옴 (없으면 null 반환)
        ModelAndView mav = new ModelAndView();
        
        if (session != null) {
            Integer sns = (Integer) session.getAttribute("sns");
            if (sns != null && sns == 1) {
                KakaoDTO kakaoDTO = (KakaoDTO) session.getAttribute("member");
                if (kakaoDTO != null) {
                    memberService.kakaoLogout(kakaoDTO.getKakaoId());
                }
            }

            // 사업자 로그아웃 체크
            if (session.getAttribute("operator") != null) {
                session.removeAttribute("operator"); // 사업자 정보 제거
            } else {
                // 일반 회원 로그아웃 시 처리할 부분
                session.removeAttribute("member"); // 회원 정보 제거
            }

            // 공통: 로그인 상태 제거
            session.removeAttribute("isLogOn");

            // 세션 무효화
            session.invalidate();
        }

        mav.setViewName("redirect:/"); // 로그아웃 후 메인 페이지로 리디렉션
        return mav;
    }
}

