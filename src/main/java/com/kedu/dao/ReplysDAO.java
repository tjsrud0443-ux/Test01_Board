package com.kedu.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.BeanPropertyRowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.kedu.dto.ReplysDTO;

@Repository
public class ReplysDAO {
	
	@Autowired
	private JdbcTemplate jdbc;

	public int insert(ReplysDTO dto, int parent_seq) {
		String sql = "insert into replys values(replys_seq.nextval,?,?,sysdate,?)";
		
		return jdbc.update(sql, dto.getWriter(), dto.getContents(), parent_seq);
	}
	
	public List<ReplysDTO> selectAll(){ 
		String sql = "select * from replys order by write_date desc";
		
		return jdbc.query(sql, new BeanPropertyRowMapper<ReplysDTO>(ReplysDTO.class));
	}
}