package com.gojls.manage.common.dao;

import java.util.List;
import java.util.Map;

import com.gojls.manage.common.model.v2_IRFileModel;
import com.gojls.manage.common.model.v2_IRModel;
import com.gojls.manage.common.model.v2_NewsModel;
import com.gojls.manage.common.model.v2_SearchModel;
import com.gojls.manage.common.model.v2_TagModel;

public interface v2_IRDao {
	public List<v2_IRModel> select_ir_list(v2_SearchModel schVo);
	public v2_IRModel select_ir_view(v2_IRModel irVo);
	
	public int insert_ir(v2_IRModel irVo);
	public int update_ir(v2_IRModel irVo);
	public int delete_ir(int ir_board_seq);

	public int insert_ir_file(v2_IRFileModel irFileVo);
	public int update_ir_file(v2_IRFileModel irFileVo);	
	public int delete_ir_file(v2_IRFileModel irFileVo);
		
}
