package com.sp.app.member;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

// 로그인 검사
public class LoginCheckInterceptor implements HandlerInterceptor {
	private final Logger logger = LoggerFactory.getLogger(LoginCheckInterceptor.class);

	/*
	 * 클라이언트 요청이 컨트롤러에 도착하기 전에 호출 false를 리턴하면 HandlerInterceptor 또는 
	 * 컨트롤러를 실행하지 않고 요청 종료
	 */
	@Override
	public boolean preHandle(HttpServletRequest req, HttpServletResponse resp, Object handler) throws Exception {
		boolean result = true;
		
		try {
			HttpSession session = req.getSession();
			SessionInfo info = (SessionInfo)session.getAttribute("member");
			String cp = req.getContextPath();
			String uri = req.getRequestURI();
			String queryString = req.getQueryString();
			
			if(info == null) {
				result = false;
				
				if(isAjaxRequest(req)) {
					resp.sendError(403); // AJAX 요청에서 로그인 처리가 되어 있지 않으면 403 에러 코드 전송
				} else {
					// 로그인 이전 주소를 세션에 저장하고 로그인 화면으로 리다이렉트
					if(uri.indexOf(cp) == 0) {
						uri = uri.substring(req.getContextPath().length());
					}
					
					if(queryString != null) { // 요청 파라미터가 있으면
						uri += "?" + queryString;
					}
					
					// 세션에 이전 주소 저장
					session.setAttribute("preLoginURI", uri);
					
					// 로그인 화면으로 리다이렉트
					resp.sendRedirect(cp+"/member/login");
				}
			} else {
				// 로그인이 되어있으면서 직원, 관리자가 아닌 사람이 관리자 메뉴에 접근하면 접근 불가
				if(uri.indexOf("admin") != -1 && info.getMembership() < 51) {
					result = false;
					resp.sendRedirect(cp + "/member/noAuthorized");
					
				}
			
			}
			
		} catch (Exception e) {
			logger.info("pre : " + e.toString());
		}

		return result;
	}

	/*
	 * 컨트롤러가 요청을 처리 한 후에 호출. 컨트롤러 실행 중 예외가 발생하면 실행 하지 않음
	 */
	@Override
	public void postHandle(HttpServletRequest req, HttpServletResponse resp, Object handler, ModelAndView modelAndView)
			throws Exception {
	}

	/*
	 * 클라이언트 요청을 처리한 뒤, 즉 뷰를 통해 클라이언트에 응답을 전송한 뒤에 실행 컨트롤러 처리 중 또는
	 * 뷰를 생성하는 과정에 예외가 발생해도 실행
	 */
	@Override
	public void afterCompletion(HttpServletRequest req, HttpServletResponse resp, Object handler, Exception ex)
			throws Exception {
	}

	// AJAX 요청인지를 확인하기 위해 작성한 메소드
	private boolean isAjaxRequest(HttpServletRequest req) {
		String header = req.getHeader("AJAX");
		return header != null && header.equals("true");
	}

}
