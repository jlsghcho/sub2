package com.gojls.manage.common.dao;

import java.util.List;

import com.gojls.manage.common.model.AdModel;
import com.gojls.manage.common.model.SearchModel;

public interface AdDao {
	public List<AdModel> selectAdCode(String ad_code);
	public List<AdModel> selectAdSubCode(String ad_code);
	public List<AdModel> selectAdList(SearchModel searchVo);
	public int selectAdListCnt(SearchModel searchVo);

	public int inAd(AdModel adVo);
	public int upAd(AdModel adVo);
	public int checkAd(AdModel adVo);
	public AdModel selectAdView(int param_seq);

	public List<AdModel> selectDirectList(SearchModel searchVo);
	public int selectDirectListCnt(SearchModel searchVo);
}
