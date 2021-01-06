package com.gojls.manage.common.dao;

import java.util.List;

import com.gojls.manage.common.model.DeptModel;

public interface DeptDao {
	public List<DeptModel> selectDeptTopList();
	public List<DeptModel> selectDeptSecList(int parentDeptSeq);
	public List<DeptModel> selectDeptList();
}
