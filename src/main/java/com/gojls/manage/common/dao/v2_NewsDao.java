package com.gojls.manage.common.dao;

import java.util.List;
import java.util.Map;

import com.gojls.manage.common.model.v2_NewsModel;
import com.gojls.manage.common.model.v2_SearchModel;
import com.gojls.manage.common.model.v2_TagModel;

public interface v2_NewsDao {
	public List<v2_NewsModel> select_news_list(v2_SearchModel schVo);
	public v2_NewsModel select_new_view(v2_NewsModel newsVo);
	public int insert_news_save(v2_NewsModel newsVo);
	public int insert_news_content_save(v2_NewsModel newsVo);
	public int update_news_save(v2_NewsModel newsVo);
	public int update_news_content_save(v2_NewsModel newsVo);
	
	public int delete_news(int notice_content_seq);
	public int delete_news_content(int notice_content_seq);
	
	public int delete_tag_content(int notice_content_seq);
	public int insert_tag_content(Map<String, Object> map);
	
	public List<v2_TagModel> select_tag_list(v2_SearchModel schVo);
	public List<String> select_tag_view(int notice_content_seq);
	public int insert_tag_save(v2_TagModel tagVo);
	public int update_tag_save(v2_TagModel tagVo);
	public int update_tag_mainview_change(v2_TagModel tagVo);
	public int delete_tag_save(v2_TagModel tagVo);
	
	
	public v2_NewsModel select_news_chessplus_view(Map<String, Object> param);
	public void update_news_chessplus_save(v2_NewsModel newsVo);
	public void insert_news_chessplus_save(v2_NewsModel newsVo);
	public int delete_news_chessplus(int notice_content_seq);
	public int delete_chessplus_tag_content(int notice_content_seq);
	public int insert_chessplus_tag_content(Map<String, Object> tag_map);
	public List<String> select_chessplus_tag_view(int notice_content_seq);
}
