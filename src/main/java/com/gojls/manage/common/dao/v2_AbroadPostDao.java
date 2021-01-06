package com.gojls.manage.common.dao;


import java.util.List;
import java.util.Map;

import com.gojls.manage.common.model.v2_SiteContentModel;
import com.gojls.manage.common.model.v2_SiteCounselModel;
import com.gojls.manage.common.model.v2_SiteFileModel;
import com.gojls.manage.common.model.v2_SiteReportModel;
import com.gojls.manage.common.model.v2_SiteSearchModel;
import com.gojls.manage.common.model.v2_SiteTagModel;

public interface v2_AbroadPostDao {
	public List<v2_SiteTagModel> select_site_post_tag(v2_SiteSearchModel searchVo);
	public int insert_site_post_tag(v2_SiteTagModel tagVo);
	public int update_site_post_tag(v2_SiteTagModel tagVo);
	public int update_site_post_tag_sort(v2_SiteTagModel tagVo);
	
	public List<v2_SiteContentModel> select_site_content_list(v2_SiteSearchModel searchVo);
	public int insert_site_content(v2_SiteContentModel contentVo);
	public int update_site_content(v2_SiteContentModel contentVo);
	public int delete_site_content(v2_SiteContentModel contentVo);
	public int delete_site_content_tag(v2_SiteContentModel contentVo);
	public int insert_site_content_tag(Map<String, Object> param_map);
	public v2_SiteContentModel select_site_content_detail(int site_content_seq);
	
	public List<v2_SiteCounselModel> select_site_counsel_list(v2_SiteSearchModel searchVo);
	public int insert_site_counsel(v2_SiteCounselModel counselVo);
	public int insert_site_counsel_reply(v2_SiteCounselModel counselVo);
	public int update_site_counsel_reply(v2_SiteCounselModel counselVo);
	public List<v2_SiteCounselModel> select_site_counsel_view(int site_counsel_seq);
	public List<v2_SiteFileModel> select_site_counsel_reply_file(int site_counsel_reply_seq);
	
	public int update_site_counsel(int site_counsel_seq);
	public int update_site_counsel_cnt(int site_counsel_reply_seq);
	
	public int delete_site_counsel_file(int site_counsel_seq);
	public int delete_site_counsel_reply(int site_counsel_seq);
	public int delete_site_counsel(int site_counsel_seq);
	public int delete_site_counsel_file_p(int site_counsel_reply_seq);
	public int delete_site_counsel_reply_p(int site_counsel_reply_seq);
	public int insert_site_counsel_file(Map<String, Object> map);
	public int update_site_counsel_read_save(int param_site_counsel_seq);
	
	public List<v2_SiteReportModel> select_site_report_list(v2_SiteSearchModel searchVo);
	public int insert_site_report(v2_SiteReportModel reportVo);
	public int update_site_report(v2_SiteReportModel reportVo);
	public int delete_site_report_file(int site_report_user_seq);
	public int insert_site_report_file(Map<String, Object> map);
	
	public int del_site_report_file(int site_report_user_seq);
	public int delete_site_report(int site_report_user_seq);
	public List<v2_SiteReportModel> select_site_report_view(int site_report_user_seq);
	
}
