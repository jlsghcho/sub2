package com.gojls.manage.common.dao;

import java.util.List;
import java.util.Map;

import com.gojls.manage.common.model.v2_DeptModel;
import com.gojls.manage.common.model.v2_SearchModel;
import com.gojls.manage.common.model.v2_TagModel;
import com.gojls.manage.member.model.EmpModel;

public interface v2_CommonDao {
	public List<v2_DeptModel> select_dept_top_list(v2_DeptModel deptVo);
	public List<v2_DeptModel> select_dept_sub_list(v2_DeptModel deptVo);
	public List<v2_DeptModel> select_dept_course_list();
	public List<v2_DeptModel> select_abroad_dept_list(v2_SearchModel searchVo);
	public List<v2_DeptModel> select_abroad_dept_user(v2_SearchModel searchVo);
	public List<v2_DeptModel> select_dept_list();
	
	/* TAG */
	public List<v2_TagModel> select_tag_view_list();
	public List<v2_TagModel> select_tag_box_list();
	public List<v2_DeptModel> select_dept_news_top_list();
	public List<Map<String, Object>> select_dept_combobox_list();
	
}
