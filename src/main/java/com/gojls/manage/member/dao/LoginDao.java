package com.gojls.manage.member.dao;

import java.util.List;
import java.util.Map;

import com.gojls.manage.member.model.EmpModel;

public interface LoginDao {
	public EmpModel selectGetEmp(EmpModel empVo);
	public EmpModel selectGetEmpExt(EmpModel empVo);
	public List<EmpModel> selectGetEmpDept(String param_emp_seq);
	public List<Map<String, String>> selectAuthMenuList(EmpModel empVo);
	
}
