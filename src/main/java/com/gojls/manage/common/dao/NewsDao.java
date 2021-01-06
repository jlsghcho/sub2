package com.gojls.manage.common.dao;

import java.util.List;
import java.util.Map;

import com.gojls.manage.common.model.NewsModel;
import com.gojls.manage.common.model.SearchModel;
import com.gojls.manage.common.model.TagModel;

public interface NewsDao {
	public List<NewsModel> selectNewsList(SearchModel searchVo);
	public int selectNewsListCnt(SearchModel searchVo);
	public List<TagModel> selectNewsTag();
	public NewsModel selectNewsView(int param_seq);
	public List<TagModel> selectNewsTagView(int param_contnt_seq);
	
	public int insNewsContnt(NewsModel newsVo);
	public int insNews(NewsModel newsVo);
	public int upNewsContnt(NewsModel newsVo);
	public int upNews(NewsModel newsVo);
	
	public int delTagContnt(int branchContentSeq);
	public int insTagContnt(Map<String, Object> map);
}
