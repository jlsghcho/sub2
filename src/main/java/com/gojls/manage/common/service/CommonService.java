package com.gojls.manage.common.service;

import java.util.List;
import java.util.Map;

import org.springframework.transaction.annotation.Transactional;

import com.gojls.manage.common.model.AdModel;
import com.gojls.manage.common.model.DeptModel;
import com.gojls.manage.common.model.NewsModel;
import com.gojls.manage.common.model.SearchModel;
import com.gojls.manage.common.model.TagModel;
import com.gojls.manage.common.model.UnioneDeptModel;

@Transactional(readOnly=true, rollbackFor={Exception.class})
public interface CommonService {
	public Map<String, Object> selectNewsList(SearchModel searchVo);
	public NewsModel selectNewsView(int param_seq);
	public List<TagModel> selectTagView(int param_contnt_seq);
	
	public Map<String, Object> setNewsSave(NewsModel newsVo);
	
	public Map<String, Object> selectTagList(SearchModel searchVo);
	public Map<String, Object> setTagSave(TagModel tagVo);
	public List<TagModel> getTagMainView();
	
	public Map<String, Object> selectAdList(SearchModel searchVo);
	public Map<String, Object> selectDirectList(SearchModel searchVo);
	public Map<String, Object> setAdSave(AdModel adVo);
	public AdModel selectAdView(int param_seq);
	
	/* 코드 */
	public List<TagModel> selectGetCodeTag();
	public List<DeptModel> selectGetCodeDept();
	public List<DeptModel> selectGetCodeDeptTop();
	public List<DeptModel> selectGetCodeDeptSec(int parentDeptSeq);
	public List<AdModel> selectGetCodeAd(String ad_code);
	public List<AdModel> selectGetCodeAdSub(String ad_code);
	public List<DeptModel> selectGetCodeCourse();
	public List<DeptModel> selectGetCodeCourseDept(String courseSeq);
	
	/* 유니원 관련 */
	public Map<String, Object> selectUnioneSyncList(SearchModel searchVo);
	public Map<String, Object> setUnioneSync(UnioneDeptModel unioneVo);
}
