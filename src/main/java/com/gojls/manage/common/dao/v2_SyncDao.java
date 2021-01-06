package com.gojls.manage.common.dao;

import java.util.List;

import com.gojls.manage.common.model.v2_ScheduleLogModel;
import com.gojls.manage.common.model.v2_SearchModel;
import com.gojls.manage.common.model.v2_SyncModel;
import com.gojls.manage.common.model.v2_SyncUnioneModel;

public interface v2_SyncDao {
	public List<v2_SyncModel> select_sync_list(v2_SearchModel schVo);
	public List<v2_SyncUnioneModel> select_sync_dept_list(v2_SyncModel syncVo);
	public int insert_schedule_log(v2_ScheduleLogModel schlog_vo);
	public int marge_dept_api(v2_SyncUnioneModel unione_vo);
}
