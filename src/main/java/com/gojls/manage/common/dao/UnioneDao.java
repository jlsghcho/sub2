package com.gojls.manage.common.dao;

import java.util.List;

import com.gojls.manage.common.model.DeptModel;
import com.gojls.manage.common.model.ScheduleLogModel;
import com.gojls.manage.common.model.SearchModel;
import com.gojls.manage.common.model.UnioneDeptModel;

public interface UnioneDao {
	public List<DeptModel> selectUnioneSyncList(SearchModel searchVo);
	public int selectUnioneSyncListCnt(SearchModel searchVo);
	
	public List<DeptModel> selectCourseCode();
	public List<DeptModel> selectDeptCode(String courseSeq);
	public List<UnioneDeptModel> selectDeptList(UnioneDeptModel unioneVo);
	public int insertScheduleLog(ScheduleLogModel schVo);
	public int margeDeptApi(UnioneDeptModel unioneVo);
}
