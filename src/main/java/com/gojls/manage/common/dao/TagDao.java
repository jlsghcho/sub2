package com.gojls.manage.common.dao;

import java.util.List;

import com.gojls.manage.common.model.SearchModel;
import com.gojls.manage.common.model.TagModel;

public interface TagDao {
	public List<TagModel> selectTagList(SearchModel searchVo);
	public int selectTagListCnt(SearchModel searchVo);
	
	public int selectTagCheck(TagModel tagVo);
	public int insTag(TagModel tagVo);
	public int upTag(TagModel tagVo);
	
	public List<TagModel> selectTagMainView();
}
