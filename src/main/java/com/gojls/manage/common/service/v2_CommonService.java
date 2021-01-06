package com.gojls.manage.common.service;

import java.util.List;
import java.util.Map;

import org.springframework.transaction.annotation.Transactional;

import com.gojls.manage.common.model.v2_BannerModel;
import com.gojls.manage.common.model.v2_DeptModel;
import com.gojls.manage.common.model.v2_IRFileModel;
import com.gojls.manage.common.model.v2_IRModel;
import com.gojls.manage.common.model.v2_NewsModel;
import com.gojls.manage.common.model.v2_SearchModel;
import com.gojls.manage.common.model.v2_SyncModel;
import com.gojls.manage.common.model.v2_TagModel;
import com.gojls.manage.member.model.EmpModel;

@Transactional(readOnly=true, rollbackFor={Exception.class})
public interface v2_CommonService {
	/* 공통영역 부분 */
	public List<v2_DeptModel> sv_select_dept_top_list(v2_DeptModel deptVo);
	public List<v2_DeptModel> sv_select_dept_course_list();
	public List<v2_DeptModel> sv_select_dept_sub_list(int parent_dept_seq);
	public List<v2_TagModel> sv_select_tag_view_list();
	public List<v2_TagModel> sv_select_tag_box_list();
	public List<v2_DeptModel> sv_select_dept_abroad_list(v2_SearchModel schVo);
	public List<v2_DeptModel> sv_select_dept_abroad_user(v2_SearchModel schVo);
	public List<v2_DeptModel> sv_select_dept_list();
	
	/* 배너 세팅 */
	public List<v2_BannerModel> sv_select_banner_list(v2_SearchModel schVo);
	public int sv_banner_save(v2_BannerModel bannerVo);
	public int sv_banner_delete(v2_BannerModel bannerVo);
	
	/* 싱크 */
	public List<v2_SyncModel> sv_select_sync_list(v2_SearchModel schVo);
	public int sv_exec_sync(v2_SyncModel sync_vo);
	
	/* 공지 세팅 */
	public List<v2_NewsModel> sv_select_news_list(v2_SearchModel schVo);
	public v2_NewsModel sv_select_news_view(v2_NewsModel newsVo);
	public int sv_news_save(v2_NewsModel newsVo);
	public int sv_news_delete(int notice_content_seq);
	
	public List<v2_TagModel> sv_select_tag_list(v2_SearchModel schVo);
	public List<String> sv_select_tag_view(int notice_content_seq);
	public int sv_select_tag_save(v2_TagModel tagVo);
	public int sv_select_tag_remove(v2_TagModel tagVo);
	
	/* IR 세팅 */
	public List<v2_IRModel> sv_select_ir_list(v2_SearchModel schVo);
	public List<v2_IRFileModel> sv_select_ir_file_list(int ir_board_seq);
	public v2_IRModel sv_select_ir_view(v2_IRModel irVo);
	public int sv_ir_save(v2_IRModel irVo);
	public int sv_ir_delete(v2_IRFileModel irFileVo);
	
	
	public Object select_dept_news_top_list();
	public Object sv_select_news_chessplus_view(Map<String, Object> param);
	public int sv_news_chessplus_save(v2_NewsModel newsVo);
	public int sv_news_chessplus_delete(int notice_content_seq);
	public List<String> sv_select_chessplus_tag_view(int notice_content_seq);
	
	public Object select_dept_combobox_list(Map<String, Object> cookieMap, String string);
	
}
