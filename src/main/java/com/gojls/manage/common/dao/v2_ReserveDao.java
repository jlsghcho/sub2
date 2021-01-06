package com.gojls.manage.common.dao;

import java.util.List;

import com.gojls.manage.common.model.v2_ReserveCampUserModel;
import com.gojls.manage.common.model.v2_ReserveMstModel;
import com.gojls.manage.common.model.v2_ReserveProgramModel;
import com.gojls.manage.common.model.v2_ReserveSeminarUserModel;
import com.gojls.manage.common.model.v2_SearchModel;

public interface v2_ReserveDao {
	public List<v2_ReserveMstModel> select_reserve_list(v2_SearchModel schVo);
	public int insert_reserve_mst(v2_ReserveMstModel reserveMstVo);
	public int update_reserve_mst(v2_ReserveMstModel reserveMstVo);	
	public int delete_reserve_mst(int site_reserve_mst_seq);

	//public Map<String, Object> select_reserve_info(v2_ReserveMstModel reserveMstVo);
	public List<v2_ReserveMstModel> select_reserve_info(v2_ReserveMstModel reserveMstVo);
	
	public int insert_reserve_program(v2_ReserveProgramModel reserveProgramVo);
	public int update_reserve_program(v2_ReserveProgramModel reserveProgramVo);	
	public int delete_reserve_program(v2_ReserveProgramModel reserveProgramVo);
	
	public int delete_reserve_siminar_user(v2_ReserveSeminarUserModel reserveSeminarUserVo);
	public int delete_reserve_camp_user(v2_ReserveCampUserModel reserveCampUserVo);
	
	public List<v2_ReserveSeminarUserModel> select_reserve_seminar_user_list(v2_SearchModel schVo);
	public int insert_reserve_seminar_user_save(v2_ReserveSeminarUserModel reserveSeminarUserVo);

	public List<v2_ReserveCampUserModel> select_reserve_camp_user_list(v2_SearchModel schVo);
	public int insert_reserve_camp_user(v2_ReserveCampUserModel reserveCampUserVo);
	public int update_reserve_camp_user(v2_ReserveCampUserModel reserveCampUserVo);
	
	public int cnt_reserve_program(v2_ReserveProgramModel reserveProgramVo);
	public int cnt_reserve_program_user(v2_ReserveProgramModel reserveProgramVo);
	
	public v2_ReserveProgramModel select_reserve_program(int site_reserve_program_seq);
	
}
