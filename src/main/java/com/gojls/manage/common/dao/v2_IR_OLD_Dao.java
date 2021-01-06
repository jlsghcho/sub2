package com.gojls.manage.common.dao;

import java.util.List;

import com.gojls.manage.common.model.v2_IRFileModel;
import com.gojls.manage.common.model.v2_IRModel;
import com.gojls.manage.common.model.v2_SearchModel;

public interface v2_IR_OLD_Dao {
	public List<v2_IRModel> select_ir_list(v2_SearchModel schVo);
	public List<v2_IRFileModel> select_ir_file_list(int ir_board_seq);
	public v2_IRModel select_ir_view(v2_IRModel irVo);
	
	public int insert_ir_board(v2_IRModel irVo);
	public int update_ir_board(v2_IRModel irVo);
	public int delete_ir_board(int ir_board_seq);

	public int insert_ir_board_file(v2_IRFileModel irFileVo);
	public int update_ir_board_file(v2_IRFileModel irFileVo);
	public int delete_ir_board_file(v2_IRFileModel irFileVo);
	
	
	
	
		
}
