package com.kedu.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.kedu.dao.ReplysDAO;
import com.kedu.dto.ReplysDTO;

@Controller
@RequestMapping("/replys")
public class ReplysController{
	
	@Autowired
	private ReplysDAO dao;
	
	
	@RequestMapping("/insert")
	public String insert(ReplysDTO dto, int parent_seq) {
		int result = dao.insert(dto, parent_seq);
		
		if(result > 0) {
			System.out.println("댓글 등록 성공");
			System.out.println(dto.getSeq());
			System.out.println(dto.getContents());
			System.out.println(parent_seq);
		}else {
			System.out.println("댓글 등록 실패");
		}
		return "redirect:/boards/detail?seq="+ parent_seq;
	}
}