package com.sp.app.bbs;

import java.io.File;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sp.app.common.FileManager;
import com.sp.app.common.MyUtil;
import com.sp.app.member.SessionInfo;


@Controller("bbs.boardController")
@RequestMapping("/bbs/*")
public class BoardController {
	@Autowired
	BoardService service;
	
	@Autowired
	private MyUtil myUtil;
	
	@Autowired
	private FileManager fileManager;
	
	private static final Logger logger = LoggerFactory.getLogger(BoardController.class);
	
	@RequestMapping(value = "write", method = RequestMethod.GET)
	public String writeForm(Model model) throws Exception {
		
		model.addAttribute("mode", "write");
		return ".bbs.write";
	}
	
	@RequestMapping(value = "write", method = RequestMethod.POST)
	public String writeSubmit(Board dto, HttpSession session) throws Exception {
		SessionInfo info = (SessionInfo)session.getAttribute("member");
		
		// 파일을 저장할 경로
		String root = session.getServletContext().getRealPath("/");
		String pathname = root + "uploads" + File.separator + "bbs";
		/*
		 *  C:\work\.metadata\.plugins\org.eclipse.wst.server.core\tmp0\wtpwebapps\sp4\
		 *  uploads\bbs
		 */
		
		try {
			dto.setUserId(info.getUserId()); // 게시글을 올린 사람(로그인한 유저)
			
			service.insertBoard(dto, pathname);
			
		} catch (Exception e) {
		}
		return "redirect:/";
	}
	
	@RequestMapping(value = "article", method = RequestMethod.GET)
	public String article(
			@RequestParam int num,
			@RequestParam String page,
			@RequestParam(defaultValue = "all") String condition,
			@RequestParam(defaultValue = "") String keyword,
			HttpSession session,
			Model model) throws Exception {
		
		keyword = URLDecoder.decode(keyword, "utf-8");
		
		String query = "page=" + page;
		if(keyword.length() != 0) {
			query += "&condition=" + condition 
					+ "&keyword=" + URLEncoder.encode(keyword, "utf-8");
		}
		
		service.updateHitCount(num);
		
		// 해당 데이터 가져오기
		Board dto = service.readBoard(num);
		if(dto == null) {
			return "redirect:/?" + query;
		}
		
		dto.setContent(dto.getContent().replaceAll("\n", "<br>"));
		
		// 이전, 다음글
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("condition", condition);
		map.put("keyword", keyword);
		map.put("num", num);
		
		Board preReadDto = service.preReadBoard(map);
		Board nextReadDto = service.nextReadBoard(map);
		
		// 로그인 유저의 해당 게시글 좋아요 여부
		SessionInfo info = (SessionInfo)session.getAttribute("member");
		map.put("userId", info.getUserId());
		
		boolean userBoardLiked = service.userBoardLiked(map);
		
		model.addAttribute("dto", dto);
		model.addAttribute("preReadDto", preReadDto);
		model.addAttribute("nextReadDto", nextReadDto);
		model.addAttribute("page", page);
		model.addAttribute("query", query);
		
		model.addAttribute("userBoardLiked", userBoardLiked);
		
		return ".bbs.article";
	}
	
	@RequestMapping(value = "update", method = RequestMethod.GET)
	public String updateForm(
			@RequestParam String page,
			@RequestParam int num,
			HttpSession session,
			Model model) throws Exception {
		
		SessionInfo info = (SessionInfo)session.getAttribute("member");
		
		Board dto = service.readBoard(num);
		if(dto == null || ! info.getUserId().equals(dto.getUserId())) {
			return "redirect:/?page=" + page;
		}
		
		model.addAttribute("dto", dto);
		model.addAttribute("mode", "update");
		model.addAttribute("page", page);
		
		return ".bbs.write";
	}
	
	@RequestMapping(value = "update", method = RequestMethod.POST)
	public String updateSubmit(
			Board dto,
			@RequestParam String page,
			HttpSession session) throws Exception {
		
		String root = session.getServletContext().getRealPath("/");
		String pathname = root + "uploads" + File.separator + "bbs";
		
		try {
			service.updateBoard(dto, pathname);
		} catch (Exception e) {
		}
		
		return "redirect:/?page="+page;
	}
	
	// 파일 삭제
	@RequestMapping("deleteFile")
	public String deleteFile(@RequestParam int num,
			@RequestParam String page,
			HttpSession session) throws Exception {
		
		// 수정에서 파일 삭제
		
		SessionInfo info = (SessionInfo)session.getAttribute("member");
		
		String root = session.getServletContext().getRealPath("/");
		String pathname = root + "uploads" + File.pathSeparator + "bbs";
		
		Board dto = service.readBoard(num);
		if(dto == null || ! info.getUserId().equals(dto.getUserId())) {
			return "redirect:/?page="+page;
		}
		
		try {
			if(dto.getSaveFilename() != null) {
				// 서버에 저장된 파일 삭제
				fileManager.doFileDelete(dto.getSaveFilename(), pathname);
				
				// 서버에 저장된 파일 이름 지우기
				dto.setSaveFilename("");
				dto.setOriginalFilename("");
				
				service.updateBoard(dto, pathname);
			}
		} catch (Exception e) {

		}
		
		// 다시 수정 화면으로
		return "redirect:/bbs/update?num="+num+"&page="+page;
	}
	
	@RequestMapping(value = "delete")
	public String delete(
			@RequestParam int num,
			@RequestParam String page,
			@RequestParam(defaultValue = "all") String condition,
			@RequestParam(defaultValue = "") String keyword,
			HttpSession session) throws Exception {
		
		SessionInfo info = (SessionInfo)session.getAttribute("member");
		
		keyword = URLDecoder.decode(keyword, "utf-8");
		String query = "page=" + page;
		if(keyword.length() != 0) {
			query += "&condition="+condition+"&keyword="+URLEncoder.encode(keyword, "utf-8");
		}
		
		String root = session.getServletContext().getRealPath("/");
		String pathname = root + "uploads" + File.separator + "bbs";
		
		service.deleteBoard(num, pathname, info.getUserId(), info.getMembership());
		
		return "redirect:/?"+query;
	}
	
	// 파일 다운로드
	@RequestMapping(value = "download")
	public void download(@RequestParam int num,
			HttpServletRequest req, HttpServletResponse resp,
			HttpSession session) throws Exception {
		
		String root = session.getServletContext().getRealPath("/");
		String pathname = root + "uploads" + File.separator + "bbs";
		
		logger.debug("debug log={}", pathname); // log4j
		Board dto = service.readBoard(num);
		
		if(dto != null) {
			boolean b = fileManager.doFileDownload(dto.getSaveFilename(), 
					dto.getOriginalFilename(), pathname, resp);
			if( b) {
				return;
			}
		}
		
		// 다운로드가 실패 한 경우
		resp.setContentType("text/html; charset=utf-8");
		PrintWriter out = resp.getWriter();
		out.print("<script>alert('파일 다운로드가 실패 했습니다.'); history.back();</script>");
	}
	
	// 게시글 좋아요 등록/삭제 : AJAX - JSON
	@RequestMapping(value = "insertBoardLike", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> insertBoardLike(
			@RequestParam int num,
			@RequestParam boolean userLiked,
			HttpSession session
			) throws Exception {
		
		String state = "true";
		int boardLikeCount = 0;
		SessionInfo info = (SessionInfo)session.getAttribute("member");
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		paramMap.put("num", num);
		paramMap.put("userId", info.getUserId());
		
		try {
			if(userLiked) {
				service.deleteBoardLike(paramMap);
			} else {
				service.insertBoardLike(paramMap);
			}
		} catch (DuplicateKeyException e) {
			state = "liked";
		} catch (Exception e) {
			state = "false";
		}
		
		boardLikeCount = service.boardLikeCount(num);
		
		Map<String, Object> model = new HashMap<String, Object>();
		model.put("state", state);
		model.put("boardLikeCount", boardLikeCount);
		
		return model;
	}
	
	// 댓글 및 댓글의 답글 등록 : AJAX
	@RequestMapping(value = "insertReply", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> insertReply(
			Reply dto, HttpSession session) throws Exception {
		SessionInfo info = (SessionInfo)session.getAttribute("member");
		String state = "true";
		
		try {
			dto.setUserId(info.getUserId());
			service.insertReply(dto);
		} catch (Exception e) {
			state = "false";
		}
		
		Map<String, Object> model = new HashMap<String, Object>();
		
		model.put("state", state);
		
		return model;
	}
	
	// 게시글에 대한 댓글 리스트 : AJAX - Text
	@RequestMapping(value = "listReply", method = RequestMethod.GET)
	public String listReply(
			@RequestParam int num,
			@RequestParam(value = "pageNo", defaultValue = "1") int current_page,
			Model model) throws Exception {
		
		int rows = 5;
		int total_page = 0;
		int dataCount = 0;
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("num", num);
		
		dataCount = service.replyCount(map);
		total_page = myUtil.pageCount(rows, dataCount);
		if(current_page > total_page) {
			current_page = total_page;
		}
		
		int start = (current_page - 1) * rows + 1;
		int end = current_page * rows;
		map.put("start", start);
		map.put("end", end);
		
		List<Reply> listReply = service.listReply(map);
		
		for(Reply dto : listReply) {
			dto.setContent(dto.getContent().replaceAll("\n", "<br>"));
		}
		
		// 자바스크립트 함수를 호출하는 페이징 처리
		String paging = myUtil.pagingMethod(current_page, total_page, "listPage");
		
		model.addAttribute("listReply", listReply);
		model.addAttribute("pageNo", current_page);
		model.addAttribute("replyCount", dataCount);
		model.addAttribute("total_page", total_page);
		model.addAttribute("paging", paging);
		
		// JSP로 포워딩
		return "bbs/listReply";
	}
	
	// 댓글에 대한 답글 리스트 - AJAX : Text
	@RequestMapping(value = "listReplyAnswer", method = RequestMethod.GET)
	public String listReplyAnswer(
			@RequestParam int answer, Model model) throws Exception  {
		
		List<Reply> list = service.listReplyAnswer(answer);
		for(Reply dto : list) {
			dto.setContent(dto.getContent().replaceAll("\n", "<br>"));
		}
		
		model.addAttribute("listReplyAnswer", list);
		
		return "bbs/listReplyAnswer";
	}
	
	// 댓글의 답글 개수 - AJAX : JSON
	@RequestMapping(value = "countReplyAnswer")
	@ResponseBody
	public Map<String, Object> countReplyAnswer(@RequestParam int answer) throws Exception {
		int count = service.replyAnswerCount(answer);
		
		Map<String, Object> model = new HashMap<String, Object>();
		model.put("count", count);
		
		return model;
	}
	
	@RequestMapping(value = "deleteReply", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> deleteReply(
			@RequestParam Map<String, Object> paramMap) throws Exception {
		
		String state = "true";
		try {
			service.deleteReply(paramMap);
		} catch (Exception e) {
			state = "false";
		}
		
		Map<String, Object> model = new HashMap<String, Object>();
		model.put("state", state);
		
		return model;
	}
	
	// 댓글의 좋아요/싫어요 추가 : AJAX - JSON
	@RequestMapping(value = "insertReplyLike", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> insertReplyLike(
			@RequestParam Map<String, Object> paramMap,
			HttpSession session
			) throws Exception {
		
		SessionInfo info = (SessionInfo)session.getAttribute("member");
		String state = "true";
		
		Map<String, Object> model = new HashMap<String, Object>();

		try {
			paramMap.put("userId", info.getUserId());
			service.insertReplyLike(paramMap);
		} catch (DuplicateKeyException e) {
			state = "liked"; // 해당 댓글에 유저가 좋아요/싫어요를 한 경우
		} catch (Exception e) {
			state = "false";
		}
		
		// 좋아요/싫어요 개수 가져오기
		Map<String, Object> countMap = service.replyLikeCount(paramMap);
		
		// MariaDB는 그대로 가져옴(소문자, 대문자 구분)
		// 마이바티스에서 resultType이 map이고 결과가 int이면 BigDecimal로 넘어옴
		// 오라클은 실행결과의 컬럼명은 모두 대문자로 넘어옴.
		int likeCount = ((BigDecimal)countMap.get("LIKECOUNT")).intValue();
		int disLikeCount = ((BigDecimal)countMap.get("DISLIKECOUNT")).intValue(); 
		
		model.put("state", state);
		model.put("likeCount", likeCount);
		model.put("disLikeCount", disLikeCount);
		
		return model;
	}
	
}
