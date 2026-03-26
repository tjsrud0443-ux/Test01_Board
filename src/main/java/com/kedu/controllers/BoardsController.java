package com.kedu.controllers;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.Gson;
import com.kedu.dao.BoardsDAO;
import com.kedu.dao.FilesDAO;
import com.kedu.dao.ReplysDAO;
import com.kedu.dto.BoardsDTO;
import com.kedu.dto.ReplysDTO;

@Controller
@RequestMapping("/boards")
public class BoardsController {

	@Autowired
	private BoardsDAO boardsDao;

	@Autowired
	private FilesDAO filesDao;

	@Autowired
	private Gson gson;
	
	@Autowired
	private ReplysDAO rdao;
	
	
	
	@RequestMapping("/list")
	public String toBoard(int cPage, Model model, HttpSession session) {
		
		
		List<BoardsDTO> list = boardsDao.getFromTo(cPage * 10 - 9, cPage * 10);
		// Board ���̺��� �����Ͱ� �� ����� ���´�
		//		int recordTotalCount = list.size();
		int recordTotalCount = boardsDao.totalCount();
		model.addAttribute("naviCountPerPage", 10);
		model.addAttribute("recordCountPerPage", 10);
		model.addAttribute("recordTotalCount", recordTotalCount);
		model.addAttribute("cPage", cPage);
		session.setAttribute("cPage", cPage);
		model.addAttribute("list", list);
		return "boards/boardsMain";
	}

	@RequestMapping("/toBoardPost")
	public String toBoardPost() {
		return "boards/boardsPost";
	}

	@RequestMapping("/toBoardDetail")
	public String toBoardDetail() {
		return "boards/boardsDetail";
	}

	// �� ���ε�
	@RequestMapping("/postUpload")
	public String postUp(BoardsDTO dto) throws Exception {

		int nextVal = boardsDao.getNextval();
		System.out.println(dto.getWriter());
		System.out.println(dto.getTitle());

		int result = boardsDao.postUpload(nextVal, dto);

		// file �ø��� ��

		return "redirect:/boards/list?cPage=1";
	}

	
		// ��ȸ�� ���� �� detail ���ε�
		@RequestMapping("/detail")
		public String detail(int seq, Model model) {
			
			// ��ȸ�� ���� dao
			BoardsDTO dto = boardsDao.lookDetail(seq);
			model.addAttribute("dto", dto);
			// ���ϸ� �����ֱ�

			// ��� dto ��۸��Ȯ��
			
			return "boards/boardsDetail";

		}

		// �� ����
		@RequestMapping("/delete")
		public String del(int seq,HttpSession session) {
			
			int cPage = (Integer)(session.getAttribute("cPage"));
			int result = boardsDao.deleteContent(seq);

			if (result > 0) {
				System.out.println("��������");
			}
			return "redirect:/boards/list?cPage="+cPage;
		}

		// �� ����
		@RequestMapping("/update")
		public String up(BoardsDTO dto, int seq) {

			int result = boardsDao.updateContent(dto);

			if (result > 0) {
				System.out.println("�Խñ� ������Ʈ ����");
			}
			return "redirect:/boards/detail?seq=" + seq;
		}

		@ExceptionHandler(Exception.class)
		public String exceptionHandler(Exception e) {
			e.printStackTrace();
			return "error";
		}
		
		@ResponseBody()
		@RequestMapping("/replyList")
		public String replyList(int seq) {
			List<ReplysDTO> list = rdao.selectAll(); // 댓글
			
			String result = gson.toJson(list); // dto를 Json문법으로 직렬화해라.
			System.out.println(result);
			
			return result;
		}
	}
